%特征提取
%性别
%周早餐消费总金额     周午餐消费总金额       周晚餐消费总金额
%周早餐次数           周午餐次数             周晚餐次数
%周总消费金额         周总吃饭次数           日均消费金额

clc, clear;
Tx = readmatrix("..\题目\附件0 性别标签.xlsx", 'Range', "A2:B5416");
filename = ["..\数据\第一年三餐消费数据改.xlsx";  "..\数据\第二年三餐消费数据改.xlsx"; 
    "..\数据\第三年三餐消费数据改.xlsx"];
range = ["B2:AGG5416";  "B2:ST5416";   "B2:AEW5416"];
%将三年的数据汇总
% for i = 2:3
%     t = readmatrix(filename(i), 'Range', range(i));
%     [~, nt] = size(t);
%     T(:, n + 1:n + nt) = t;
%     n = n + nt;
% end

for k = 1:3
    T = readmatrix(filename(k), 'Range', range(k));
    [m, n] = size(T);


    %第一行为 特征值的序号
    x = zeros(m + 1, 11, 1);   x(2:end, 1) = 1:m;  x(2:end, 2) = Tx(:, 2);   x(1, 2:11) = 1:10;
    for i = 1:m
        s1 = 0;     s2 = 0;     s3 = 0;
        s4 = 0;     s5 = 0;     s6 = 0;
        s7 = 0;     s8 = 0;     s9 = 0;

        for j = 1:n
            %周早餐消费总金额     周午餐消费总金额       周晚餐消费总金额
            %周早餐次数           周午餐次数             周晚餐次数
            %周总消费金额         周总吃饭次数           日均消费金额

            f = mod(j, 3);
            %i == 1:早餐
            if f == 1
                s1 = s1 + T(i, j);
                if T(i, j) > 0
                    s4 = s4 + 1;
                end
            elseif f == 2
                %i == 2:午餐
                s2 = s2 + T(i, j);
                if T(i, j) > 0
                    s5 = s5 + 1;
                end
            else
                %i == 0:晚餐
                s3 = s3 + T(i, j);
                if T(i, j) > 0
                    s6 = s6 + 1;
                end
            end
        end
        s1 = s1 / (n / 21);     s2 = s2 / (n / 21);     s3 = s3 / (n / 21);
        s4 = s4 / (n / 21);     s5 = s5 / (n / 21);     s6 = s6 / (n / 21);
        s7 = s1 + s2 + s3;      s8 = s4 + s5 + s6;      s9 = s7 / 7;

        i = i + 1;
        x(i, 3) = s1;            x(i, 4) = s2;          x(i, 5) = s3;
        x(i, 6) = s4;            x(i, 7) = s5;          x(i, 8) = s6;
        x(i, 9) = s7;            x(i, 10) = s8;          x(i, 11) = s9;
        i = i - 1;
    end


    c = x(2:end, 2:end);
    %部分人不在食堂吃饭
    p1 = find(sum(c, 2) == 0); lenp1 = length(p1);           %女生0
    p2 = find(sum(c, 2) == 1); lenp2 = length(p2);           %男生1
    p = zeros(lenp1 + lenp2, 2, 1);
    p(1:lenp1, 1:2) = [p1, zeros(lenp1, 1, 1)];
    p(lenp1 + 1: lenp1 + lenp2, 1:2) = [p2, ones(lenp2, 1, 1)];

    %去除不在食堂吃饭的人
    xp(1, :) = x(1, :); ip = 2;
    for i = 2:m + 1
        if sum(p(:, 1) == x(i, 1)) == 0
            xp(ip, :) = x(i, :); ip = ip + 1;
        end
    end
    %更新x
    clearvars x;
    x = xp;
    [m, n] = size(x);

    im = 2; iw = 2;
    xm(1, 1:10) = [0, 2:10];    xw(1, 1:10) = [0, 2:10];
    for i = 2:m
        if x(i, 2) == 1 % 女生0 男生1
            xm(im, 1:10) = [x(i, 1), x(i, 3:end)]; im = im + 1;
        else
            xw(iw, 1:10) = [x(i, 1), x(i, 3:end)]; iw = iw + 1;
        end
    end

    writematrix(x, string(['..\数据\特征提取', num2str(k), '.xlsx']));
%     writematrix(xm, string(['..\数据\特征提取男', num2str(k), '.xlsx']));
%     writematrix(xw, string(['..\数据\特征提取女', num2str(k), '.xlsx']));
    writematrix(p,  string(['..\数据\不在食堂吃饭的人', num2str(k), '.xlsx']));
end