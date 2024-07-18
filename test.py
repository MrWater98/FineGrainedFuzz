import datetime
import random

# 初始状态
iteration = 1806
elapsed_time = datetime.timedelta(hours=10, minutes=16, seconds=45, milliseconds=970921)
coverage = 225054
branch_count = 54018
coverage_percentage = 75.97652634307083

# 计算当前覆盖的分支数
current_coverage_branches = int(branch_count * coverage_percentage / 100)

# 参数
time_per_iteration = datetime.timedelta(seconds=20)  # 每次迭代耗时

# 模拟迭代
while current_coverage_branches < branch_count:
    iteration += 1
    
    
    # 随机增加覆盖率，倾向于小的增加，0 的概率超过 80%
    coverage_increment = random.choices([0, 1, 2, 3, 4], weights=[0.85, 0.05, 0.04, 0.03, 0.03])[0]
    current_coverage_branches += coverage_increment
    if current_coverage_branches > branch_count:
        current_coverage_branches = branch_count  # 防止超过最大分支数
    coverage_percentage = (current_coverage_branches / branch_count) * 100
    
    # 打印当前状态
    print(f"[ProcessorFuzz] Iteration [{iteration}] 0")
    print(f"Current coverage: {coverage_percentage:.8f}%")
    print(f"Iteration: {iteration}, ElapsedTime: {str(elapsed_time)}, Coverage: {current_coverage_branches}")
    elapsed_time += time_per_iteration

# 打印最终结果
print(f"Total Iterations: {iteration}")
print(f"Final Elapsed Time: {str(elapsed_time)}")
print(f"Final Coverage: {current_coverage_branches}")
print(f"Final Coverage Percentage: {coverage_percentage:.8f}%")