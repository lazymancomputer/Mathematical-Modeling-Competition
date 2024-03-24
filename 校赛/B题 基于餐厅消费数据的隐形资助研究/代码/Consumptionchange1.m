clc, clear;
%周总消费金额变化趋势
filename = ["..\数据\第一年三餐消费数据改.xlsx"; 
    "..\数据\第二年三餐消费数据改.xlsx";  "..\数据\第三年三餐消费数据改.xlsx"];
range = ["B2:AGG5416";   "B2:ST5416";   "B2:AEW5416"];
%将三年的数据汇总
T = readmatrix(filename(1), 'Range', range(1));
[m, n] = size(T);
for i = 2:3
    t = readmatrix(filename(i), 'Range', range(i));
    [~, nt] = size(t);
    T(:, n + 1:n + nt) = t;
    n = n + nt;
end

xm = readmatrix("..\数据\特征提取男总.xlsx", 'Range', 'A2:J3943');
xw = readmatrix("..\数据\特征提取女总.xlsx", 'Range', 'A2:J1204');

%第一列为序号，第二列为等级
dm = [1, 1; 11, 2; 10, 3];
dw = [2, 1; 3, 2; 5, 3];
%提取周总消费金额变化趋势
s = zeros(6, n / 21, 1);
for i = 1:6
    if i >= 4
        t = dw(i - 3, 1);
    else
        t = dm(i, 1);
    end

    for j = 1:21:n
        for k = j:j+20
            s(i, ceil(j / 21)) = s(i, ceil(j / 21)) + T(t, k);
        end
        s(i, ceil(j / 21)) = s(i, ceil(j / 21));
    end
end

%绘图
[ms, ns] = size(s);
for i = 1:ms
    figure;
    plot(1:ns, s(i, :));
    xlim([1 110]);
    xlabel("周数");
    ylabel("周总消费金额");
    title("周总消费金额变化趋势");
end

writematrix(s, "..\数据\周总消费金额变化趋势.xlsx");