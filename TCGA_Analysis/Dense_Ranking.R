# Title: Dense Ranking Pipeline for Meta-Analysis
# For RRA, multiple ranked lists are required to obtain a single aggregated ranked list.
# Purpose: Transform multi-cohort differential expression data into ranked matrices for Robust Rank Aggregation (RRA).

library(data.table)
# Example
# Load Differential Expression Matrix: log2FoldChange of genes in multiple conditions
# The first row has gene names and the column names depict differential expression for control vs multiple different conditions
# Using relative paths for portability
input_file <- "data/Differential_Gene_Expression_Matrix.csv"
cts <- read.csv(input_file, row.names = 1, header = TRUE, check.names = FALSE)

# Perform Dense Ranking
# We use frankv from data.table for high-performance ranking.
# order = -1 ensures higher expression gets a higher rank (1st, 2nd, etc.)
# ties.method = "dense" ensures consecutive ranks for tied values.

for (i in 1:ncol(cts)) {
  cts[[i]] <- frankv(cts[[i]], ties.method = "dense", order = -1)
}

# Save Ranked Matrix
# This output is now ready for the Robust Rank Aggregation (RRA) step.
write.csv(cts, file = "results/Dense_Ranked.csv")
