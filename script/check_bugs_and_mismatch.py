import sys
import re

def main(filename):
    bug_first_time = {}      # {bugid: (iteration, time)}
    mismatch_times = {}      # {bugid: [ (iteration, time) ]}
    mismatch_count = {}      # {bugid: count}
    normal_mismatches = []   # [(iteration, time, desc)]
    normal_mismatch_count = 0

    last_iter = None
    last_time = None
    parsing = True  # Flag to stop after ElapsedTime includes 'day'

    bug_re = re.compile(r"Bug\s+(\d+):")
    mismatch_bug_re = re.compile(r"\[ProcessorFuzz\] Bug -- (\d+) \[Mismatch\]")
    iter_re = re.compile(r"Iteration:\s*(\d+),\s*ElapsedTime:\s*([^,]+),")
    normal_mismatch_re = re.compile(r"^MISMATCH: (.+)")
    next_mismatch_is_bug = False

    with open(filename, encoding='utf8', errors='ignore') as f:
        for line in f:
            if not parsing:
                break

            # Track the most recent iteration and time
            m = iter_re.search(line)
            if m:
                last_iter = int(m.group(1))
                last_time = m.group(2)
                if 'day' in last_time:
                    parsing = False
                    break  # Stop parsing after this line

            # "Bug N:" first occurrence
            m = bug_re.search(line)
            if m and parsing:
                bugid = int(m.group(1))
                if bugid not in bug_first_time and last_iter is not None:
                    bug_first_time[bugid] = (last_iter, last_time)

            # "[FineGrainedFuzz] Bug -- N [Mismatch]"
            m = mismatch_bug_re.search(line)
            if m and parsing:
                bugid = int(m.group(1))
                if bugid not in mismatch_times:
                    mismatch_times[bugid] = []
                    mismatch_count[bugid] = 0
                if last_iter is not None:
                    mismatch_times[bugid].append( (last_iter, last_time) )
                mismatch_count[bugid] += 1
                next_mismatch_is_bug = True
                continue
            else:
                next_mismatch_is_bug = False

            # Plain MISMATCH (not followed by a bug mismatch)
            m = normal_mismatch_re.search(line)
            if m and parsing and not next_mismatch_is_bug:
                desc = m.group(1).strip()
                if last_iter is not None:
                    normal_mismatches.append( (last_iter, last_time, desc) )
                    normal_mismatch_count += 1

    # Output results
    print("==== First Occurrence of 'Bug N:' ====")
    for bugid in sorted(bug_first_time.keys()):
        iter_num, time_str = bug_first_time[bugid]
        print(f"Bug {bugid}: Iteration {iter_num}, ElapsedTime: {time_str}")

    print("\n==== [Mismatch] Bug Statistics ====")
    for bugid in sorted(mismatch_times.keys()):
        print(f"Bug -- {bugid} [Mismatch]: Occurred {mismatch_count[bugid]} times")
        print("  Occurrence times:")
        for iter_num, time_str in mismatch_times[bugid]:
            print(f"    Iteration {iter_num}, ElapsedTime: {time_str}")

    print("\n==== Plain MISMATCH Statistics ====")
    print(f"Plain MISMATCH: Occurred {normal_mismatch_count} times")
    for iter_num, time_str, desc in normal_mismatches:
        print(f"    Iteration {iter_num}, ElapsedTime: {time_str}, Content: {desc}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python bug_stat.py <logfile>")
        sys.exit(1)
    main(sys.argv[1])