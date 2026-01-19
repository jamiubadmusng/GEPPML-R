# Quick Start Guide

Get started with GEPPML-R in 5 minutes!

## Step 1: Install R and Required Packages (2 minutes)

### Install R
Download and install R from [CRAN](https://cran.r-project.org/)

### Install RStudio (Recommended)
Download from [RStudio](https://posit.co/download/rstudio-desktop/)

### Install Required Packages
Open R or RStudio and run:
```r
install.packages(c("data.table", "fixest", "haven", "dplyr"))
```

## Step 2: Download GEPPML-R (1 minute)

### Option A: Clone with Git
```bash
git clone https://github.com/jamiubadmusng/GEPPML-R.git
cd GEPPML-R
```

### Option B: Download ZIP
1. Go to https://github.com/jamiubadmusng/GEPPML-R
2. Click "Code" → "Download ZIP"
3. Extract to your desired location

## Step 3: Run Your First Analysis (2 minutes)

### Open the Main Script
In RStudio:
1. Open `geppml.R`
2. Click "Source" or press Ctrl+Shift+S (Windows) / Cmd+Shift+S (Mac)

### Or Run from Console
```r
# Set working directory
setwd("path/to/GEPPML_R")

# Run the analysis
source("geppml.R")
```

## Step 4: View Results

### Load Results
```r
results <- read.csv("output/all_indexes_geppml.csv")
View(results)
```

### Key Variables to Look At
- `country`: Country code
- `rGDP_full_ch`: Welfare effect (% change in real GDP)
- `tot_exp_full_ch`: Change in total exports (%)

### Quick Summary
```r
# Top 5 welfare gainers
head(results[order(-results$rGDP_full_ch), c("country", "rGDP_full_ch")], 5)

# Top 5 welfare losers
head(results[order(results$rGDP_full_ch), c("country", "rGDP_full_ch")], 5)

# Average welfare effect
mean(results$rGDP_full_ch, na.rm = TRUE)
```

## Next Steps

### Explore Examples
```r
source("scripts/example_analysis.R")
```

### Customize Analysis
Edit the counterfactual specification in `geppml.R`:
```r
# Line ~122: Modify trade costs
dt[, t_ij_ctrf := exp(DIST_est * LN_DIST + CNTG_est * CNTG + BRDR_est * BRDR * 0)]
```

### Validate Results
Compare with Stata version (if available):
```r
source("scripts/validate_results.R")
```

## Common First-Time Issues

### Issue: "cannot open file 'geppml.R'"
**Solution:** Make sure you're in the correct directory
```r
getwd()  # Check current directory
setwd("path/to/GEPPML_R")  # Change if needed
```

### Issue: "there is no package called 'fixest'"
**Solution:** Install the package
```r
install.packages("fixest")
```

### Issue: "cannot open file 'data/ge_ppml_data_orig.dta'"
**Solution:** Make sure the data file is in the `data/` folder

## Getting Help

- **Documentation:** Read `README.md`
- **Examples:** Check `scripts/example_analysis.R`
- **FAQ:** See `FAQ.md`
- **Issues:** https://github.com/jamiubadmusng/GEPPML-R/issues
- **Email:** jamiubadmus001@gmail.com

## What You Just Did

1. ✅ Estimated a baseline gravity model
2. ✅ Computed conditional GE effects
3. ✅ Solved for full GE equilibrium
4. ✅ Generated country-level welfare effects

Congratulations! You've completed your first GEPPML analysis in R! 🎉

---

**Next:** Read the full [README.md](README.md) to understand the methodology and customize your analysis.
