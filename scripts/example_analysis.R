################################################################################
# Example Script: Running GEPPML Analysis
################################################################################
#
# This script demonstrates how to use the GEPPML R implementation
# and provides examples of customizing the analysis for different scenarios.
#
################################################################################

# Clear workspace
rm(list = ls())

# Set working directory to the GEPPML_R folder
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(dirname(rstudioapi::getActiveDocumentContext()$path)))
} else {
  args <- commandArgs(trailingOnly = FALSE)
  script_path <- sub("--file=", "", args[grep("--file=", args)])
  if (length(script_path) > 0) {
    setwd(dirname(dirname(script_path)))
  }
}

# Install required packages if needed
required_packages <- c("data.table", "fixest", "haven", "dplyr", "ggplot2")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installing package: %s\n", pkg))
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

################################################################################
# Example 1: Run the Standard GEPPML Analysis
################################################################################

cat("\n")
cat("================================================================================\n")
cat("EXAMPLE 1: Standard GEPPML Analysis (Border Removal)\n")
cat("================================================================================\n\n")

# Simply source the main script
source("geppml.R")

# Load the results
results <- readRDS("output/all_indexes_geppml.rds")

# Display top welfare gainers and losers
cat("\n\nTop 5 Welfare Gainers (Full GE):\n")
cat("--------------------------------\n")
print(results[order(-rGDP_full_ch), .(country, rGDP_full_ch)][1:5])

cat("\n\nTop 5 Welfare Losers (Full GE):\n")
cat("-------------------------------\n")
print(results[order(rGDP_full_ch), .(country, rGDP_full_ch)][1:5])

################################################################################
# Example 2: Visualize Results
################################################################################

cat("\n")
cat("================================================================================\n")
cat("EXAMPLE 2: Visualizing GEPPML Results\n")
cat("================================================================================\n\n")

# Create bar plot of welfare effects
p1 <- ggplot(results, aes(x = reorder(country, rGDP_full_ch), y = rGDP_full_ch)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Welfare Effects of Border Removal",
    subtitle = "Full GE Scenario (% change in real GDP)",
    x = "Country",
    y = "% Change in Real GDP"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text = element_text(size = 8)
  )

# Save plot
ggsave("output/welfare_effects_full_ge.png", p1, width = 10, height = 12, dpi = 300)
cat("Plot saved: output/welfare_effects_full_ge.png\n")

# Create scatter plot: Conditional vs Full GE
p2 <- ggplot(results, aes(x = rGDP_cndl_ch, y = rGDP_full_ch)) +
  geom_point(color = "steelblue", size = 3, alpha = 0.6) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  labs(
    title = "Conditional vs Full GE Welfare Effects",
    x = "Conditional GE (% change in real GDP)",
    y = "Full GE (% change in real GDP)"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14))

ggsave("output/conditional_vs_full_ge.png", p2, width = 8, height = 6, dpi = 300)
cat("Plot saved: output/conditional_vs_full_ge.png\n")

################################################################################
# Example 3: Export Results to Excel (if openxlsx available)
################################################################################

if (require("openxlsx", quietly = TRUE)) {
  cat("\n")
  cat("================================================================================\n")
  cat("EXAMPLE 3: Exporting Results to Excel\n")
  cat("================================================================================\n\n")
  
  # Create workbook
  wb <- createWorkbook()
  
  # Add worksheet with all indexes
  addWorksheet(wb, "All Indexes")
  writeData(wb, "All Indexes", results)
  
  # Add worksheet with summary statistics
  addWorksheet(wb, "Summary Statistics")
  summary_stats <- data.frame(
    Statistic = c("Mean", "Median", "SD", "Min", "Max"),
    Conditional_GE = c(
      mean(results$rGDP_cndl_ch, na.rm = TRUE),
      median(results$rGDP_cndl_ch, na.rm = TRUE),
      sd(results$rGDP_cndl_ch, na.rm = TRUE),
      min(results$rGDP_cndl_ch, na.rm = TRUE),
      max(results$rGDP_cndl_ch, na.rm = TRUE)
    ),
    Full_GE = c(
      mean(results$rGDP_full_ch, na.rm = TRUE),
      median(results$rGDP_full_ch, na.rm = TRUE),
      sd(results$rGDP_full_ch, na.rm = TRUE),
      min(results$rGDP_full_ch, na.rm = TRUE),
      max(results$rGDP_full_ch, na.rm = TRUE)
    )
  )
  writeData(wb, "Summary Statistics", summary_stats)
  
  # Save workbook
  saveWorkbook(wb, "output/geppml_results.xlsx", overwrite = TRUE)
  cat("Excel file saved: output/geppml_results.xlsx\n")
} else {
  cat("\nNote: Install 'openxlsx' package to export results to Excel\n")
  cat("Run: install.packages('openxlsx')\n")
}

