%第三问提取特征, RBF神经网络
clc, clear;

filename = ["..\数据\特征及食物提取1.xlsx"; "..\数据\特征及食物提取2.xlsx"; "..\数据\特征及食物提取3.xlsx"];
range = "A1:N301";

year = 1;
tt = readmatrix(filename(year), 'Range', range);
Ts = readmatrix("..\题目\附件8 已知贫困标签.xlsx", 'Range', 'A2:B4416');
for i = 1:length(tt)
    lo = find(tt(i, 1) == Ts(:, 1));
    if isempty(lo)
        tt(i, 15) = -1;
    else
        tt(i, 15) = Ts(lo, 2);
    end
    %不在食堂吃的人认为不贫困
    if sum(tt(i, 3:11)) == 0
        tt(i, 15) = 0;
    end
end
txk = 1;
for i = 1:length(tt)
    if tt(i, 15) ~= -1
        tx(txk, :) = tt(i, :); txk = txk + 1;
    end
end
for i = 1:length(tt)
    if tt(i, 15) == -1
        tx(txk, :) = tt(i, :); txk = txk + 1;
    end
end

%253个人有贫困标签
k1 = 253;
a = tx(:, 2:end)';
%处理
a(14, :) = a(14, :) + 1;
%训练集200个，53个作为检验
pk = 200;
%规格化处理
P = a(1:13, 1:pk); [PN, PS1] = mapminmax(P); %自变量数据规格化到[-1,1]
T = a(14, 1:pk);   [TN, PS2] = mapminmax(T); %因变量数据规格化到[-1,1]

% load("net.mat");    load("PS1.mat");    load("PS2.mat");

netT = newrb(PN, TN);  %训练RBF网络
% save("netT.mat", "netT");

%预测样本点自变量规格化
pp = a(1:13, pk + 1:k1);   ppn = mapminmax('apply', pp, PS1);
%求预测值，并把数据还原
pn = sim(netT, ppn);  y1 = mapminmax('reverse', pn, PS2);

%计算相对误差
dt = abs(a(14, pk + 1:k1) - y1) ./ a(14, pk + 1:k1);
delta = mean(abs(a(14, pk + 1:k1) - y1) ./ a(14, pk + 1:k1));

y1 = abs(round(y1) - 1);
a(14, :) = a(14, :) - 1;
tx(pk + 1:k1, 15) = y1;
writematrix([tx(pk + 1:k1, 1), y1', dt'], "..\数据\贫困标签预测值和相对误差rbf3_1.xlsx");



%预测其他人的贫困标签
for year = 2:3
    tt = readmatrix(filename(year), 'Range', range);
    a = tt(:, 2:end)';

    %处理
    [~, n] = size(a);
    %规格化处理
    P = a(1:13, 1:n); [PN, PS1] = mapminmax(P); %自变量数据规格化到[-1,1]
    %     T = a(14, 1:pk);   [TN, PS2] = mapminmax(T); %因变量数据规格化到[-1,1]
    %预测样本点自变量规格化
    pp = a(1:13, :);   ppn = mapminmax('apply', pp, PS1);
    %求预测值，并把数据还原
    pn = sim(netT, ppn);  y1 = mapminmax('reverse', pn, PS2);

    y1 = abs(round(y1) - 1);
    tt(:, 15) = y1;
    writematrix([tt(:, 1), y1'], ['..\数据\贫困标签预测值和相对误差rbf3_',num2str(year), '.xlsx']);
end