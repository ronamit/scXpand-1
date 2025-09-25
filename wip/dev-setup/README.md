# Development Environment Setup Guide

Comprehensive guide for setting up development environments for Python scientific computing projects following scverse ecosystem best practices.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Setup](#quick-setup)
3. [Detailed Setup Process](#detailed-setup-process)
4. [Development Workflows](#development-workflows)
5. [Documentation](#documentation)
6. [Testing](#testing)
7. [Code Quality](#code-quality)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools

- **UV**: Fast Python package manager
  ```bash
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```

- **Hatch**: Modern Python project management (for scverse projects)
  ```bash
  uv tool install hatch
  ```

- **Git**: Version control
  ```bash
  # macOS
  brew install git

  # Ubuntu/Debian
  sudo apt install git
  ```

### Optional but Recommended

- **GitHub CLI**: For repository management
  ```bash
  # macOS
  brew install gh

  # Ubuntu/Debian
  sudo apt install gh
  ```

## Quick Setup

### For scverse ecosystem projects (AnnData, Scanpy, etc.)

```bash
# Clone repository
gh repo fork scverse/anndata --clone --remote
cd anndata

# Install hatch if not already installed
uv tool install hatch

# Run tests (creates environment automatically)
hatch test

# Build documentation
hatch run docs:build

# Open documentation in browser
hatch run docs:open

# Run pre-commit hooks
hatch run pre-commit run --all-files
```

### For other projects using UV

```bash
# Create virtual environment
uv venv

# Activate environment
source .venv/bin/activate

# Install project in development mode
uv pip install -e ".[dev,test,doc]"

# Install pre-commit hooks
pre-commit install
```

## Detailed Setup Process

### 1. Repository Setup

```bash
# Fork and clone (recommended)
gh repo fork scverse/anndata --clone --remote
cd anndata

# Or clone directly
git clone https://github.com/scverse/anndata.git
cd anndata
git remote add upstream https://github.com/scverse/anndata.git
```

### 2. Environment Management

#### For Hatch-based projects (scverse ecosystem)

Hatch automatically manages environments based on `hatch.toml` configuration:

```bash
# Available environments:
# - default: General development
# - docs: Documentation building
# - hatch-test: Testing with different Python versions

# Run commands in specific environments
hatch run docs:build        # Build docs
hatch test                   # Run tests
hatch run towncrier:create   # Create changelog entry
```

#### For UV-based projects

```bash
# Create environment
uv venv --python 3.11

# Activate environment
source .venv/bin/activate

# Install dependencies
uv pip install -e ".[dev,test,doc]"

# Install additional tools
uv pip install pre-commit pytest-xdist
```

### 3. Pre-commit Setup

```bash
# Install pre-commit hooks
pre-commit install

# Run hooks manually
pre-commit run --all-files

# Update hooks
pre-commit autoupdate
```

## Development Workflows

### Making Changes

```bash
# Create feature branch
git checkout main
git pull upstream main
git switch -c feature/your-feature-name

# Make changes...

# Run quality checks
hatch run pre-commit run --all-files  # or: pre-commit run --all-files

# Run tests
hatch test  # or: pytest

# Commit changes
git add .
git commit -m "feat: your descriptive commit message"

# Push changes
git push --set-upstream origin feature/your-feature-name
```

### Code Quality Workflow

```bash
# Run all quality checks
pre-commit run --all-files

# Fix formatting issues automatically
ruff format .
ruff check --fix .

# Run tests with coverage
pytest --cov=src --cov-report=html

# Type checking (if configured)
mypy src/
```

## Documentation

### Building Documentation Locally

#### For Hatch-based projects

```bash
# Build documentation
hatch run docs:build

# Open in browser
hatch run docs:open

# Clean build cache
hatch run docs:clean

# Watch for changes (if configured)
hatch run docs:serve
```

#### For Sphinx-based projects

```bash
# Install documentation dependencies
uv pip install -e ".[doc]"

# Build documentation
cd docs
make html

# Open in browser
open _build/html/index.html  # macOS
xdg-open _build/html/index.html  # Linux

# Serve locally with live reload
sphinx-autobuild . _build/html --open-browser
```

### Documentation Best Practices

1. **Follow numpydoc style** for docstrings
2. **Include examples** in docstrings that can be executed
3. **Use MyST Markdown** for tutorials and guides
4. **Test documentation builds** before submitting PRs
5. **Add cross-references** using Sphinx roles (`:class:`, `:func:`, etc.)

### Viewing Documentation

After building, documentation is typically available at:
- Hatch projects: `docs/_build/html/index.html`
- Standard Sphinx: `docs/_build/html/index.html`

The `hatch run docs:open` command automatically opens the built docs in your default browser.

## Testing

### Running Tests

#### Hatch-based projects

```bash
# Run all tests
hatch test

# Run tests in parallel
hatch test -p

# Run specific test file
hatch test -- tests/test_specific.py

# Run tests with coverage
hatch test -- --cov=src --cov-report=html

# Run tests for specific Python versions
hatch test --python 3.11,3.12
```

#### UV/pytest-based projects

```bash
# Run all tests
pytest

# Run tests in parallel
pytest -n auto

# Run specific test
pytest tests/test_specific.py::test_function

# Run with coverage
pytest --cov=src --cov-report=html --cov-report=term

# Run only failed tests
pytest --lf

# Run tests matching pattern
pytest -k "test_pattern"
```

### Test Categories

- **Unit tests**: Test individual functions/classes
- **Integration tests**: Test component interactions
- **Functional tests**: Test end-to-end workflows
- **Performance tests**: Test performance characteristics

## Code Quality

### Tools Used

- **Ruff**: Fast linting and formatting
- **Pre-commit**: Automated quality checks
- **MyPy**: Static type checking (optional)
- **Pytest**: Testing framework

### Quality Checks

```bash
# Linting and formatting
ruff check .
ruff format .

# Type checking
mypy src/

# Security scanning
bandit -r src/

# Import sorting
isort src/ tests/

# Complexity checking
flake8 --max-complexity=10 src/
```

### Pre-commit Hooks

Common hooks include:
- `ruff-check`: Linting
- `ruff-format`: Code formatting
- `trailing-whitespace`: Remove trailing whitespace
- `end-of-file-fixer`: Ensure files end with newline
- `check-yaml`: Validate YAML files
- `check-toml`: Validate TOML files

## Environment Variables

### Useful Environment Variables

```bash
# UV configuration
export UV_CACHE_DIR="$HOME/.cache/uv"
export UV_PYTHON_DOWNLOADS=automatic

# Pytest configuration
export PYTEST_CURRENT_TEST=""

# Documentation
export SPHINX_BUILD_PARALLEL=auto

# Development flags
export PYTHONDEVMODE=1
export PYTHONWARNINGS=error
```

## Troubleshooting

### Common Issues

#### UV Issues

```bash
# Clear UV cache
uv cache clean

# Reinstall with fresh environment
rm -rf .venv
uv venv
source .venv/bin/activate
uv pip install -e ".[dev]"
```

#### Hatch Issues

```bash
# Clear hatch environments
hatch env prune

# Show environment info
hatch env show

# Run with verbose output
hatch -v test
```

#### Documentation Issues

```bash
# Clear Sphinx cache
rm -rf docs/_build
hatch run docs:clean  # or: make clean

# Force rebuild with verbose output
hatch run docs:build -- -E -v
```

#### Pre-commit Issues

```bash
# Update hooks
pre-commit autoupdate

# Clear cache
pre-commit clean

# Reinstall hooks
pre-commit uninstall
pre-commit install
```

### Performance Tips

1. **Use UV for fast package installation**
2. **Enable parallel testing** with `pytest -n auto`
3. **Use incremental builds** for documentation
4. **Cache dependencies** in CI/CD
5. **Use pre-commit hooks** to catch issues early

### IDE Configuration

#### VS Code

Create `.vscode/settings.json`:

```json
{
    "python.defaultInterpreterPath": "./.venv/bin/python",
    "python.testing.pytestEnabled": true,
    "python.testing.pytestArgs": ["tests"],
    "python.linting.enabled": true,
    "python.linting.ruffEnabled": true,
    "python.formatting.provider": "ruff",
    "files.associations": {
        "*.toml": "toml"
    }
}
```

#### PyCharm

1. Set interpreter to `.venv/bin/python`
2. Enable pytest as test runner
3. Configure Ruff as external tool
4. Set up pre-commit as external tool

## Project-Specific Notes

### AnnData/Scanpy Projects

- Use `hatch` for all operations
- Documentation uses MyST and Sphinx
- Tests require PyTorch for some features
- Follow scverse contributing guidelines

### General Python Projects

- Use `uv` for dependency management
- Configure pre-commit hooks
- Use pytest for testing
- Follow PEP 8 and type hints

## Resources

- [UV Documentation](https://docs.astral.sh/uv/)
- [Hatch Documentation](https://hatch.pypa.io/)
- [Scanpy Development Guide](https://scanpy.readthedocs.io/en/latest/dev/getting-set-up.html)
- [Pre-commit Hooks](https://pre-commit.com/)
- [Pytest Documentation](https://docs.pytest.org/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)

---

*Last updated: September 2025*
