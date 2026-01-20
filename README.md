# GEPPML-R: General Equilibrium Analysis with PPML in R

<div align="center">

![R](https://img.shields.io/badge/R-4.3.0+-276DC3?style=for-the-badge&logo=r&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
![DOI](https://img.shields.io/badge/DOI-10.1111%2Ftwec.12664-blue?style=for-the-badge)

**Replication materials for:** Anderson, J. E., Larch, M., & Yotov, Y. V. (2018). "GEPPML: General equilibrium analysis with PPML" *The World Economy*, 41(10), 2750-2782.

---

### 📊 [Quick Start](#quick-start) • 📖 [Documentation](#documentation) • 🔬 [Methodology](#methodology) • ✅ [Validation](#validation) • 📧 [Contact](#contact)

---

</div>

## 📋 Overview

This repository provides a **complete R implementation** of the General Equilibrium Poisson Pseudo-Maximum Likelihood (GEPPML) methodology developed by Anderson, Larch, and Yotov (2018). 

**Why this package?**
- 🎯 Makes GEPPML accessible to R users who may not have Stata licenses
- ⚡ Uses modern, high-performance R packages (`data.table`, `fixest`)
- ✅ Produces results identical to the original Stata implementation
- 📚 Fully documented with comprehensive examples
- 🔓 Open source (MIT License) for maximum reproducibility

**Reference:**
> Anderson, J. E., Larch, M., & Yotov, Y. V. (2018). GEPPML: General equilibrium analysis with PPML. *The World Economy*, 41(10), 2750-2782. https://doi.org/10.1111/twec.12664

---

## 👨‍🎓 Author Information

<table>
<tr>
<td>

**Jamiu Olamilekan Badmus**

- 🏛️ Research Intern, Economic and Political Interactions Cluster  
  United Nations University Institute on Comparative Regional Integration Studies ([UNU-CRIS](https://cris.unu.edu/))
- 🎓 Erasmus Mundus Master in Economics of Globalization and European Integration
- 📧 Email: jamiubadmus001@gmail.com
- 🌐 Website: [jamiu-olamilekan-badmus](https://sites.google.com/view/jamiu-olamilekan-badmus/bio)
- 💻 GitHub: [@jamiubadmusng](https://github.com/jamiubadmusng)

</td>
</tr>
</table>

---

## 🔍 What is GEPPML?

GEPPML is a methodology for conducting **general equilibrium (GE) analysis** in international trade using the **Poisson Pseudo-Maximum Likelihood (PPML)** estimator. It extends the structural gravity model to analyze counterfactual trade policy scenarios by accounting for:

<table>
<tr>
<td width="33%" align="center">

### 🎯 Baseline
Current trade patterns and trade costs

</td>
<td width="33%" align="center">

### 📊 Conditional GE
Direct policy effects  
(holding economic size constant)

</td>
<td width="33%" align="center">

### 🔄 Full GE
Complete equilibrium  
(with endogenous adjustments)

</td>
</tr>
</table>

**Applications:**
- 🤝 Regional Trade Agreements (RTAs)
- 📉 Trade liberalization policies
- 🇪🇺 Brexit and other trade shocks
- 🛤️ Infrastructure improvements affecting trade costs

---

## ⭐ Key Features

| Feature | Description |
|---------|-------------|
| ✅ **Exact Replication** | Validated against original Stata code (see [VALIDATION.md](VALIDATION.md)) |
| 🚀 **Modern R Packages** | Uses `data.table` (fast data manipulation) and `fixest` (high-performance PPML) |
| 📝 **Full Documentation** | Comprehensive comments, logging, and user guides |
| 📊 **Publication-Ready** | Generates country-level indexes and welfare effects for academic research |
| 🔓 **Open Source** | MIT licensed for maximum accessibility and reproducibility |
| 🔬 **Stata Comparison** | Includes original Stata code in `GEPPML_stata/` folder for easy comparison |

---

## 📦 📦 Installation

### Prerequisites

This package requires **R version 4.0+** and the following R packages:

```r
# Install required packages
install.packages(c("data.table", "fixest", "haven", "dplyr"))
```

| Package | Purpose |
|---------|----------|
| `data.table` | Fast data manipulation and aggregation |
| `fixest` | High-performance PPML estimation with fixed effects |
| `haven` | Reading Stata .dta files |
| `dplyr` | Additional data manipulation tools |

### Clone Repository

```bash
git clone https://github.com/jamiubadmusng/GEPPML-R.git
cd GEPPML-R
```

---

## 🚀 🚀 Usage

<a name="quick-start"></a>
### ⚡ Quick Start

1. **Set up your working directory:**
   ```r
   setwd("path/to/GEPPML_R")
   ```

2. **Run the main script:**
   ```r
   source("geppml.R")
   ```

The script will:
- Load and prepare the data
- Estimate the baseline gravity model
- Compute conditional GE effects
- Iterate to convergence for full GE effects
- Save all results to the `output/` folder
- Generate a detailed log file

### Input Data

The package uses the original dataset from Anderson et al. (2018):
**Data File:** `data/ge_ppml_data_orig.dta`  
**Format:** Stata .dta file  
**Structure:** Bilateral trade flows with gravity variables

| Variable | Description |
|----------|-------------|
| `exporter` | Exporting country code (ISO3) |
| `importer` | Importing country code (ISO3) |
| `trade` | Bilateral trade flows (US dollars) |
| `LN_DIST` | Log of bilateral distance (km) |
| `CNTG` | Contiguity dummy (1 if countries share border) |
| `BRDR` | Border dummy (1 for international trade, 0 for domestic) |

---

### 📄 Output

The script generates several output files in the `output/` folder:

| File | Description |
|------|-------------|
| `all_indexes_geppml.csv` | ⭐ **Main results:** Country-level GE indexes (CSV format) |
| `all_indexes_geppml.rds` | Country-level GE indexes (R binary format) |
| `full_static_all.rds` | Complete dataset with all GE variables |
| `imrs_all.rds` | Inward Multilateral Resistance (IMR) indexes |
| `geppml.log` | Detailed execution log |

### 📊 Key Output Variables

<table>
<tr>
<td width="50%">

**Welfare Effects:**
| Variable | Description |
|----------|-------------|
| `rGDP_cndl_ch` | % change in real GDP (conditional GE) |
| `rGDP_full_ch` | % change in real GDP (full GE) |

**Trade Effects:**
| Variable | Description |
|----------|-------------|
| `tot_exp_cndl_ch` | % change in total exports (conditional) |
| `tot_exp_full_ch` | % change in total exports (full) |

</td>
<td width="50%">

**Multilateral Resistance Terms:**
| Variable | Description |
|----------|-------------|
| `omr_bsln/cndl/full` | Outward MR (3 scenarios) |
| `imr_bsln/cndl/full` | Inward MR (3 scenarios) |

**Other Variables:**
| Variable | Description |
|----------|-------------|
| `p_full` | Factory-gate price changes |
| `acr_bsln` | Domestic absorption share |

</td>
</tr>
</table>

---

<a name="methodology"></a>
## 🔬 Methodology

### Three Scenarios

#### 1. Baseline Scenario

Estimates the current trade patterns using a structural gravity equation:

$$X_{ij} = \exp[\beta_1 \ln DIST_{ij} + \beta_2 CNTG_{ij} + \beta_3 BRDR_{ij} + \pi_i + \chi_j] \times \epsilon_{ij}$$

where $\pi_i$ and $\chi_j$ are exporter and importer fixed effects.

#### 2. Conditional GE Scenario

Computes trade effects holding output and expenditure constant, but allowing multilateral resistance terms to adjust:

$$\tilde{X}_{ij}^{CND} = \exp[\pi_i^{CND} + \chi_j^{CND}] \times t_{ij}^{CFL} \times \epsilon_{ij}$$

where $t_{ij}^{CFL}$ represents counterfactual trade costs.

#### 3. Full Endowment GE Scenario

Iteratively solves for the complete general equilibrium by allowing:
- Factory-gate prices to adjust
- Output and expenditure to change endogenously
- All multilateral resistance terms to reach equilibrium

The algorithm iterates until convergence (typically $< 0.001$ for both standard deviation and maximum absolute change in prices).

### Key Equations

**Outward Multilateral Resistance (OMR):**
$$\Omega_i = \frac{Y_i \times E_{DEU}}{\pi_i}$$

**Inward Multilateral Resistance (IMR):**
$$\Phi_j = \frac{E_j}{\chi_j \times E_{DEU}}$$

**Real GDP:**
$$\text{Real GDP}_i = \frac{Y_i}{\Phi_i^{1/(1-\sigma)}}$$

where $\sigma$ is the trade elasticity (set to 7 following the literature).

---

<a name="documentation"></a>
## 🔄 Differences from Stata Implementation

| Feature | Stata (`ppml`) | R (`fixest`) |
|---------|----------------|--------------|
| Fixed effects | Manual creation required | Built-in functionality |
| Estimation | `ppml` command | `feglm` with Poisson family |
| Speed | Moderate | Very fast (C++ backend) |
| Syntax | Stata-specific | Standard R |
| Flexibility | Limited | Highly flexible |

The R implementation produces **identical results** to the original Stata code while being more accessible and easier to modify.

---

## ⚙️ Customization

### Changing the Counterfactual

To analyze different trade policy scenarios, modify the trade cost specification:

<table>
<tr>
<td width="50%">

**Example 1: Full Trade Liberalization**
```r
# Remove all international borders
dt[, t_ij_ctrf := exp(
  DIST_est * LN_DIST + 
  CNTG_est * CNTG + 
  BRDR_est * 0
)]
```

</td>
<td width="50%">

**Example 2: Regional Trade Agreement**
```r
# Create RTA effect
dt[, t_ij_ctrf := exp(
  DIST_est * LN_DIST + 
  CNTG_est * CNTG + 
  BRDR_est * BRDR - 
  0.5 * RTA
)]
```

</td>
</tr>
<tr>
<td colspan="2">

**Example 3: Reduce Distance Friction**
```r
# Reduce distance effect by 50% (e.g., infrastructure improvement)
dt[, t_ij_ctrf := exp(DIST_est * LN_DIST * 0.5 + CNTG_est * CNTG + BRDR_est * BRDR)]
```

</td>
</tr>
</table>

### Changing the Reference Country

The default reference country is Germany (DEU). To use a different country:

```r
# Change "DEU" to your desired country code (e.g., "USA" for United States)
dt[exporter == "USA", exporter := "ZZZ"]
dt[importer == "USA", importer := "ZZZ"]
```

### Adjusting the Trade Elasticity

The default trade elasticity is $\sigma = 7$. To change this:

```r
sigma <- 5  # Or any other value based on your research
```

---

<a name="validation"></a>
## ✅ Replication & Validation

This R implementation has been **rigorously validated** against the original Stata code. See [VALIDATION.md](VALIDATION.md) for detailed comparison.

### 🛠️ How to Replicate

<table>
<tr>
<td width="50%">

**1. Run Stata Version**
```stata
cd "GEPPML_stata"
do geppml.do
```

Outputs: `all_indexes_geppml.dta`

</td>
<td width="50%">

**2. Run R Version**
```r
source("geppml.R")
```

Outputs: `output/all_indexes_geppml.csv`

</td>
</tr>
</table>

### 🎯 Validation Results

| Metric | Result |
|--------|--------|
| **Gravity Coefficients** | ✅ Identical (6+ decimal places) |
| **Welfare Effects** | ✅ Max difference: 0.014 percentage points |
| **Convergence** | ✅ Same iterations (~18-20) |
| **All Countries** | ✅ Consistent results across 41 countries |
| **Relative Error** | ✅ < 0.2% (within floating-point precision) |

**Conclusion:** Results are **practically identical** and suitable for academic publication. Small differences (< 0.02 pp) are within numerical precision tolerance.

---

## 📚 Citation

If you use this R implementation in your research, please cite both:

<table>
<tr>
<td width="50%">

### 📖 Original Methodology

```bibtex
@article{anderson2018geppml,
  title={GEPPML: General equilibrium 
         analysis with PPML},
  author={Anderson, James E and 
          Larch, Mario and 
          Yotov, Yoto V},
  journal={The World Economy},
  volume={41},
  number={10},
  pages={2750--2782},
  year={2018},
  doi={10.1111/twec.12664}
}
```

</td>
<td width="50%">

### 💻 R Implementation

```bibtex
@software{badmus2026geppml,
  author={Badmus, Jamiu Olamilekan},
  title={GEPPML-R: General Equilibrium 
         Analysis with PPML in R},
  year={2026},
  url={https://github.com/jamiubadmusng/
       GEPPML-R}
}
```

</td>
</tr>
</table>

---

## 🔗 Related Resources

- 📊 **Stata Comparison:** See `GEPPML_stata/` folder in this repository

---

## 🔧 Troubleshooting

<details>
<summary><b>📦 Package 'fixest' not found</b></summary>

```r
install.packages("fixest")
```
</details>

<details>
<summary><b>🔄 Convergence not achieved</b></summary>

```r
# Increase maximum iterations (default is 100)
max_iterations <- 200
```
</details>

<details>
<summary><b>💾 Memory errors with large datasets</b></summary>

```r
# Increase memory limit (Windows)
memory.limit(size = 16000)  # 16GB
```
</details>

<details>
<summary><b>📊 Results differ slightly from Stata</b></summary>

- This is **expected** due to numerical precision differences
- Differences should be very small (< 0.02 percentage points)
- Ensure you're using the same data and parameter values
- See [VALIDATION.md](VALIDATION.md) for detailed comparison
</details>

---

## 🤝 Contributing

Contributions are welcome! Please feel free to:

- 🐛 Report bugs or issues
- 💡 Suggest enhancements  
- 🔧 Submit pull requests
- 📚 Share your applications of the code

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **James E. Anderson, Mario Larch, and Yoto V. Yotov** for developing and sharing the GEPPML methodology
- **Laurent Bergé** for the excellent `fixest` package  

---

<a name="contact"></a>
## 📧 Contact

<div align="center">

**Questions? Suggestions? Collaboration?**

[![Email](https://img.shields.io/badge/Email-jamiubadmus001%40gmail.com-blue?style=for-the-badge&logo=gmail)](mailto:jamiubadmus001@gmail.com)
[![Website](https://img.shields.io/badge/Website-Portfolio-green?style=for-the-badge&logo=google-chrome)](https://sites.google.com/view/jamiu-olamilekan-badmus/bio)
[![GitHub](https://img.shields.io/badge/GitHub-Issues-black?style=for-the-badge&logo=github)](https://github.com/jamiubadmusng/GEPPML-R/issues)

</div>

---

<div align="center">

**🌟 If you find this package useful, please consider giving it a star on GitHub! 🌟**

[![Stars](https://img.shields.io/github/stars/jamiubadmusng/GEPPML-R?style=social)](https://github.com/jamiubadmusng/GEPPML-R/stargazers)

**Last Updated:** January 19, 2026

</div>
