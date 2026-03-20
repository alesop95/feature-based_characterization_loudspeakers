# https://reneshbedre.github.io/blog/oanova.html
#

import pandas as pd

d = pd.read_csv("https://reneshbedre.github.io/myfiles/anova/onewayanova.txt", sep="\t")
# log value
print(d.head())

# convert it as a stacked table
d_melt = pd.melt(d.reset_index(), id_vars=["index"], value_vars=["A", "B", "C", "D"])
print(d_melt.head())

# perform one-way ANOVA using bioinfokit
from bioinfokit import analys

analys.stat.oanova(d=d_melt, res="value", xfac="variable", ph=True)

