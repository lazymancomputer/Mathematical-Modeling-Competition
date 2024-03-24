clear; clc;

T = readmatrix('数据\主成分分析.xlsx', 'Range', 'A2:AE4606');
[m1, m2] = size(T);


%决策矩阵d
x = zeros(m1+1, 28, 1);
x(1, :) = [1:6, 23,    7:11,24:26,   12, 1345, 16:22, 27:30];
x(2:end, 1:6) = T(:, 1:6);
x(2:end, 7) = T(:, 23);
x(2:end, 8:12) = T(:, 7:11);
x(2:end, 13:15) = T(:, 24:26);
x(2:end, 16) = T(:, 12);
x(2:end, 17) = T(:, 31);
x(2:end, 18:24) = T(:, 16:22);
x(2:end, 25:28) = T(:, 27:30);

d = x(2:end, :)';
[di, dj] = size(d);

t = d;
%决策矩阵标准化——模一化
for j = 1:dj
    d(:, j) = d(:, j) / sqrt(sum(d(:, j) .* d(:, j)));
end

%m较大时用极差法确定属性权重
f = max(d) - min(d);
w = f / sum(f);

%对效益型属性规范化处理
d = t;
maxd = max(d); mind = min(d);
d = (d - mind) ./ (maxd - mind);


%topsis法
v = zeros(di, dj, 1);
for j = 1:dj
    v(:, j) = d(:, j) * w(j);
end
%正负理想解
v_z = max(v);   v_f = min(v);

%与正理想解的距离
s_z = zeros(15, 1, 1);
for i = 1:di
    for j = 1:dj
        s_z(i, 1) = sqrt(sum((v(i, :) - v_z(j)) .* (v(i, :) - v_z(j))));
    end
end

%与负理想解的距离
s_f = zeros(15, 1, 1);
for i = 1:di
    for j = 1:dj
         s_f(i, 1) = sqrt(sum((v(i, :) - v_f(j)) .* (v(i, :) - v_f(j))));
    end
end

%灰色关联法
mmin_z = min(min(abs(v_z - v))); %两级最小差
mmax_z = max(max(abs(v_z - v))); %两级最大差
rho = 0.5; %分辨系数
%关联系数
r_z = (mmin_z + rho * mmax_z) ./ (abs(v_z - v) + rho * mmax_z);
%关联度
r_z = mean(r_z, 2);

mmin_f = min(min(abs(v_f - v))); %两级最小差
mmax_f = max(max(abs(v_f - v))); %两级最大差
%关联系数
r_f = (mmin_f + rho * mmax_f) ./ (abs(v_f - v) + rho *mmax_f);
%关联度
r_f = mean(r_f, 2);

%归一化
s_z = s_z / max(s_z); s_f = s_f / max(s_f);
r_z = r_z / max(r_z); r_f = r_f / max(r_f);

%相对贴近度
tt = s_f ./ (s_z + s_f);
ts = r_z ./ (r_f + r_z);

c = (tt + ts) / 2;
ct = table(x(1, :)', c);

writetable(ct, '数据\topsis_grey结果.xlsx');