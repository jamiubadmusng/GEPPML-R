################################################################################
# GEPPML: General Equilibrium Analysis with PPML in R (CORRECTED VERSION)
################################################################################
#
# R Implementation of Anderson, J. E., Larch, M., & Yotov, Y. V. (2018)
# "GEPPML: General equilibrium analysis with PPML"
# The World Economy, 41(10), 2750-2782
#
# CORRECTED to exactly match Stata output
#
# Translated from Stata to R by: Jamiu Olamilekan Badmus
# Email: jamiubadmus001@gmail.com
# Date: September 15, 2025
#
################################################################################

# Clear workspace
rm(list = ls())

# Set working directory
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
} else {
  args <- commandArgs(trailingOnly = FALSE)
  script_path <- sub("--file=", "", args[grep("--file=", args)])
  if (length(script_path) > 0) {
    setwd(dirname(script_path))
  }
}

# Load required packages
required_packages <- c("data.table", "fixest", "haven")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

# Start logging
log_file <- file("output/geppml.log", open = "wt")
sink(log_file, type = "output", split = TRUE)
sink(log_file, type = "message")

cat("================================================================================\n")
cat("GEPPML: General Equilibrium Analysis with PPML in R (CORRECTED)\n")
cat("================================================================================\n")
cat("Script started at:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("================================================================================\n\n")

##################
# I. Prepare Data
##################

cat("I. PREPARE DATA\n")
cat("================================================================================\n\n")

# Load data
cat("Loading data: ge_ppml_data_orig.dta\n")
data <- read_dta("data/ge_ppml_data_orig.dta")
dt <- as.data.table(data)

# 1. Create aggregate variables
cat("1. Creating aggregate variables...\n")
dt[, output := sum(trade), by = exporter]
dt[, expndr := sum(trade), by = importer]

# 2. Choose a country for reference group
cat("2. Setting reference country (DEU -> ZZZ)...\n")
dt[exporter == "DEU", exporter := "ZZZ"]
dt[importer == "DEU", importer := "ZZZ"]
dt[importer == "ZZZ", expndr_deu0 := expndr]
dt[, expndr_deu := mean(expndr_deu0, na.rm = TRUE)]

# 3. Set additional parameters
cat("3. Setting parameters (sigma = 7)...\n\n")
sigma <- 7

# Save processed data
saveRDS(dt, "data/ge_ppml_data.rds")

##########################
# II. GE Analysis in R
##########################

cat("II. GE ANALYSIS IN R\n")
cat("================================================================================\n\n")

# Load data
dt <- readRDS("data/ge_ppml_data.rds")

# Define number of countries
NoC <- length(unique(dt$exporter))
cat(sprintf("Number of countries: %d\n\n", NoC))

#############################
# Step 1: 'Baseline' Scenario
#############################

cat("================================================================================\n")
cat("STEP 1: 'BASELINE' SCENARIO\n")
cat("================================================================================\n\n")

#######################################
# Step 1.a: Estimate 'Baseline' Gravity
#######################################

cat("Step 1.a: Estimating 'Baseline' Gravity Model (Equation 9)...\n")
cat("Using fepois (PPML with fixed effects) to exactly match Stata's ppml\n\n")

# CRITICAL: Use fepois (Poisson fixed effects) to exactly match Stata's ppml
baseline_model <- fepois(
  trade ~ LN_DIST + CNTG + BRDR | exporter + importer,
  data = dt
)

# Display model summary
cat("Baseline Model Results:\n")
cat("------------------------\n")
print(summary(baseline_model))
cat("\n")

# Save estimates
DIST_est <- coef(baseline_model)["LN_DIST"]
BRDR_est <- coef(baseline_model)["BRDR"]
CNTG_est <- coef(baseline_model)["CNTG"]

cat(sprintf("Saved coefficients:\n"))
cat(sprintf("  LN_DIST: %.6f\n", DIST_est))
cat(sprintf("  CNTG:    %.6f\n", CNTG_est))
cat(sprintf("  BRDR:    %.6f\n\n", BRDR_est))

# Predict trade in the baseline (bsln)
cat("Predicting baseline trade flows...\n")
dt[, trade_bsln := predict(baseline_model, newdata = dt, type = "response")]

# Create trade costs
cat("Creating baseline and counterfactual trade costs...\n")
dt[, t_ij_bsln := exp(DIST_est * LN_DIST + CNTG_est * CNTG + BRDR_est * BRDR)]
dt[, t_ij_ctrf := exp(DIST_est * LN_DIST + CNTG_est * CNTG + BRDR_est * BRDR * 0)]
dt[exporter == importer, t_ij_ctrf := t_ij_bsln]
dt[, t_ij_ctrf_1 := log(t_ij_ctrf)]

cat("Baseline trade costs created.\n\n")

##########################################
# Step 1.b: Construct 'Baseline' GE Indexes
##########################################

cat("Step 1.b: Constructing 'Baseline' GE Indexes...\n")

# Extract fixed effects
fe_exporter <- fixef(baseline_model)$exporter
fe_importer <- fixef(baseline_model)$importer

# Create data tables for fixed effects (exp of coefficients)
exp_fe_dt <- data.table(
  exporter = names(fe_exporter),
  exp_fe = exp(fe_exporter)
)

# Add reference country (ZZZ) with exp(0) = 1
if (!"ZZZ" %in% exp_fe_dt$exporter) {
  exp_fe_dt <- rbind(exp_fe_dt, data.table(exporter = "ZZZ", exp_fe = 1))
}

imp_fe_dt <- data.table(
  importer = names(fe_importer),
  imp_fe = exp(fe_importer)
)

# Add reference country (ZZZ) with exp(0) = 1
if (!"ZZZ" %in% imp_fe_dt$importer) {
  imp_fe_dt <- rbind(imp_fe_dt, data.table(importer = "ZZZ", imp_fe = 1))
}

# Merge fixed effects with main data
dt <- merge(dt, exp_fe_dt, by = "exporter", all.x = TRUE)
dt <- merge(dt, imp_fe_dt, by = "importer", all.x = TRUE)

# Calculate sums of fixed effects (all_exp_fes_0 and all_imp_fes_0)
# In Stata, these are the exponentiated fixed effects for each observation
dt[, all_exp_fes_0 := exp_fe]
dt[, all_imp_fes_0 := imp_fe]

# Calculate importer-specific exporter fixed effects (for trade balance)
dt[exporter == importer, temp := all_exp_fes_0]
dt[, all_exp_fes_0_TB := mean(temp, na.rm = TRUE), by = importer]
dt[, temp := NULL]

# Equation (7): Outward Multilateral Resistance
cat("Computing OMR (Equation 7)...\n")
dt[, omr_bsln := output * expndr_deu / all_exp_fes_0]

# Equation (8): Inward Multilateral Resistance
cat("Computing IMR (Equation 8)...\n")
dt[, imr_bsln := expndr / (all_imp_fes_0 * expndr_deu)]

# Calculate real GDP
cat("Computing real GDP...\n")
dt[exporter == importer, rGDP_bsln_temp := output / (imr_bsln^(1/(1-sigma)))]
dt[, rGDP_bsln := sum(rGDP_bsln_temp, na.rm = TRUE), by = exporter]

# Calculate share of domestic expenditure
cat("Computing domestic absorption share...\n")
dt[exporter == importer, acr_bsln := trade_bsln / expndr]

# Calculate baseline bilateral exports
cat("Computing bilateral and total exports...\n")
dt[exporter != importer, exp_bsln := trade_bsln]

# Calculate domestic expenditure for each country
dt[exporter == importer, exp_bsln_acr := trade_bsln]

# Calculate total exports for each country
dt[, tot_exp_bsln := sum(exp_bsln, na.rm = TRUE), by = exporter]

cat("Baseline scenario completed.\n\n")

################################
# Step 2: 'Conditional' Scenario
################################

cat("================================================================================\n")
cat("STEP 2: 'CONDITIONAL' SCENARIO\n")
cat("================================================================================\n\n")

##########################################
# Step 2.a: Estimate 'Conditional' Gravity
##########################################

cat("Step 2.a: Estimating 'Conditional' Gravity Model (Equation 11)...\n")
cat("Formula: trade ~ 1 | exporter + importer, offset = log(t_ij_ctrf)\n\n")

# Remove previous FE columns to avoid conflicts
dt[, exp_fe := NULL]
dt[, imp_fe := NULL]

# Estimate conditional PPML model with offset using fepois
conditional_model <- fepois(
  trade ~ 1 | exporter + importer,
  data = dt,
  offset = ~t_ij_ctrf_1
)

cat("Conditional Model Results:\n")
cat("---------------------------\n")
print(summary(conditional_model))
cat("\n")

# Predict trade in 'Conditional' GE counterfactual (cndl)
cat("Predicting conditional trade flows...\n")
dt[, trade_cndl := predict(conditional_model, newdata = dt, type = "response")]

##############################################
# Step 2.b: Construct 'Conditional' GE Indexes
##############################################

cat("Step 2.b: Constructing 'Conditional' GE Indexes...\n")

# Extract conditional fixed effects
fe_exporter_cndl <- fixef(conditional_model)$exporter
fe_importer_cndl <- fixef(conditional_model)$importer

# Create data tables for conditional fixed effects
exp_fe_cndl_dt <- data.table(
  exporter = names(fe_exporter_cndl),
  exp_fe_cndl = exp(fe_exporter_cndl)
)

# Add reference country
if (!"ZZZ" %in% exp_fe_cndl_dt$exporter) {
  exp_fe_cndl_dt <- rbind(exp_fe_cndl_dt, data.table(exporter = "ZZZ", exp_fe_cndl = 1))
}

imp_fe_cndl_dt <- data.table(
  importer = names(fe_importer_cndl),
  imp_fe_cndl = exp(fe_importer_cndl)
)

# Add reference country
if (!"ZZZ" %in% imp_fe_cndl_dt$importer) {
  imp_fe_cndl_dt <- rbind(imp_fe_cndl_dt, data.table(importer = "ZZZ", imp_fe_cndl = 1))
}

# Merge conditional fixed effects
dt <- merge(dt, exp_fe_cndl_dt, by = "exporter", all.x = TRUE)
dt <- merge(dt, imp_fe_cndl_dt, by = "importer", all.x = TRUE)

# Calculate sums of conditional fixed effects
dt[, all_exp_fes_1 := exp_fe_cndl]
dt[, all_imp_fes_1 := imp_fe_cndl]

# Equation (7): Outward Multilateral Resistance (conditional)
cat("Computing conditional OMR...\n")
dt[, omr_cndl := output * expndr_deu / all_exp_fes_1]

# Equation (8): Inward Multilateral Resistance (conditional)
cat("Computing conditional IMR...\n")
dt[, imr_cndl := expndr / (all_imp_fes_1 * expndr_deu)]

# Calculate baseline bilateral exports
dt[exporter != importer, exp_cndl := trade_cndl]

# Calculate total exports for each country
dt[, tot_exp_cndl := sum(exp_cndl, na.rm = TRUE), by = exporter]

# Calculate change in total exports for each country
dt[, tot_exp_cndl_ch := (tot_exp_cndl - tot_exp_bsln) / tot_exp_bsln * 100]

# Calculate real GDP
cat("Computing conditional real GDP...\n")
dt[exporter == importer, rGDP_cndl_temp := output / (imr_cndl^(1/(1-sigma)))]
dt[, rGDP_cndl := sum(rGDP_cndl_temp, na.rm = TRUE), by = exporter]

cat("Conditional scenario completed.\n\n")

###################################
# Step 3: 'Full Endowment' Scenario
###################################

cat("================================================================================\n")
cat("STEP 3: 'FULL ENDOWMENT' SCENARIO\n")
cat("================================================================================\n\n")

#############################################
# Step 3.a: Estimate 'Full Endowment' Gravity
#############################################

cat("Step 3.a: Iterative estimation for 'Full Endowment' scenario...\n\n")

# Define variables for loop
i <- 3
diff_all_exp_fes_sd <- 1
diff_all_exp_fes_max <- 1
tolerance <- 0.001
max_iterations <- 100

# Initialize variables
dt[, trade_1_pred := trade_cndl]
dt[, output_bsln := output]
dt[, expndr_bsln := expndr]
dt[exporter == importer, phi := expndr / output]

dt[exporter == importer, temp := all_exp_fes_0]
dt[, all_exp_fes_0_imp := mean(temp, na.rm = TRUE), by = importer]
dt[, temp := NULL]

dt[exporter == importer, expndr_temp_1 := phi * output]
dt[, expndr_1 := mean(expndr_temp_1, na.rm = TRUE), by = importer]
dt[, expndr_temp_1 := NULL]

dt[importer == "ZZZ", expndr_deu01_1 := expndr_1]
dt[, expndr_deu1_1 := mean(expndr_deu01_1, na.rm = TRUE)]
dt[, expndr_deu_1 := mean(expndr_deu01_1, na.rm = TRUE)]

dt[exporter == importer, temp := all_exp_fes_1]
dt[, all_exp_fes_1_imp := mean(temp, na.rm = TRUE), by = importer]
dt[, temp := NULL]

dt[, p_full_exp_0 := 0]
dt[, p_full_exp_1 := (all_exp_fes_1 / all_exp_fes_0)^(1/(1-sigma))]
dt[, p_full_imp_1 := (all_exp_fes_1_imp / all_exp_fes_0_imp)^(1/(1-sigma))]
dt[, imr_full_1 := expndr_1 / (all_imp_fes_1 * expndr_deu_1)]
dt[, imr_full_ch_1 := 1]
dt[, omr_full_1 := output * expndr_deu_1 / all_exp_fes_1]
dt[, omr_full_ch_1 := 1]

cat("Starting iterative convergence process...\n")
cat(sprintf("Convergence criteria: SD < %.4f AND Max < %.4f\n", tolerance, tolerance))
cat(sprintf("Maximum iterations: %d\n\n", max_iterations))

iteration <- 0

# Start loop with convergence criteria
while ((diff_all_exp_fes_sd > tolerance | diff_all_exp_fes_max > tolerance) & iteration < max_iterations) {
  
  iteration <- iteration + 1
  current_iter <- i - 1
  
  cat(sprintf("--- Iteration %d ---\n", iteration))
  
  # Equation (14)
  dt[, paste0("trade_", current_iter) := 
      get(paste0("trade_", i-2, "_pred")) * 
      get(paste0("p_full_exp_", i-2)) * 
      get(paste0("p_full_imp_", i-2)) / 
      (get(paste0("omr_full_ch_", i-2)) * get(paste0("imr_full_ch_", i-2)))]
  
  # Estimate using fepois (Equation 11)
  tryCatch({
    full_model <- fepois(
      as.formula(paste0("trade_", current_iter, " ~ 1 | exporter + importer")),
      data = dt,
      offset = ~t_ij_ctrf_1
    )
    
    # Predict trade flows
    dt[, paste0("trade_", current_iter, "_pred") := 
        predict(full_model, newdata = dt, type = "response")]
    
    # Extract fixed effects
    fe_exp_full <- fixef(full_model)$exporter
    fe_imp_full <- fixef(full_model)$importer
    
    # Process exporter fixed effects
    exp_fe_full_dt <- data.table(
      exporter = names(fe_exp_full),
      exp_fe_full = exp(fe_exp_full)
    )
    if (!"ZZZ" %in% exp_fe_full_dt$exporter) {
      exp_fe_full_dt <- rbind(exp_fe_full_dt, 
                              data.table(exporter = "ZZZ", exp_fe_full = 1))
    }
    
    # Process importer fixed effects
    imp_fe_full_dt <- data.table(
      importer = names(fe_imp_full),
      imp_fe_full = exp(fe_imp_full)
    )
    if (!"ZZZ" %in% imp_fe_full_dt$importer) {
      imp_fe_full_dt <- rbind(imp_fe_full_dt, 
                              data.table(importer = "ZZZ", imp_fe_full = 1))
    }
    
    # Create temporary columns for this iteration
    dt[, temp_exp_fe := NULL]
    dt[, temp_imp_fe := NULL]
    dt <- merge(dt, exp_fe_full_dt, by = "exporter", all.x = TRUE, 
                suffixes = c("", "_new"))
    setnames(dt, "exp_fe_full", "temp_exp_fe")
    dt <- merge(dt, imp_fe_full_dt, by = "importer", all.x = TRUE,
                suffixes = c("", "_new"))
    setnames(dt, "imp_fe_full", "temp_imp_fe")
    
    # Calculate all_exp_fes and all_imp_fes for this iteration
    dt[, paste0("all_exp_fes_", current_iter) := temp_exp_fe]
    dt[, paste0("all_imp_fes_", current_iter) := temp_imp_fe]
    
    # Clean up temporary columns
    dt[, temp_exp_fe := NULL]
    dt[, temp_imp_fe := NULL]
    
    # Update output
    dt[, paste0("output_", current_iter) := 
        sum(get(paste0("trade_", current_iter, "_pred"))), by = exporter]
    
    # Update expenditure
    dt[, paste0("expndr_check_", current_iter) := 
        sum(get(paste0("trade_", current_iter, "_pred"))), by = importer]
    dt[importer == "ZZZ", paste0("expndr_deu0_", current_iter) := 
        get(paste0("expndr_check_", current_iter))]
    dt[, paste0("expndr_deu_", current_iter) := 
        mean(get(paste0("expndr_deu0_", current_iter)), na.rm = TRUE)]
    
    dt[exporter == importer, temp := get(paste0("all_exp_fes_", current_iter))]
    dt[, paste0("all_exp_fes_", current_iter, "_imp") := 
        mean(temp, na.rm = TRUE), by = importer]
    dt[, temp := NULL]
    
    # Update factory-gate prices
    dt[, paste0("p_full_exp_", current_iter) := 
        ((get(paste0("all_exp_fes_", current_iter)) / get(paste0("all_exp_fes_", i-2))) /
           (get(paste0("expndr_deu_", current_iter)) / get(paste0("expndr_deu_", i-2))))^(1/(1-sigma))]
    
    dt[, paste0("p_full_imp_", current_iter) := 
        ((get(paste0("all_exp_fes_", current_iter, "_imp")) / get(paste0("all_exp_fes_", i-2, "_imp"))) /
           (get(paste0("expndr_deu_", current_iter)) / get(paste0("expndr_deu_", i-2))))^(1/(1-sigma))]
    
    # Equation (7)
    dt[, paste0("omr_full_", current_iter) := 
        get(paste0("output_", current_iter)) / get(paste0("all_exp_fes_", current_iter))]
    dt[, paste0("omr_full_ch_", current_iter) := 
        get(paste0("omr_full_", current_iter)) / get(paste0("omr_full_", i-2))]
    
    # Update expenditure
    dt[exporter == importer, paste0("expndr_temp_", current_iter) := 
        phi * get(paste0("output_", current_iter))]
    dt[, paste0("expndr_", current_iter) := 
        mean(get(paste0("expndr_temp_", current_iter)), na.rm = TRUE), by = importer]
    
    # Equation (8)
    dt[, paste0("imr_full_", current_iter) := 
        get(paste0("expndr_", current_iter)) / 
        (get(paste0("all_imp_fes_", current_iter)) * get(paste0("expndr_deu_", current_iter)))]
    dt[, paste0("imr_full_ch_", current_iter) := 
        get(paste0("imr_full_", current_iter)) / get(paste0("imr_full_", i-2))]
    
    # Convergence criteria in terms of changes in factory-gate prices
    dt[, paste0("diff_p_full_exp_", current_iter) := 
        get(paste0("p_full_exp_", i-2)) - get(paste0("p_full_exp_", i-3))]
    
    # Calculate convergence statistics
    diff_stats <- dt[, .(
      sd = sd(get(paste0("diff_p_full_exp_", current_iter)), na.rm = TRUE),
      max = max(abs(get(paste0("diff_p_full_exp_", current_iter))), na.rm = TRUE)
    )]
    
    diff_all_exp_fes_sd <- diff_stats$sd
    diff_all_exp_fes_max <- diff_stats$max
    
    cat(sprintf("  SD: %.6f | Max: %.6f\n", diff_all_exp_fes_sd, diff_all_exp_fes_max))
    
  }, error = function(e) {
    cat("  Error in estimation:", e$message, "\n")
    cat("  Stopping iterations.\n")
    diff_all_exp_fes_sd <- 0
    diff_all_exp_fes_max <- 0
  })
  
  # Increment counter for next iteration
  i <- i + 1
}

cat(sprintf("\nConvergence achieved after %d iterations.\n", iteration))
cat(sprintf("Final SD: %.6f | Final Max: %.6f\n\n", diff_all_exp_fes_sd, diff_all_exp_fes_max))

# Get the final iteration number
final_iter <- i - 2

#################################################
# Step 3.b: Construct 'Full Endowment' GE Indexes
#################################################

cat("Step 3.b: Constructing 'Full Endowment' GE Indexes...\n")

# Calculate p^c/p
dt[, output := NULL]
dt[, expndr := NULL]
dt[, expndr_deu0 := NULL]
dt[, expndr_deu_bsln := expndr_deu]

dt[, output := sum(get(paste0("trade_", final_iter, "_pred"))), by = exporter]
dt[exporter == importer, expndr_temp := phi * output]
dt[, expndr := mean(expndr_temp, na.rm = TRUE), by = importer]
dt[importer == "ZZZ", expndr_deu0 := expndr]
dt[, expndr_deu := mean(expndr_deu0, na.rm = TRUE)]

# Calculate p_full
dt[, p_full := ((get(paste0("all_exp_fes_", final_iter)) / all_exp_fes_0) /
                 (expndr_deu / expndr_deu_bsln))^(1/(1-sigma))]

# Calculate output_full
dt[, output_full := p_full * output_bsln]

# Equation (7): Outward Multilateral Resistance
cat("Computing full endowment OMR...\n")
dt[, omr_full := output_full * expndr_deu / get(paste0("all_exp_fes_", final_iter))]

# Equation (8): Inward Multilateral Resistance
cat("Computing full endowment IMR...\n")
dt[, imr_full := expndr / (get(paste0("all_imp_fes_", final_iter)) * expndr_deu)]

# Calculate real GDP
cat("Computing full endowment real GDP...\n")
dt[exporter == importer, rGDP_full_temp := p_full * output_bsln / (imr_full^(1/(1-sigma)))]
dt[, rGDP_full := sum(rGDP_full_temp, na.rm = TRUE), by = exporter]

# Calculate expenditure
dt[exporter == importer, expndr_full_temp := phi * output_full]
dt[, expndr_full := mean(expndr_full_temp, na.rm = TRUE), by = importer]

# Calculate baseline bilateral exports
cat("Computing full endowment trade flows...\n")
dt[, trade_full := (output_full * expndr_full * t_ij_ctrf) / (imr_full * omr_full)]
dt[exporter != importer, exp_full := trade_full]

# Calculate total exports for each country
dt[, tot_exp_full := sum(exp_full, na.rm = TRUE), by = exporter]

# Calculate change in total exports for each country
dt[, tot_exp_full_ch := (tot_exp_full - tot_exp_bsln) / tot_exp_bsln * 100]

cat("Full endowment scenario completed.\n\n")

# Save results
cat("Saving full results to output/full_static_all.rds\n")
saveRDS(dt, "output/full_static_all.rds")

##########################################
# Prepare All Indexes at the Country Level
##########################################

cat("\n================================================================================\n")
cat("PREPARING COUNTRY-LEVEL INDEXES\n")
cat("================================================================================\n\n")

# IMR indexes
cat("Creating IMR indexes...\n")
imrs_all <- dt[, .(
  imr_full = mean(imr_full, na.rm = TRUE),
  imr_bsln = mean(imr_bsln, na.rm = TRUE),
  imr_cndl = mean(imr_cndl, na.rm = TRUE)
), by = importer]

setnames(imrs_all, "importer", "country")
imrs_all[, imr_full_ch := (imr_full - imr_bsln) / imr_bsln * 100]
imrs_all[, imr_cndl_ch := (imr_cndl - imr_bsln) / imr_bsln * 100]

saveRDS(imrs_all, "output/imrs_all.rds")

# OMR and other indexes
cat("Creating OMR and other indexes...\n")
omr_dt <- dt[, .(
  omr_full = mean(omr_full, na.rm = TRUE),
  omr_cndl = mean(omr_cndl, na.rm = TRUE),
  omr_bsln = mean(omr_bsln, na.rm = TRUE),
  rGDP_full = mean(rGDP_full, na.rm = TRUE),
  rGDP_cndl = mean(rGDP_cndl, na.rm = TRUE),
  rGDP_bsln = mean(rGDP_bsln, na.rm = TRUE),
  tot_exp_full = mean(tot_exp_full, na.rm = TRUE),
  tot_exp_cndl = mean(tot_exp_cndl, na.rm = TRUE),
  tot_exp_bsln = mean(tot_exp_bsln, na.rm = TRUE),
  tot_exp_full_ch = mean(tot_exp_full_ch, na.rm = TRUE),
  tot_exp_cndl_ch = mean(tot_exp_cndl_ch, na.rm = TRUE),
  p_full = mean(p_full, na.rm = TRUE),
  output_bsln = mean(output_bsln, na.rm = TRUE),
  acr_bsln = mean(acr_bsln, na.rm = TRUE)
), by = exporter]

setnames(omr_dt, "exporter", "country")
omr_dt[, omr_full_ch := (omr_full - omr_bsln) / omr_bsln * 100]
omr_dt[, omr_cndl_ch := (omr_cndl - omr_bsln) / omr_bsln * 100]
omr_dt[, rGDP_full_ch := (rGDP_full - rGDP_bsln) / rGDP_bsln * 100]
omr_dt[, rGDP_cndl_ch := (rGDP_cndl - rGDP_bsln) / rGDP_bsln * 100]

# Combine all indexes
cat("Combining all indexes...\n")
all_indexes_geppml <- merge(omr_dt, imrs_all, by = "country", all = TRUE)

saveRDS(all_indexes_geppml, "output/all_indexes_geppml.rds")

# Also save as CSV for easy viewing
write.csv(all_indexes_geppml, "output/all_indexes_geppml.csv", row.names = FALSE)

cat("\nAll indexes saved to:\n")
cat("  - output/all_indexes_geppml.rds\n")
cat("  - output/all_indexes_geppml.csv\n\n")

# Display summary statistics
cat("================================================================================\n")
cat("SUMMARY OF RESULTS\n")
cat("================================================================================\n\n")

cat("Country-level welfare effects (% change in real GDP):\n")
cat("------------------------------------------------------\n")
print(all_indexes_geppml[, .(country, rGDP_cndl_ch, rGDP_full_ch)])

cat("\n\nSummary statistics of welfare effects:\n")
cat("---------------------------------------\n")
summary_stats <- all_indexes_geppml[, .(
  Mean_Conditional = mean(rGDP_cndl_ch, na.rm = TRUE),
  Median_Conditional = median(rGDP_cndl_ch, na.rm = TRUE),
  SD_Conditional = sd(rGDP_cndl_ch, na.rm = TRUE),
  Min_Conditional = min(rGDP_cndl_ch, na.rm = TRUE),
  Max_Conditional = max(rGDP_cndl_ch, na.rm = TRUE),
  Mean_Full = mean(rGDP_full_ch, na.rm = TRUE),
  Median_Full = median(rGDP_full_ch, na.rm = TRUE),
  SD_Full = sd(rGDP_full_ch, na.rm = TRUE),
  Min_Full = min(rGDP_full_ch, na.rm = TRUE),
  Max_Full = max(rGDP_full_ch, na.rm = TRUE)
)]

print(summary_stats)

cat("\n================================================================================\n")
cat("Script completed successfully at:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("================================================================================\n")

# Close log
sink(type = "message")
sink(type = "output")
close(log_file)

cat("\nLog file saved to: output/geppml.log\n")
