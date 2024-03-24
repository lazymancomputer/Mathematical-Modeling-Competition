%绘制同一食物处理前后的价格对比图
clc, clear;
%未处理的
filename = "..\题目\附件4 1-100000.xlsx";
T = readcell(filename, 'Range', 'A1:D100001');
[m, ~] = size(T);
sn = "大灶稀饭";

Ts(1, 1) = "食物";
for i = 2:m
    Ts(i, 1) = T{i, 4};
end

lo = find(Ts == sn);
pr = zeros(length(lo), 1, 1);
for i = 1:length(lo)
    pr(i, 1) = str2double(T{lo(i, 1), 3});
end

%处理的
filename = "1-100000改.xlsx";
T = readcell(filename, 'Range', 'A1:D100001');
[m, ~] = size(T);

Ts(1, 1) = "食物";
for i = 2:m
    Ts(i, 1) = T{i, 4};
end

lo = find(Ts == sn);
px = str2double(T{lo(1, 1), 3});
pt = zeros(length(pr), 1, 1);
for i = 1:length(pr)
    pt(i, 1) = px;
end

figure
x = 1:length(pr);
plot(x, pr, x, pt, 'r');
ylabel("食物价格(单位：分)");
xlabel("食物出现次数");
title("大灶稀饭的价格处理前后对比(前蓝后红)");
xlim([0 750])