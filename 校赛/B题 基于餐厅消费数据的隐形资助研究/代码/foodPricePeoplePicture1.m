%六个代表，食物种类到1~3，画6个图，
clc, clear
filename = ["..\数据\1-100000改.xlsx"; "..\数据\100001-200000改.xlsx";
    "..\数据\200001-300000改.xlsx"; "..\数据\300001-331258改.xlsx"];

range = ["A1:D100001"; "A1:D100001"; "A1:D100001"; "A1:D31259"];
T = readcell(filename(1), 'Range', range(1));
Ts = readcell("..\数据\不同食物及其价格.xlsx", "Range", 'A1:B167');
[m, n] = size(Ts);
for i = 1:m
    sn(i, 1) = string(Ts{i, 1});
    sp(i, 1) = Ts(i, 2);
end

%第一列为序号，第二列为等级
dm = [3062, 1; 76, 2; 3207, 3];
dw = [1275, 1; 5001, 2; 3272, 3];

%1~52是低价食品，53~163为平价食品，164~167为高价食品
for i = 1:6
    if i == 5
        continue;
    end
    if i >= 4
        t = dw(i - 3, 1);
    else
        t = dm(i, 1);
    end
    lo = find(t == cell2mat(T(2:end, 1)));
    fn(1, 1) = "食物"; fk = 1;
    for j = 1:length(lo)
        fn(fk, 1) = string(T{lo(j), 4});   fk = fk + 1;
    end
    %记录对应食品的等级
    for j = 1:fk - 1
        lf = find(sn == fn(j));
        if lf < 53
            fp(j, 1) = 1;
        elseif lf < 164
            fp(j, 1) = 2;
        else
            fp(j, 1) = 3;
        end
    end

    %绘图
    figure;
    plot(1:length(fp), fp, 'o');
    xlabel("食物等级");
    ylabel("刷卡记录(单位：次)")
    title("饮食等级图");
end

%单独处理女生5001
t = dw(2, 1);
T = readcell(filename(2), 'Range', range(2));
lo = find(t == cell2mat(T(2:end, 1)));
fn(1, 1) = "食物"; fk = 1;
for j = 1:length(lo)
    fn(fk, 1) = string(T{lo(j), 4});   fk = fk + 1;
end
%记录对应食品的等级
for j = 1:fk - 1
    lf = find(sn == fn(j));
    if lf < 53
        fp(j, 1) = 1;
    elseif lf < 164
        fp(j, 1) = 2;
    else
        fp(j, 1) = 3;
    end
end

%绘图
figure;
plot(1:length(fp), fp, 'o');
xlabel("食物等级");
ylabel("刷卡记录(单位：次)")
title("饮食等级图");