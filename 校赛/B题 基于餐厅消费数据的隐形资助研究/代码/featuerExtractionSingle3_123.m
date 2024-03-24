%第三问提取特征
clc, clear;

filename = ["..\数据\特征提取1.xlsx"; "..\数据\特征提取2.xlsx"; "..\数据\特征提取3.xlsx"];
range = ["A1:K5022"; "A2:K4301"; "A2:K3686"];

filenf = ["..\数据\1-100000改.xlsx"; "..\数据\100001-200000改.xlsx";
    "..\数据\200001-300000改.xlsx"; "..\数据\300001-331258改.xlsx"];
rangf = ["A1:D100001"; "A2:D100001"; "A2:D100001"; "A2:D31259"];

p = readmatrix("..\数据\附件4-7出现序号.xlsx", 'Range', 'F2:F302');
fp = readcell("..\数据\不同食物及其价格.xlsx", 'Range', 'A1:B167');

%1~52是低价食品，53~163为平价食品，164~167为高价食品
%记录食物名字
for i = 1:167
    fps(i, 1) = string(fp{i, 1});
end

xf = readcell(filenf(1), 'Range', rangf(1));
%将所有食物记录汇总
[mf, nf] = size(xf);
for i = 2:4
    xfp = readcell(filenf(i), 'Range', rangf(i));
    [mfp, nfp] = size(xfp);
    xf(mf + 1:mf + mfp, :) = xfp;
    mf = mf + mfp;
end

%表明食物的种类
for i = 1:mf
    lo = find(xf{i, 4} == fps);
    if lo <= 52
        xf(i, 5) = num2cell(0);
    elseif lo <= 163
        xf(i, 5) = num2cell(1);
    else
        xf(i, 5) = num2cell(2);
    end
end

%按时间排序
tm = xf(2:end, :);
a2 = string(cell2mat(tm(:, 2)));
[~, ind] = sort(a2);
tm = tm(ind, :);
xf(2:end, :) = tm;

%第二年数据起始点
k1 = 173973;
%第三年数据起始点
k2 = 227883;
%保存序号
xfpi = zeros(mf, 1, 1); xfpi(1, 1) = -1;
xfpn(1, 1) = "时间";
for i = 2:mf
    xfpi(i) = xf{i, 1};
    xfpn(i, 1) = xf{i, 2};
end
clearvars xfp mfp nfp ind a2;


for year = year:3
    xt = readmatrix(filename(year), 'Range', range(year));

    %存储最终的特征值
    tt(:, 1) = p;
    [mt, nt] = size(tt);
    %循环每一个人
    for i = 1:mt
        %序号
        temp = tt(i, 1);
        % 在已经提取的人里找
        lo = find(temp == xt(:, 1));
        if isempty(lo)
            tt(i, 2:11) = zeros(10, 1, 1);
        else
            tt(i, 2:11) = xt(lo, 2:11);
        end

        %查找序号对应的食物记录
        lop = find(temp == cell2mat(xf(2:end, 1)));
        lop = lop + 1;

        %记录每种食物出现的次数
        times = zeros(3, 1, 1);
        for j = 1:length(lop)
            t = lop(j);

            if year == 1
                if t >= k1
                    break;
                end
                times(xf{t, 5} + 1) = times(xf{t, 5} + 1) + 1;
            elseif year == 2
                if t < k1
                    continue;
                end
                if t >= k2
                    break;
                end
                times(xf{t, 5} + 1) = times(xf{t, 5} + 1) + 1;
            else
                if t < k2
                    continue;
                end
                times(xf{t, 5} + 1) = times(xf{t, 5} + 1) + 1;
            end
        end

        times = times / sum(times);
        tt(i, 12:14) = times;
    end

    writematrix(tt, ['..\数据\特征及食物提取', num2str(year), '.xlsx']);
end