# Title: Visualizing Target Significance (RRA Results)
# Purpose: Generate high-quality scatterplots to highlight prioritized hub genes based on RRA adjusted p-values and cohort consistency.

library(ggplot2)
library(ggrepel)

# Load RRA Results
input_file <- "results/Final_Prioritized_Targets.csv"
df <- read.csv(input_file, header = TRUE)

# Visualization: MCC-based RRA Plot
# Categorizing genes by significance (p-adj < 0.05) and cohort frequency
plot <- ggplot(df, aes(x = Rank, y = -log10(RRA_Score))) + 
  geom_point(shape = 16, size = 2, mapping = aes(color = yes_no)) +
  scale_color_manual(
    values = c("yes" = "red", "no" = "grey", "yn" = "green4"),
    labels = c(
      "adj p-value > 0.05",
      expression("Freq" >= 10 ~ ", adj p-value" <= 0.05),
      expression("Freq" < 10 ~ ", adj p-value" <= 0.05)
    )
  ) +
  geom_hline(yintercept = 1.30, linetype = "dashed", color = "black") + # p = 0.05 threshold
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14),
    legend.position = c(.75, 0.6),
    legend.box.background = element_rect(colour = "black")
  ) +
  labs(
    title = "Target Prioritization: RRA Hub Gene Identification",
    y = "-log10 (RRA adjusted p-value)",
    x = "RRA Rank"
  ) +
  # Label the top 20 genes using ggrepel to avoid overlapping
  geom_text_repel(
    data = df[1:20, ],
    aes(label = GeneNames),
    size = 3.5,
    segment.color = "grey10",
    max.overlaps = Inf
  )

# Save Publication-Quality Figures
# Saving as TIFF and PDF as per industry/journal standards
ggsave("results/RRA_Target_Significance.pdf", plot, width = 6, height = 6)
ggsave("results/RRA_Target_Significance.tiff", plot, width = 6, height = 6, dpi = 300)
