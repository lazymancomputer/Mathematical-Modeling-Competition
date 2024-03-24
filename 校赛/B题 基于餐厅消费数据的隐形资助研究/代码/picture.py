# 绘制聚类折线图
import matplotlib.pyplot as plt

# 2, 3, 4, 8, 10
index = range(1, 4)
feature = [
    # 2 周早餐消费总金额
    [962.845534436950400, 1605.942055634135000, 475.266951490876750],
    # 3 周午餐消费总金额
    [3254.745166564475800, 4822.875436115039000, 1140.770930129060000],
    # 4 周晚餐消费总金额
    [914.872368689965100, 2704.826214049975000, 230.581522029372500],
    # 8 周总消费金额
    [5132.463069691395500, 9133.643705799148000, 1846.619403649308700],
    #10 日均消费金额
    [733.209009955914000, 1304.806243685593700, 263.802771949901700],
]
# 绘制一张空白图
fig, ax = plt.subplots()
# 指定默认字体：解决plot不能显示中文问题
plt.rcParams['font.sans-serif'] = ['Microsoft YaHei']
name = ['周早餐消费总金额', '周午餐消费总金额', '周晚餐消费总金额',
        '周总消费金额', '日均消费金额']
for i in range(5):
    ax.plot(index, feature[i], linewidth=3, label=name[i])  # 设置线宽为3

# 设置图表标题和坐标轴标签，并且设置字号
ax.set_xlabel("聚类中心", fontsize=14)
ax.set_ylabel("特征值", fontsize=14)
ax.set_xticks(index)
#自动检测要在图例中显示的元素，并且显示
ax.legend()
# 设置刻度标记的大小
plt.tick_params(axis="both", labelsize=14)

# 保存图片
loc = r'D:\大学学习\数学建模\比赛\校赛\B题 基于餐厅消费数据的隐形资助研究\图' + \
    '\\K-Means算法女生聚类结果可视化.png'
print("loc: ", loc)
fig.savefig(loc, dpi=500, bbox_inches="tight")

# 图形可视化
plt.show()