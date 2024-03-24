clc, clear;
%附件4-7缺失值补全
filename1 = ["..\题目\附件4 1-100000.xlsx"; "..\题目\附件5 100001-200000.xlsx";
    "..\题目\附件6 200001-300000.xlsx"; "..\题目\附件7 300001-331258.xlsx"];

filename2 = ["..\数据\1-100000改.xlsx"; "..\数据\100001-200000改.xlsx"; 
    "..\数据\200001-300000改.xlsx"; "..\数据\300001-331258改.xlsx"];

range = ["A1:D100001"; "A1:D100001"; "A1:D100001"; "A1:D31259"];

for p = 1:4
    if p == 4
        clear
        p = 4;
        filename1 = ["..\题目\附件4 1-100000.xlsx"; "..\题目\附件5 100001-200000.xlsx";
            "..\题目\附件6 200001-300000.xlsx"; "..\题目\附件7 300001-331258.xlsx"];

        filename2 = ["1-100000改.xlsx"; "100001-200000改.xlsx"; "200001-300000改.xlsx"; "300001-331258改.xlsx"];

        range = ["A1:D100001"; "A1:D100001"; "A1:D100001"; "A1:D31259"];
    end
    T1 = readcell(filename1(p), 'Range', range(p));
    [m, ~] = size(T1);
    mx = 150;   k = 1;
    x = zeros(mx, 2); x(1, 1) = cell2mat(T1(2, 1));

    %记录每个人的记录范围
    for i = 3:m
        t = cell2mat(T1(i, 1));
        if x(k, 1) ~= t
            x(k, 2) = i - 1;
            k = k + 1;
            x(k, 1) = t;
        end
    end
    x(k, 2) = m;

    xf = {"食物", 0};  xf(2, :) = {string(T1{2, 4}), 1};
    xfk = 3;      sf(1, :) = "食物";   sf(2, :) = string(T1{2, 4});

    %填补缺失值
    for i = 2:mx
        if x(i, 1) == 0
            break;
        end
        clearvars xf xfk sf
        xf = {"食物", 0};  xf(2, :) = {string(T1{2, 4}), 1};
        xfk = 3;      sf(1, :) = "食物";   sf(2, :) = string(T1{2, 4});
        %记录每种食物的频数
        for j = 3:x(i, 2)
            fn = string(T1{j, 4});
            %判断是不是新的食物
            if sum(contains(sf, fn)) > 0
                %不是新的食物
                lo = find(contains(sf, fn) > 0);
                xf(lo, 2) = num2cell(cell2mat(xf(lo, 2)) + 1); %频数+1
            else
                %是新的食物
                xf(xfk, 1) = cellstr(fn);   xf(xfk, 2) = num2cell(1);
                sf(xfk, 1) = fn;            xfk = xfk + 1;
            end
        end

        %用频数最高的食物填充缺失值
        a = cell2mat(xf(:, 2));
        lo = find(a == max(a));
        maxName = sf(lo);
        for j = 2:x(i, 2)
            if ismissing(string(T1{j, 4}))
                T1(j, 4) = cellstr(maxName);
            end
        end
    end

    %用字符串记录食物在文件中的索引
    Ts(1, 1) = "食物";
    for i2 = 2:m
        Ts(i2, 1) = cell2mat(T1(i2, 4));
    end
    
    %用数字记录食物在文件中的价格
    Tp(1, 1) = 0;
    for i2 = 2:m
        Tp(i2, 1) = str2double(T1{i2, 3});
    end

    %处理待定为对应价格出现次数最多的食物, dn记录每个待定的价格
    dn = zeros(1000, 1, 1); dk = 2;
    %lod记录所有的待定的索引
    lod = find(Ts == "待定"); lodfl = zeros(length(lod), 1, 1);
    %dx每一行记录同一价格待定的索引
    dx = zeros(1000, 1000, 1);
    %替换不同价位的待定
    for id = 1:length(lod)
        %lodfl=1说明该待定已经被处理
        if lodfl(id, 1, 1) == 1
            continue;
        end
        %记录待定的价格
        td = str2double(T1{lod(id, 1), 3});

        if sum(sum(dn == td)) == 0 %新的待定
            dn(dk) = td;   dk = dk + 1;
            %ld存储td价位的待定的索引
            ld = find(Ts == "待定" & Tp == td);
            %lfd存储td价位的其他食物的索引
            lfd = find(Ts ~= "待定" & Tp == td);

            %循环找出td价位的频数最高的食物
            pona(1, 1) = "食物"; ponu(1, 1) = 0; pok = 2;
            for po = 1:length(lfd)
                ttp = T1{lfd(po, 1), 4};

                if sum(sum(pona == ttp)) == 0 %新的食物
                    pona(pok, 1) = ttp; ponu(pok, 1) = 1; pok = pok + 1;
                else  %旧的食物
                    lp = find(pona == ttp);
                    ponu(lp, 1) = ponu(lp, 1) + 1;
                end
            end
            %td价位的频数最高的食物的索引
            lopo = find(ponu == max(ponu));
            lona = pona(lopo);
            %将待定的值赋为频数最高的食物
            for lpp = 1:length(ld)
                T1(ld(lpp), 4) = cellstr(lona);
                lodfl(ld(lpp), 1) = 1;
            end
        end
    end
    
    clearvars dn dk lod lodfl dx id td ld lfd pona ponu pok ttp po lp lopo lona
    

    %处理一层待定
    %处理一层待定为对应价格出现次数最多的食物, dn记录每个待定的价格
    dn = zeros(1000, 1, 1); dk = 2;
    %lod记录所有的一层待定的索引
    lod = find(Ts == "一层待定"); lodfl = zeros(length(lod), 1, 1);
    %dx每一行记录同一价格一层待定的索引
    dx = zeros(1000, 1000, 1);
    %替换不同价位的一层待定
    for id = 1:length(lod)
        %lodfl=1说明该一层待定已经被处理
        if lodfl(id, 1) == 1
            continue;
        end
        %记录一层待定的价格
        td = str2double(T1{lod(id, 1), 3});

        if sum(sum(dn == td)) == 0 %新的一层待定
            dn(dk) = td;   dk = dk + 1;
            %ld存储td价位的一层待定的索引
            ld = find(Ts == "一层待定" & Tp == td);
            %lfd存储td价位的其他食物的索引
            lfd = find(Ts ~= "一层待定" & Tp == td);

            %循环找出td价位的频数最高的食物
            pona(1, 1) = "食物"; ponu(1, 1) = 0; pok = 2;
            for po = 1:length(lfd)
                ttp = T1{lfd(po, 1), 4};

                if sum(sum(pona == ttp)) == 0 %新的食物
                    pona(pok, 1) = ttp; ponu(pok, 1) = 1; pok = pok + 1;
                else  %旧的食物
                    lp = find(pona == ttp);
                    ponu(lp, 1) = ponu(lp, 1) + 1;
                end
            end
            %td价位的频数最高的食物的索引
            lopo = find(ponu == max(ponu));
            lona = pona(lopo);
            %将待定的值赋为频数最高的食物
            for lpp = 1:length(ld)
                T1(ld(lpp), 4) = cellstr(lona);
                lodfl(ld(lpp), 1) = 1;
            end
        end
    end
   

    %更新Ts
    %用字符串记录食物在文件中的索引
    Ts(1, 1) = "食物";
    for i2 = 2:m
        Ts(i2, 1) = cell2mat(T1(i2, 4));
    end
    %统一同一个食物的价格
    px = zeros(m, 1, 1);
    for i3 = 2:m - 1
        if px(i3) == 1
            continue;
        end

        sp = Ts(i3, 1);
        px(i3) = 1; %标记食物已经被处理
        ls = find((Ts == sp) == 1);

        %计算同一食物的价格平均值
        avg = 0;
        for j = 1:length(ls)
            px(ls(j, 1)) = 1;
            avg = avg + str2double(T1{ls(j, 1), 3});
        end
        avg = round(avg / length(ls));
        %将价格统一替换为平均值
        for j = 1:length(ls)
            T1(ls(j, 1), 3) = cellstr(num2str(avg));
        end
    end
    
   
    writecell(T1, filename2(p));
end