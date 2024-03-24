clc, clear
xt = readmatrix("..\数据\特征提取1.xlsx", 'Range', 'A2:K5022');
t = readmatrix("..\题目\附件8 已知贫困标签.xlsx", 'Range', 'A2:B4416');
% pt = zeros(1000, 2, 1);
pt(:, 1) = readmatrix("..\题目\附件9 问题2待补全标签数据.xlsx", 'Range', 'A2:A1001');
px = readmatrix("..\数据\不在食堂吃饭的人1.xlsx", 'Range', 'A1:A394');

[m, n] = size(xt);
xt(:, n + 1) = -1; n = n + 1;

cnt = 0;%空数据
for i = 1:m
    lo = find(t(:, 1) == xt(i, 1));
    if isempty(lo)
        cnt = cnt + 1;
        continue;
    end
    xt(i, n) = t(lo, 2);
end

%空数据
xk = 1;
for i = 1:m
    if xt(i, n) == -1
        continue;
    end
    tt(xk, :) = xt(i, :); xk = xk + 1;
end
xkk = xk;
for i = 1:m
    if xt(i, n) == -1
        tt(xkk, :) = xt(i, :); xkk = xkk + 1;
    end
end
xkk = xkk - 1; xk = xk - 1;

a = tt(:, 2:end)';
%处理
a(11, :) = a(11, :) + 1;
%规格化处理
pk = 4000;
P = a(1:10, 1:pk); [PN, PS1] = mapminmax(P); %自变量数据规格化到[-1,1]
T = a(11, 1:pk);   [TN, PS2] = mapminmax(T); %因变量数据规格化到[-1,1]

load("net.mat");
% net = newrb(PN, TN);  %训练RBF网络
% save("net.mat", "net");

%预测样本点自变量规格化
x = a(1:10, pk + 1:xk);  xn = mapminmax('apply', x, PS1);
%求预测值，并把数据还原
yn1 = sim(net, xn);    y1 = mapminmax('reverse', yn1, PS2);
%计算RBF网络预测的相对误差
dt = abs(a(11, pk + 1:xk) - y1) ./ a(11, pk + 1:xk);
delta = mean(abs(a(11, pk + 1:xk) - y1) ./ a(11, pk + 1:xk));

y1 = round(abs(y1 - 1));    a(11, :) = a(11, :) - 1;
writematrix([tt(pk + 1:xk, 1), y1', dt'], "..\数据\贫困标签预测值和相对误差rbf2_1.xlsx");

%补全附件9
%预测样本点自变量规格化
pp = tt(xk + 1:xkk, 2:11)';  ppn = mapminmax('apply', pp, PS1);
%求预测值，并把数据还原
pn = sim(net, ppn);    yt = mapminmax('reverse', pn, PS2);
%yt = round(yt);
yt = abs(round(yt));
tt(xk + 1:xkk, 12) = yt';

for i = 1:length(pt)
    lop1 = find(pt(i) == tt(:, 1));
    lop2 = find(pt(i) == px(:, 1));
    if isempty(lop1)
        if ~isempty(lop2)
            pt(i, 2) = 0;
            %             disp(i);
        end
    else
        pt(i, 2) = tt(lop1, 12);
    end
end
writematrix(pt, "..\数据\问题2标签数据补全.xlsx");

%预测第2,3年的贫困程度
filename = ["..\数据\特征提取2.xlsx"; "..\数据\特征提取3.xlsx"];    range = ["A2:K4301"; "A2:K3686"];
filenameP = ["..\数据\不在食堂吃饭的人2.xlsx"; "..\数据\不在食堂吃饭的人3.xlsx"];
fp = ["..\数据\第二年个人贫困程度.xlsx"; "..\数据\第三年个人贫困程度.xlsx"];
rangeP = ["A1:A1115"; "A1:A1730"];

for k = 1:2
    xtt = readmatrix(filename(k), 'Range', range(k));
    xp = readmatrix(filenameP(k), 'Range', rangeP(k));
    a = xtt(:, 2:end)';

    P = a(1:10, :); [PN, PS1] = mapminmax(P); %自变量数据规格化到[-1,1]
    %预测样本点自变量规格化
    pp = a;  ppn = mapminmax('apply', pp, PS1);
    %求预测值，并把数据还原
    pn = sim(net, ppn);  yt = mapminmax('reverse', pn, PS2);
    yt = abs(round(yt));

    xtt(:, 12) = yt';
    mtt = length(xtt);  xpk = 1;
    for i = mtt + 1:5415
        xtt(i, :) = [xp(xpk, 1), zeros(1, 10, 1) - 1, 0];   xpk = xpk + 1;
    end
    writematrix([xtt(:, 1), xtt(:, end)], fp(k));
end