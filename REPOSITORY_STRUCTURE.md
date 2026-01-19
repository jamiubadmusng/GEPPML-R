# 📋 Repository Structure

## Overview

This repository contains a complete R implementation of the GEPPML (General Equilibrium Poisson Pseudo-Maximum Likelihood) methodology, along with the original Stata implementation for comparison and validation.

## Directory Tree

```
GEPPML_R/
│
├── 📄 README.md                   # Main documentation (START HERE!)
├── 📄 LICENSE                     # MIT License
├── 📄 .gitignore                  # Git ignore configuration
├── 📄 CITATION.cff                # Citation metadata
├── 📄 CHANGELOG.md                # Version history
├── 📄 CONTRIBUTING.md             # Contribution guidelines
├── 📄 FAQ.md                      # Frequently Asked Questions
├── 📄 QUICKSTART.md               # Quick start guide
├── 📄 VALIDATION.md               # R vs Stata validation report
├── 📄 PROJECT_STRUCTURE.md        # Detailed structure documentation
├── 📄 PACKAGE_INFO.txt            # Package metadata
│
├── 🔵 geppml.R                    # ⭐ MAIN ANALYSIS SCRIPT
│
├── 📁 data/
│   ├── ge_ppml_data_orig.dta     # Original Anderson et al. (2018) data
│   └── .gitkeep
│
├── 📁 output/
│   ├── all_indexes_geppml.csv    # 📊 Main results (country-level)
│   ├── all_indexes_geppml.rds    # Results in R format
│   ├── full_static_all.rds       # Complete bilateral dataset
│   ├── imrs_all.rds              # Multilateral resistance indexes
│   ├── geppml.log                # Execution log
│   └── .gitkeep
│
├── 📁 scripts/
│   ├── example_analysis.R        # 📈 Examples & visualizations
│   └── validation_report.R       # 🔍 Validation tests
│
└── 📁 GEPPML_stata/              # 🔄 Original Stata code
    ├── geppml.do                 # Stata implementation
    ├── ge_ppml_data_orig.dta     # Data
    ├── all_indexes_geppml.dta    # Stata results
    ├── geppml.log                # Stata log
    └── readme.txt                # Stata documentation
```

## File Count Summary

| Category | Count | Total Size |
|----------|-------|------------|
| Documentation | 11 files | |
| R Scripts | 3 files | |
| Data Files | 2 files | ~500 KB |
| Output Files | 5+ files | Generated |
| Stata Files | 5+ files | Reference |

## Key Files for Different Users

### 🆕 New Users
1. Start with **README.md** - Complete overview
2. Then **QUICKSTART.md** - Get running in 5 minutes
3. Run **geppml.R** - Main analysis

### 🔬 Researchers Validating Results
1. Read **VALIDATION.md** - Validation methodology
2. Run **geppml.R** - R implementation
3. Compare with **GEPPML_stata/all_indexes_geppml.dta** - Stata results
4. Run **scripts/validation_report.R** - Automated comparison

### 👨‍💻 Developers / Contributors
1. Read **CONTRIBUTING.md** - Development guidelines
2. Check **PROJECT_STRUCTURE.md** - Detailed file descriptions
3. Review **CHANGELOG.md** - Version history
4. Check **FAQ.md** - Common issues

### 📊 Users Analyzing Results
1. Run **geppml.R** - Generate results
2. Open **output/all_indexes_geppml.csv** - Main results
3. Use **scripts/example_analysis.R** - Example analyses
4. Refer to **FAQ.md** - Interpretation help

## Documentation Hierarchy

```
📖 Documentation Structure
│
├── 🎯 Getting Started
│   ├── README.md (comprehensive overview)
│   ├── QUICKSTART.md (5-minute guide)
│   └── FAQ.md (common questions)
│
├── 🔧 Technical
│   ├── PROJECT_STRUCTURE.md (this file)
│   ├── VALIDATION.md (validation report)
│   └── PACKAGE_INFO.txt (metadata)
│
├── 🤝 Contributing
│   ├── CONTRIBUTING.md (guidelines)
│   ├── CHANGELOG.md (version history)
│   └── LICENSE (MIT)
│
└── 📚 Reference
    ├── CITATION.cff (citation info)
    └── GEPPML_stata/readme.txt (Stata docs)
```

## File Sizes (Approximate)

```
README.md              ~25 KB
geppml.R              ~35 KB
ge_ppml_data_orig.dta ~480 KB
all_indexes_geppml.csv ~15 KB
VALIDATION.md         ~12 KB
```

## Git Tracking

### Tracked Files
- All `.R` scripts
- All `.md` documentation
- Data files in `data/`
- Configuration files (`.gitignore`, `CITATION.cff`, etc.)
- Stata code in `GEPPML_stata/`

### Ignored Files (Not Tracked)
- Generated output files (`output/*.rds`, `output/*.csv`)
- R session files (`.RData`, `.Rhistory`)
- Temporary files
- Large intermediate files

See `.gitignore` for complete list.

## Maintenance Checklist

Before pushing to GitHub, ensure:

- [ ] All documentation is up to date
- [ ] Code runs without errors
- [ ] Validation tests pass
- [ ] Output files are in `.gitignore`
- [ ] LICENSE is included
- [ ] CITATION.cff has correct metadata
- [ ] README badges point to correct URLs
- [ ] All links in documentation work
- [ ] Example scripts run successfully
- [ ] Changelog is updated

## Questions?

- 📧 Email: jamiubadmus001@gmail.com
- 🌐 Website: https://sites.google.com/view/jamiu-olamilekan-badmus/bio
- 💻 GitHub: https://github.com/jamiubadmusng/GEPPML-R/issues

---

**Last Updated:** January 19, 2026
