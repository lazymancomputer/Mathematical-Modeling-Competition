%统计所有的食物，并且划分为三个种类
clc, clear
filename = ["..\数据\1-100000改.xlsx"; "..\数据\100001-200000改.xlsx";
    "..\数据\200001-300000改.xlsx"; "..\数据\300001-331258改.xlsx"];

range = ["A2:D100001"; "A2:D100001"; "A2:D100001"; "A2:D31259"];

it = 1; Ts(1, 1) = "食物"; Tp = [];
for k = 1:4
    T = readcell(filename(k), 'Range', range(k));
    [m, n] = size(T);
    for i = 1:m
        if sum(Ts == T{i, 4}) == 0
            %记录新的食物和价格
            Ts(it, 1) = T{i, 4};   Tp(it, 1) = str2double(T{i, 3}); it = it + 1;
        end
    end
end
s = ["致远一层超市"; "深圳校区图书馆"; "游泳馆"];
Ts1(1, 1) = "食物"; Tp1 = []; ik = 1;
for i = 1:length(Ts)
    if sum(Ts(i, 1) == s) == 0
        Ts1(ik, 1) = Ts(i, 1); Tp1(ik, 1) = Tp(i, 1); ik = ik + 1;
    end

end
TT = {"食物", 0};
TT(1:length(Ts1), 1) = cellstr(Ts1(:, 1));
TT(1:length(Tp1), 2) = num2cell(Tp1(:, 1));
[~,ind] = sort(Tp1);
TT = TT(ind,:);

figure;
plot(1:length(Tp1), cell2mat(TT(:, 2)));
xlim([1 170]);
xlabel("不同食物");
ylabel("食物的价格(单位:分)");
title("不同食物价格变化图");

writecell(TT, "..\数据\不同食物及其价格.xlsx");