# Frequently Asked Questions (FAQ)

## General Questions

### What is GEPPML?
GEPPML (General Equilibrium PPML) is a methodology for analyzing trade policy using general equilibrium models estimated with the Poisson Pseudo-Maximum Likelihood (PPML) estimator. It was developed by Anderson, Larch, and Yotov (2018).

### Why use R instead of Stata?
- **Accessibility:** R is free and open-source
- **Flexibility:** Easier to customize and extend
- **Integration:** Better integration with modern data science workflows
- **Performance:** The `fixest` package is very fast
- **Reproducibility:** Easier to share and replicate

### Does the R version produce the same results as Stata?
Yes! The R implementation is designed to replicate the Stata results exactly (within numerical precision). You can verify this using the `scripts/validation_report.R` script.

## Installation and Setup

### What version of R do I need?
R version 4.0 or higher is recommended. The package may work with older versions but has not been tested.

### The script fails with "package not found" error
Install the required packages:
```r
install.packages(c("data.table", "fixest", "haven", "dplyr"))
```

### How do I set the working directory?
If using RStudio:
```r
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
```

If not using RStudio:
```r
setwd("C:/path/to/GEPPML_R")  # Replace with your actual path
```

## Running the Analysis

### How long does the analysis take?
On a modern computer, the full analysis typically takes:
- Baseline scenario: < 1 second
- Conditional scenario: < 1 second
- Full endowment scenario: 10-30 seconds (depending on convergence)

### The convergence is very slow
Try:
1. Increasing the tolerance: `tolerance <- 0.01` (less precise but faster)
2. Checking your data for errors
3. Using a better starting point

### What if convergence is not achieved?
The script will stop after 100 iterations by default. You can:
1. Increase `max_iterations` (e.g., to 200)
2. Check if results are close enough for your purposes
3. Investigate the data for potential issues

### Can I use my own data?
Yes! Your data should have:
- `exporter`: Exporting country code
- `importer`: Importing country code
- `trade`: Bilateral trade flows
- Gravity variables (distance, contiguity, etc.)
- Same structure as the original data

## Interpretation

### What is the difference between Conditional and Full GE?
- **Conditional GE:** Only multilateral resistances adjust; output and expenditure are fixed
- **Full GE:** Everything adjusts including output, expenditure, and prices (complete equilibrium)

### What does a positive welfare effect mean?
A positive `rGDP_full_ch` means the country's real GDP increases under the counterfactual scenario (e.g., border removal).

### Why are some welfare effects negative?
Some countries may lose from policy changes due to:
- Trade diversion
- Changes in multilateral resistance
- General equilibrium effects

### What is sigma and why is it set to 7?
Sigma is the trade elasticity. The value of 7 is commonly used in the literature based on empirical estimates. You can change it based on your sector or research needs.

## Customization

### How do I analyze a different trade policy?
Modify the counterfactual trade costs in the script. Examples:

**Regional Trade Agreement:**
```r
dt[, t_ij_ctrf := exp(DIST_est * LN_DIST + CNTG_est * CNTG + 
                      BRDR_est * BRDR - 0.5 * RTA)]
```

**50% reduction in distance friction:**
```r
dt[, t_ij_ctrf := exp(DIST_est * LN_DIST * 0.5 + CNTG_est * CNTG + 
                      BRDR_est * BRDR)]
```

### How do I change the reference country?
Replace "DEU" (Germany) with your desired country code:
```r
dt[exporter == "USA", exporter := "ZZZ"]
dt[importer == "USA", importer := "ZZZ"]
```

### Can I add more gravity variables?
Yes! Modify the baseline model specification:
```r
baseline_model <- feglm(
  trade ~ LN_DIST + CNTG + BRDR + YOUR_VARIABLE | exporter + importer,
  data = dt,
  family = poisson()
)
```

And update the trade costs accordingly.

### How do I analyze multiple sectors?
You would need to:
1. Have sector-specific data
2. Run the analysis separately for each sector
3. Aggregate results as needed

This is not currently automated but could be added.

## Output and Results

### Where are the results saved?
All results are saved in the `output/` folder:
- `all_indexes_geppml.csv`: Main results (CSV)
- `all_indexes_geppml.rds`: Main results (R format)
- `full_static_all.rds`: Complete dataset with all variables
- `geppml.log`: Execution log

### How do I export results to Excel?
Use the example script:
```r
source("scripts/example_analysis.R")
```

Or install `openxlsx`:
```r
install.packages("openxlsx")
library(openxlsx)
write.xlsx(results, "output/results.xlsx")
```

### Can I create visualizations?
Yes! See `scripts/example_analysis.R` for examples using `ggplot2`.

## Troubleshooting

### Error: "object 'exporter' not found"
Make sure your data has the required column names exactly as specified.

### Error: "contrasts can be applied only to factors"
This usually means a variable that should be numeric is character. Check your data types.

### Results seem unrealistic
Check:
1. Data quality and units
2. Trade cost specification
3. Convergence (was it achieved?)
4. Parameter values (especially sigma)

### Memory error with large datasets
Increase R's memory limit:
```r
memory.limit(size = 16000)  # 16GB (Windows only)
```

Or use a computer with more RAM.

## Academic and Citation

### How do I cite this package?
See the README for the full citation. Always cite both:
1. The original Anderson, Larch, and Yotov (2018) paper
2. This R implementation

### Can I use this for my thesis/paper?
Yes! The package is open-source under the MIT License. Please cite appropriately.

### Is this peer-reviewed?
The methodology is published in a peer-reviewed journal (The World Economy). This R implementation is a replication package.

## Support

### Where can I get help?
1. Check this FAQ
2. Read the README.md
3. Look at the example scripts
4. Open an issue on GitHub
5. Email: jamiubadmus001@gmail.com

### How do I report a bug?
Open an issue on GitHub with:
- Description of the bug
- Steps to reproduce
- Error messages
- Your R version and OS

### Can I request a feature?
Yes! Open an issue with the "enhancement" tag and describe what you need.

## Contributing

### How can I contribute?
See CONTRIBUTING.md for detailed guidelines. We welcome:
- Bug reports and fixes
- Documentation improvements
- New features
- Examples and use cases
- Testing on different platforms

---

**Last Updated:** January 19, 2026

**Didn't find your answer?** 
- GitHub Issues: https://github.com/jamiubadmusng/GEPPML-R/issues
- Email: jamiubadmus001@gmail.com
