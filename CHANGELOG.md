# GEPPML-R Change Log

## Version 1.0.0 (2025-09-15)

### Initial Release

**Features:**
- Complete R translation of Anderson, Larch, and Yotov (2018) GEPPML methodology
- Three scenarios: Baseline, Conditional GE, and Full Endowment GE
- Uses modern R packages: `data.table` and `fixest`
- Comprehensive logging and output generation
- Publication-ready results in CSV and RDS formats

**Files Included:**
- `geppml.R`: Main analysis script
- `data/ge_ppml_data_orig.dta`: Original dataset from Anderson et al. (2018)
- `scripts/example_analysis.R`: Example usage and visualization
- `scripts/validate_results.R`: Validation against Stata results
- `README.md`: Comprehensive documentation
- `LICENSE`: MIT License

**Known Issues:**
- None

**Compatibility:**
- R version 4.0 or higher recommended
- Tested on Windows 10/11
- Should work on macOS and Linux (not extensively tested)

**Dependencies:**
- data.table (≥ 1.14.0)
- fixest (≥ 0.10.0)
- haven (≥ 2.4.0)
- dplyr (≥ 1.0.0)

---

## Future Plans

### Version 1.1.0 (Planned)

**Planned Features:**
- Parallel processing for faster convergence
- Additional trade policy scenarios (templates)
- Interactive Shiny dashboard for results visualization
- Support for multiple sectors
- Automated report generation

**Planned Improvements:**
- Performance optimization for large datasets
- Additional validation tests
- More comprehensive error handling
- Extended documentation with video tutorials

---

## Contributing

We welcome contributions! Areas where help is needed:
1. Testing on different operating systems
2. Performance benchmarking
3. Additional examples and use cases
4. Documentation improvements
5. Bug reports and fixes

Please see the main README for contribution guidelines.

---

**Maintainer:** Jamiu Olamilekan Badmus (jamiubadmus001@gmail.com)
