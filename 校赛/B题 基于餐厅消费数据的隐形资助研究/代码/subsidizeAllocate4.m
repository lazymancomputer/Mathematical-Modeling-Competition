%基于线性规划的资助分配
clc, clear
Tc = readmatrix("..\数据\kmeanRbf方法确定的贫困标签3.xlsx", 'Range', 'A1:B300');
Tx = readmatrix("..\数据\特征及食物提取3.xlsx", 'Range', 'A1:K3686'); % 第九列是周消费总额
w = readmatrix("..\数据\第三年三餐消费数据改.xlsx", 'Range', 'A2:AEW2');
week = (length(w) - 1) / 21;

%选择80个人
clearvars x;
xnk = 1;
for i = 1:300
    if Tc(i, 2) == 2
        lo = find(Tc(i, 1) == Tx(:, 1));
        if Tx(lo, 9) >= 1500    %剔除数据  
            x(xnk, :) = [Tc(i, :), Tx(lo, 9)]; 
            xnk = xnk + 1;
        end
    end
end
cnt = xnk - 1;
for i = 1:300
    if Tc(i, 2) == 1
        lo = find(Tc(i, 1) == Tx(:, 1));
        if Tx(lo, 9) >= 1500    %剔除数据  
            x(xnk, :) = [Tc(i, :), Tx(lo, 9)]; 
            xnk = xnk + 1;
        end
    end
end
xnk = xnk - 1;

%线性规划
c = x(1:80, 3) * week / 100;  s = sum(c);
M = 1e+6; tcAvg = (s + M) / 80;
%创建最小化优化问题
prob = optimproblem;
%创建优化变量，目标函数
t = optimvar('t', 80, 'LowerBound', 0, 'UpperBound', M / 10);
goal = ((t + c) - tcAvg) .* ((t + c) - tcAvg);
prob.Objective = mean(goal);
%创建线性约束
prob.Constraints.con1 = sum(t) == M;
%创建非线性约束
prob.Constraints.con2 = t + c - s / 80 >= 0;
%求解优化问题
[sol, fval, flag, out] = solve(prob);
res = round(sol.t);

ma = [x(1:80, 1), c, res];
writematrix(ma, "..\数据\差异化资助情况.xlsx");