################################################################################
# Example 4: Compare with Baseline
################################################################################

cat("\n")
cat("================================================================================\n")
cat("EXAMPLE 4: Comparing Scenarios\n")
cat("================================================================================\n\n")

# Calculate correlation between conditional and full GE
correlation <- cor(results$rGDP_cndl_ch, results$rGDP_full_ch, use = "complete.obs")
cat(sprintf("Correlation between Conditional and Full GE: %.4f\n", correlation))

# Calculate how much full GE amplifies/dampens conditional effects
results[, amplification := rGDP_full_ch / rGDP_cndl_ch]
avg_amplification <- mean(results$amplification, na.rm = TRUE)
cat(sprintf("Average amplification factor: %.4f\n", avg_amplification))

# Countries where full GE effects are much larger
cat("\n\nCountries with largest amplification (Full GE > 1.5 × Conditional GE):\n")
cat("-----------------------------------------------------------------------\n")
print(results[amplification > 1.5 & !is.infinite(amplification), 
              .(country, rGDP_cndl_ch, rGDP_full_ch, amplification)][order(-amplification)])

################################################################################
# Example 5: Create Summary Tables
################################################################################

cat("\n")
cat("================================================================================\n")
cat("EXAMPLE 5: Creating Publication-Ready Tables\n")
cat("================================================================================\n\n")

# Create a formatted table for top 10 countries
top_10 <- results[order(-rGDP_full_ch)][1:10]
table_data <- top_10[, .(
  Country = country,
  `Baseline Output` = round(output_bsln, 0),
  `Conditional GE (%)` = round(rGDP_cndl_ch, 2),
  `Full GE (%)` = round(rGDP_full_ch, 2),
  `Export Change (%)` = round(tot_exp_full_ch, 2),
  `OMR Change (%)` = round(omr_full_ch, 2),
  `IMR Change (%)` = round(imr_full_ch, 2)
)]

cat("Top 10 Countries by Welfare Gains:\n")
cat("-----------------------------------\n")
print(table_data)

# Save as CSV
write.csv(table_data, "output/top_10_welfare_gainers.csv", row.names = FALSE)
cat("\n\nTable saved: output/top_10_welfare_gainers.csv\n")

################################################################################
# Example 6: Regional Analysis (if region data available)
################################################################################

cat("\n")
cat("================================================================================\n")
cat("EXAMPLE 6: Regional Patterns\n")
cat("================================================================================\n\n")

# Note: This requires region information which could be added
cat("Note: To perform regional analysis, add region information to your data:\n")
cat("  - Create a mapping file (country_regions.csv) with columns: country, region\n")
cat("  - Load and merge with results\n")
cat("  - Aggregate by region\n\n")

cat("Example code:\n")
cat('  regions <- fread("data/country_regions.csv")\n')
cat('  results_with_regions <- merge(results, regions, by = "country")\n')
cat('  regional_stats <- results_with_regions[, .(\n')
cat('    Mean_Welfare = mean(rGDP_full_ch),\n')
cat('    Median_Welfare = median(rGDP_full_ch),\n')
cat('    Total_Output = sum(output_bsln)\n')
cat('  ), by = region]\n')

################################################################################
# Summary
################################################################################

cat("\n")
cat("================================================================================\n")
cat("EXAMPLE SCRIPT COMPLETED\n")
cat("================================================================================\n\n")

cat("Generated outputs:\n")
cat("  - output/welfare_effects_full_ge.png\n")
cat("  - output/conditional_vs_full_ge.png\n")
cat("  - output/top_10_welfare_gainers.csv\n")
if (require("openxlsx", quietly = TRUE)) {
  cat("  - output/geppml_results.xlsx\n")
}
cat("\nFor more examples and documentation, see README.md\n\n")
