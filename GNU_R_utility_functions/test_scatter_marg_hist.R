#!/usr/bin/env Rscript
source(path.expand("~/develop/comp_neuro_science/GNU_R_utility_functions/scatter_marg_hist.R"))

cat(sprintf("Plotting.\n"))
scatter_marg_hist(iris, "Sepal.Length", "Sepal.Width", "Species")
cat(sprintf("Plot done.\n"))
