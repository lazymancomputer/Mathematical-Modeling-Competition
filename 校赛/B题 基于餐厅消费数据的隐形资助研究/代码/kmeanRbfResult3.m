%将rbf和k-mean的结果综合
clc, clear;
%k-means结果变换
km = [1, 0, 2;  0, 1, 2;    0, 1, 2];

filekm = ["..\数据\贫困标签预测值和相对误差kmeans3_1.xlsx";
    "..\数据\贫困标签预测值和相对误差kmeans3_2.xlsx";
    "..\数据\贫困标签预测值和相对误差kmeans3_3.xlsx"];
rangekm = 'A2:B302';
filerbf = ["..\数据\贫困标签预测值和相对误差rbf3_1.xlsx";
    "..\数据\贫困标签预测值和相对误差rbf3_2.xlsx";
    "..\数据\贫困标签预测值和相对误差rbf3_3.xlsx"];
rangerbf = ["A1:B53"; "A1:B301"; "A2:B301"];
fT = readmatrix(filerbf(1), 'Range', rangerbf(1));
kT = readmatrix(filekm(1), 'Range', rangekm);
%循环处理kmean结果
for i = 1:length(kT)
    kT(i, 2) = km(1, kT(i, 2));
end
fT(:, 3) = zeros(length(fT), 1, 1) - 1;
for i = 1:length(fT)
    lo = find(fT(i, 1) == kT(:, 1));
    fT(i, 3) = round((fT(i, 2) + kT(lo, 2)) / 2);
end
writematrix([fT(:, 1), fT(:, 3)], "..\数据\kmeanRbf方法确定的贫困标签1.xlsx");

%第二年
for year = 2:3
    fT = readmatrix(filerbf(year), 'Range', rangerbf(year));
    kT = readmatrix(filekm(year), 'Range', rangekm);
    %循环处理kmean结果
    for i = 1:length(kT)
        if isnan(kT(i, 2))
            %不在食堂里吃饭的人
            kT(i, 2) = 0;
        else
            kT(i, 2) = km(year, kT(i, 2));
        end
    end

    %汇总rbf的结果
    fT(:, 3) = zeros(length(fT), 1, 1) - 1;
    for i = 1:length(fT)
        if isnan(fT(i, 2))
            %不在食堂里吃饭的人
            kT(i, 2) = 0;
        end
        lo = find(fT(i, 1) == kT(:, 1));
        fT(i, 3) = round((fT(i, 2) + kT(lo, 2)) / 2);
    end
    writematrix([fT(:, 1), fT(:, 3)], string(['..\数据\kmeanRbf方法确定的贫困标签', num2str(year), '.xlsx']));
end
