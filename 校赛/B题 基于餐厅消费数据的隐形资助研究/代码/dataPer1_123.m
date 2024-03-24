clc, clear;
filename = ["..\题目\附件1第一年三餐消费数据.xlsx";
    "..\题目\附件2 第二年三餐消费数据.xlsx";
    "..\题目\附件3 第三年三餐消费数据.xlsx"];

tname = ["..\数据\第一年三餐用餐人次情况"; 
    "..\数据第二年三餐用餐人次情况"; "..\数据第三年三餐用餐人次情况"];
%统计每餐用餐人次
for k = 1:3
    T = readcell(filename(k), 'Range', 'A1:APG5416');
    x = cell2mat(T(2:end, 2:end));
    switch k
        case 1
            T1 = T;
        case 2
            T2 = T;
        case 3
            T3 = T;
    end

    [m, n] = size(x);
    c = sum(x > 0);

    a = T(1, 2:end);
    ac = string(zeros(1, numel(a)));
    for i = 1:numel(a)
        ac(i) = cell2mat(a(i));
    end
    ta = table(ac', c');
%     writetable(ta, ['..\数据\每日用餐人数统计', num2str(k), '.xlsx']);

    %     figure;
    %     plot(1:n, c, 'o')
    %     xticks(1:90:n);
    %     xlabel("时间(每个刻度间隔代表一个月)");
    %     ylabel("每餐用餐人次");
    %     title(tname(k))
end

s = ["2019.01.19", "2019.02.22", "2019.02.29", "2019.07.15", "2019.08.25", "-";
    "2020.01.06", "2020.07.18",  "-",          "-",          "-",          "-";
    "2021.01.10", "2021.03.02",  "2021.04.16", "2021.04.21", "2021.08.01", "2021.08.31"];
lo = zeros(3, 6, 1);
%去除寒暑假的影响
for i = 1:3
    switch i
        case 1
            cp = T1;
        case 2
            cp = T2;
        case 3
            cp = T3;
    end

    for j = 1:5
        for k = 1:1099
            if contains(cp{1, k}, s(i, j))
                lo(i, j) = k;
            end
        end
    end
end
lo = lo - 3;

% 2018.09.01~2019.1.18，     2019.2.23~2019.02.28,            2019.03.01~2019.7.14，          2019.08.25~2019.08.31
ct1(2:5416, :) = [T1(2:end, 1:lo(1, 1)), T1(2:end, lo(1, 2) + 4:lo(1, 3)), T1(2:end, lo(1, 3) + 4:lo(1, 4)), T1(2:end, lo(1, 5) + 4:end)];
ct1(1, :) =      [T1(1, 1:lo(1, 1)),     T1(1, lo(1, 2) + 4:lo(1, 3)),     T1(1, lo(1, 3) + 4:lo(1, 4)),     T1(1, lo(1, 5) + 4:end)];

%2019.09.01~2020.01.05， 2020.07.19~2020.08.31
ct2(2:5416, :) = [T2(2:end, 1:lo(2, 1)), T2(2:end, lo(2, 2) + 4:end)];
ct2(1, :) = [T2(1, 1:lo(2, 1)), T2(1, lo(2, 2) + 4:end)];

%2020.09.01~2021.01.09,     2021.03.03~2021.04.15,  2021.04.22~2021.07.31
ct3(2:5416, :) = [T3(2:end, 1:lo(3, 1)), T3(2:end, lo(3, 2) + 4:lo(3, 3)), T3(2:end, lo(3, 4) + 4:lo(3, 5))];
ct3(1, :) = [T3(1, 1:lo(3, 1)), T3(1, lo(3, 2) + 4:lo(3, 3)), T3(1, lo(3, 4) + 4:lo(3, 5))];


%处理离群值
for p = 1:3
    if p == 1
        tx = cell2mat(ct1(2:end, 2:end));
    elseif p == 2
        tx = cell2mat(ct2(2:end, 2:end));
    else
        tx = cell2mat(ct3(2:end, 2:end));
    end
    
    [mt, nt] = size(tx);
    for i = 1:mt
        %统计早餐，午餐，晚餐
        x1 = zeros(nt / 3, 1, 1); x2 = zeros(nt / 3, 1, 1); x3 = zeros(nt / 3, 1, 1);
        k1 = 1;                   k2 = 1;                   k3 = 1;
        for j = 1:nt
            flag = mod(j, 3);
            if flag == 1
                %早餐
                x1(k1, 1) = tx(i, j); k1 = k1 + 1;
            elseif flag == 2
                %午餐
                x2(k2, 1) = tx(i, j); k2 = k2 + 1;
            else
                %晚餐
                x3(k3, 1) = tx(i, j); k3 = k3 + 1;
            end
        end

        %分别对早餐，午餐，晚餐进行离群值处理
        for k = 1:3
            if k == 1
                x = x1;
            elseif k == 2
                x = x2;
            else
                x = x3;
            end
            % 计算分位数的函数需要MATLAB安装了统计机器学习工具箱
            Q1 = prctile(x, 25); % 下四分位数
            Q3 = prctile(x, 75); % 上四分位数
            IQR = Q3 - Q1; % 四分位距
            lb = Q1 - 1.5 * IQR; % 下界
            ub = Q3 + 1.5 * IQR;% 上界
            tmp = (x < lb) | (x > ub);
            ind = find(tmp);
            %将异常值视作缺失值
            x(ind) = nan;

            %处理缺失值,用平均值填充
            avg = 0;    cnt = 0;
            for j = 1:length(x)
                if ~isnan(x(j))
                    avg = avg + x(j);
                    cnt = cnt + 1;
                end
            end
            avg = round(avg / cnt);
            for j = 1:length(x)
                if isnan(x(j))
                    x(j) = avg;
                end
            end
            %     作图对比

            if k == 1
                fg = x1;
            elseif k == 2
                fg = x2;
            else
                fg = x3;
            end

            %     yyaxis left
            %     plot(1:nt - 1, x);
            %     ylim([0 ub + 1000])
            %     yyaxis right
            %     plot(1:nt - 1, fg);
            %     ylim([0 ub + 1000])

            %         figure;    boxplot(fg);     ylabel("每餐用餐金额(单位：分)");
            %         title("第一年序号为1的同学的早餐金额箱线图(未去除离群值)");
            %         figure;    boxplot(x);      ylabel("每餐用餐金额(单位：分)");
            %         title("第一年序号为1的同学的早餐金额箱线图(去除了离群值)");

            if k == 1
                x1 = x;
            elseif k == 2
                x2 = x;
            else
                x3 = x;
            end
        end

        k1 = 1;                   k2 = 1;                   k3 = 1;
        for j = 1:nt
            flag = mod(j, 3);
            if flag == 1
                %早餐
                tx(i, j) = x1(k1, 1); k1 = k1 + 1;
            elseif flag == 2
                %午餐
                tx(i, j) = x2(k2, 1); k2 = k2 + 1;
            else
                %晚餐
                tx(i, j) = x3(k3, 1); k3 = k3 + 1;
            end
        end
    end
    
    if p == 1
        ct1(2:end, 2:end) = num2cell(tx);
    elseif p == 2
        ct2(2:end, 2:end) = num2cell(tx);
    else
        ct3(2:end, 2:end) = num2cell(tx);
    end
end


%记录数据
writecell(ct1, "..\数据\第一年三餐消费数据改.xlsx");
writecell(ct2, "..\数据\第二年三餐消费数据改.xlsx");
writecell(ct3, "..\数据\第三年三餐消费数据改.xlsx");