###############################################################
#
# # https://reneshbedre.github.io/blog/anova.html
#
###############################################################

import pandas as pd
import matplotlib.pyplot as plt
import scipy.stats as stats
import statsmodels.api as sm  # get ANOVA table as R like output
from statsmodels.formula.api import ols

column = []
index_column = []
for i in range(0, 15):
    column.append(str(i + 1))
    index_column.append(i + 1)


# load data file
# d = pd.read_csv("", sep="\t")
d_1 = pd.read_csv("woofer_oneway_attr1.csv", header=None, names=column)
# print(d_1)
# d_1.head()
d_2 = pd.read_csv("woofer_oneway_attr2.csv", header=None, names=column)
d_3 = pd.read_csv("woofer_oneway_attr3.csv", header=None, names=column)


##### DATA DISTRIBUTION BY GROUPS to detect differences between them
#
# depicting groups of numerical
# data through their quartiles
#
#
### SAVE PLOTS
box_woofer_attr1 = plt.figure()
plt.title("Boxplot for Attribute 1")
plt.ylabel("Ratings on combination of speakers/tracks")
plt.xlabel("Listener")
output_woofer_attr1 = d_1.boxplot(column, grid=False)
box_woofer_attr1.savefig("boxplot_attr1_woofer.png", format="png")

box_woofer_attr2 = plt.figure()
plt.title("Boxplot for Attribute 2")
plt.ylabel("Ratings on combination of speakers/tracks")
plt.xlabel("Listener")
output_woofer_attr2 = d_2.boxplot(column, grid=False)
box_woofer_attr2.savefig("boxplot_attr2_woofer.png", format="png")

box_woofer_attr3 = plt.figure()
plt.title("Boxplot for Attribute 3")
plt.ylabel("Ratings on combination of speakers/tracks")
plt.xlabel("Listener")
output_woofer_attr3 = d_3.boxplot(column, grid=False)
box_woofer_attr3.savefig("boxplot_attr3_woofer.png", format="png")


# stats f_oneway functions takes the groups as input and returns F and P-value
fvalue_woofer_attr1, pvalue_woofer_attr1 = stats.f_oneway(
    d_1["1"],
    d_1["2"],
    d_1["3"],
    d_1["4"],
    d_1["5"],
    d_1["6"],
    d_1["7"],
    d_1["8"],
    d_1["9"],
    d_1["10"],
    d_1["11"],
    d_1["12"],
    d_1["13"],
    d_1["14"],
    d_1["15"],
)
fvalue_woofer_attr2, pvalue_woofer_attr2 = stats.f_oneway(
    d_2["1"],
    d_2["2"],
    d_2["3"],
    d_2["4"],
    d_2["5"],
    d_2["6"],
    d_2["7"],
    d_2["8"],
    d_2["9"],
    d_2["10"],
    d_2["11"],
    d_2["12"],
    d_2["13"],
    d_2["14"],
    d_2["15"],
)
fvalue_woofer_attr3, pvalue_woofer_attr3 = stats.f_oneway(
    d_3["1"],
    d_3["2"],
    d_3["3"],
    d_3["4"],
    d_3["5"],
    d_3["6"],
    d_3["7"],
    d_3["8"],
    d_3["9"],
    d_3["10"],
    d_3["11"],
    d_3["12"],
    d_3["13"],
    d_3["14"],
    d_3["15"],
)

print(fvalue_woofer_attr1, pvalue_woofer_attr1) #ANOVA 1
print(fvalue_woofer_attr2, pvalue_woofer_attr2) #ANOVA 2
print(fvalue_woofer_attr3, pvalue_woofer_attr3) #ANOVA 3


####################################################################
####### ONE WAY ANOVA
####################################################################


# reshape the d dataframe suitable for statsmodels package and replace column names
d_melt_1 = pd.melt(d_1.reset_index(), id_vars=["index"], value_vars=column)
print(d_melt_1)
d_melt_1.columns = ["index", "treatments", "value"]

d_melt_2 = pd.melt(d_2.reset_index(), id_vars=["index"], value_vars=column)
print(d_melt_2)
d_melt_2.columns = ["index", "treatments", "value"]

d_melt_3 = pd.melt(d_3.reset_index(), id_vars=["index"], value_vars=column)
print(d_melt_3)
d_melt_3.columns = ["index", "treatments", "value"]


# Ordinary Least Squares (OLS) model
model = ols("value ~ C(treatments)", data=d_melt_1).fit()
anova_table_1 = sm.stats.anova_lm(model, typ=2)
anova_table_1

model = ols("value ~ C(treatments)", data=d_melt_2).fit()
anova_table_2 = sm.stats.anova_lm(model, typ=2)
anova_table_2

model = ols("value ~ C(treatments)", data=d_melt_3).fit()
anova_table_3 = sm.stats.anova_lm(model, typ=2)
anova_table_3


#############################
####### TUKEY HSD TEST
#############################
#
# load packages
from statsmodels.stats.multicomp import pairwise_tukeyhsd
from statsmodels.sandbox.stats.multicomp import TukeyHSDResults
from statsmodels.stats.multicomp import MultiComparison

# perform multiple pairwise comparison (Tukey HSD)
m_comp_1 = pairwise_tukeyhsd(endog=d_melt_1["value"], groups=d_melt_1["treatments"], alpha=0.05)  
print(m_comp_1.summary()) 

m_comp_2 = pairwise_tukeyhsd(endog=d_melt_2["value"], groups=d_melt_2["treatments"], alpha=0.05)
print(m_comp_2.summary())  

m_comp_3 = pairwise_tukeyhsd(endog=d_melt_3["value"], groups=d_melt_3["treatments"], alpha=0.05)
print(m_comp_3.summary())  



