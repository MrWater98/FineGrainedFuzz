import re

def count_branches(verilog_file):
    # Define branch keywords in Verilog
    branch_keywords = ['if', 'else if', 'else', 'case', 'default']
    
    # Initialize a dictionary to store counts of each branch keyword
    branch_counts = {keyword: 0 for keyword in branch_keywords}
    
    with open(verilog_file, 'r') as file:
        for line in file:
            # Strip comments and unnecessary whitespace
            line = re.sub(r'//.*', '', line).strip()
            
            # Check for each branch keyword in the line
            for keyword in branch_keywords:
                if keyword in line:
                    # Increment the count of the corresponding keyword
                    branch_counts[keyword] += line.count(keyword)
    
    return branch_counts

# Example usage
verilog_file = '/root/Fuzz_RTL/Benchmarks/Verilog/RocketTile_state.v'
branch_counts = count_branches(verilog_file)
print(f"Branch counts in {verilog_file}:")
for keyword, count in branch_counts.items():
    print(f"{keyword}: {count}")