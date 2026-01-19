# Contributing to GEPPML-R

Thank you for your interest in contributing to GEPPML-R! This document provides guidelines for contributing to the project.

## Ways to Contribute

### 1. Report Bugs
If you find a bug, please open an issue on GitHub with:
- A clear, descriptive title
- Steps to reproduce the bug
- Expected vs actual behavior
- Your R version and operating system
- Relevant error messages or output

### 2. Suggest Enhancements
We welcome suggestions for new features or improvements:
- Open an issue with the tag "enhancement"
- Clearly describe the proposed feature
- Explain why this feature would be useful
- Provide examples if applicable

### 3. Submit Pull Requests

#### Process
1. Fork the repository
2. Create a new branch (`git checkout -b feature/YourFeature`)
3. Make your changes
4. Test your changes thoroughly
5. Commit with clear, descriptive messages
6. Push to your fork
7. Submit a pull request

#### Code Style
- Follow standard R coding conventions
- Use meaningful variable names
- Add comments for complex operations
- Keep functions focused and modular
- Use `data.table` syntax for data manipulation

#### Testing
- Ensure your code runs without errors
- Test on the original dataset
- If possible, test on different operating systems
- Verify that results match the Stata implementation

### 4. Improve Documentation
- Fix typos or clarify unclear sections
- Add examples or use cases
- Translate documentation to other languages
- Create tutorials or video guides

### 5. Share Use Cases
If you've used GEPPML-R in your research:
- Share your experience
- Provide feedback on usability
- Suggest improvements based on your needs
- Consider contributing your analysis as an example

## Development Setup

### Clone the Repository
```bash
git clone https://github.com/jamiubadmusng/GEPPML-R.git
cd GEPPML-R
```

### Install Dependencies
```r
install.packages(c("data.table", "fixest", "haven", "dplyr", "ggplot2"))
```

### Run Tests
```r
source("geppml.R")
source("scripts/validate_results.R")
```

## Code Review Process

1. All contributions will be reviewed by the maintainer
2. Feedback will be provided within 7 days
3. Once approved, changes will be merged
4. Contributors will be acknowledged in the README

## Priority Areas

We're particularly interested in contributions in these areas:

### High Priority
- [ ] Performance optimization (parallel processing)
- [ ] Additional validation tests
- [ ] Cross-platform testing (Linux, macOS)
- [ ] Bug fixes

### Medium Priority
- [ ] Additional example scenarios
- [ ] Visualization improvements
- [ ] Documentation enhancements
- [ ] Unit tests

### Low Priority
- [ ] Shiny dashboard
- [ ] Additional output formats
- [ ] Multi-sector support
- [ ] API development

## Questions?

If you have questions about contributing:
- Open an issue with the tag "question"
- Email: jamiubadmus001@gmail.com
- Check existing issues and pull requests

## Recognition

All contributors will be acknowledged in:
- README.md (Contributors section)
- CHANGELOG.md (for specific contributions)
- Academic citations (for significant contributions)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make GEPPML-R better!

**Maintainer:** Jamiu Olamilekan Badmus
**Email:** jamiubadmus001@gmail.com
**GitHub:** https://github.com/jamiubadmusng
