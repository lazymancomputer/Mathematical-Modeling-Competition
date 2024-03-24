# 绘制饮食情况柱状图
import numpy as np
import matplotlib.pyplot as plt
"""
男1女3
男生第一类 66.88103% 32.47588% 0.64309%
男生第二类 82.43752% 16.29579% 1.26669%
男生第三类 60.57392% 39.23893% 0.187149%
女生第一类 87.82743% 11.86441% 0.30817%
女生第二类 82.18479% 17.71312% 0.10209%
女生第三类 74.96839% 23.13527% 1.89633%
"""
# 指定默认字体：解决plot不能显示中文问题
plt.rcParams['font.sans-serif'] = ['Microsoft YaHei']
labels = ['低价位消费占比', '中价位消费占比', '高价位消费占比']
data = np.array([[66.88103, 74.96839], [32.47588, 23.13527], [0.64309, 1.89633]])
data = np.round(data, 2)
x = np.arange(len(labels))
width = 0.2  # the width of the bars
fig, ax = plt.subplots()
rects1 = ax.bar(x - width/2, data[:, 0], width, color='orange', label='男生')
rects2 = ax.bar(x + width/2, data[:, 1], width, color='tomato', label='女生')

ax.set_ylabel('消费占比(单位%)')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()

def autolabel(rects):
    """在*rects*中的每个柱状条上方附加一个文本标签，显示其高度"""
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3点垂直偏移
                    textcoords="offset points",
                    ha='center', va='bottom')

autolabel(rects1)
autolabel(rects2)
fig.tight_layout()

# 保存图片
loc = r'D:\大学学习\数学建模\比赛\校赛\B题 基于餐厅消费数据的隐形资助研究\图' + \
    '\\饮食情况柱状图.png'
fig.savefig(loc, dpi=500, bbox_inches="tight")
plt.show()