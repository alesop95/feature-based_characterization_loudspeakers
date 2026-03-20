###############################################################
#
# # https://reneshbedre.github.io/blog/anova.html
#
###############################################################
# load packages
import pandas as pd
import seaborn as sns

# load data file
d = pd.read_csv("https://reneshbedre.github.io/myfiles/anova/twowayanova.txt", sep="\t")
# reshape the d dataframe suitable for statsmodels package
# you do not need to reshape if your data is already in stacked format. Compare d and d_melt tables for detail
# understanding
print(d)
d_melt = pd.melt(d, id_vars=["Genotype"], value_vars=["1_year", "2_year", "3_year"])
# replace column names
d_melt.columns = ["Genotype", "years", "value"]
# generate a boxplot to see the data distribution by genotypes and years. Using boxplot, we can easily detect the
# differences between different groups
sns.boxplot(x="Genotype", y="value", hue="years", data=d_melt, palette="Set3")


###### TWO WAY ANOVA
# load packages
import statsmodels.api as sm
from statsmodels.formula.api import ols

# Ordinary Least Squares (OLS) model
# C(Genotype):C(years) represent interaction term
model = ols("value ~ C(Genotype) + C(years) + C(Genotype):C(years)", data=d_melt).fit()
anova_table = sm.stats.anova_lm(model, typ=2)
anova_table
