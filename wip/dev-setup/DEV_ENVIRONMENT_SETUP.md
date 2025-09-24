# Development Environment Setup

## Overview
This document describes the development environment setup for Python projects using `uv` for fast and reliable dependency management.

## Prerequisites

### Required Tools
- **uv**: Fast Python package installer and resolver
  ```bash
  # Install uv if not already installed
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```

- **Python**: Version 3.11+ (uv will automatically manage Python versions)

## Environment Details

### Virtual Environment
- **Location**: `./venv/` (relative to project root)
- **Python Version**: Python 3.11+
- **Package Manager**: uv
- **Installation Type**: Editable installation (`uv pip install -e ".[dev,test,doc]"`)

### Key Benefits of uv
- **Speed**: 10-100x faster than pip
- **Reliability**: Better dependency resolution
- **Reproducibility**: Lock files for consistent installs
- **Python Management**: Automatic Python version handling

### Installed Dependencies

#### Core Dependencies
- **AnnData**: 0.13.0.dev90+gdcfa1021a.d20250924 (development version)
- **NumPy**: 2.3.3
- **Pandas**: 2.3.2
- **SciPy**: 1.16.2
- **h5py**: 3.14.0
- **Zarr**: 3.1.3

#### Development Dependencies
- **Testing**: pytest, pytest-cov, pytest-memray, pytest-mock, pytest-randomly, pytest-xdist
- **Linting**: ruff, black, pre-commit
- **Documentation**: sphinx, sphinx-book-theme, myst-nb, scanpydoc
- **Notebooks**: jupyter, ipykernel, jupyterlab

#### Optional Dependencies
- **Performance**: numba, fast-array-utils
- **Data Processing**: dask, xarray, awkward
- **Machine Learning**: scikit-learn, scanpy
- **Visualization**: matplotlib, seaborn

## Quick Start

### Setup (First Time)
```bash
# Navigate to your project directory
cd /path/to/your/project

# Create and activate virtual environment with uv
uv venv

# Activate the environment
source venv/bin/activate

# Install project in editable mode with dev dependencies
uv pip install -e ".[dev,test,doc]"

# Or use the convenience script
source dev-setup/activate_dev_env.sh
```

### Activation (Subsequent Uses)
```bash
# Navigate to the project directory
cd /path/to/your/project

# Activate the environment using the convenience script
source dev-setup/activate_dev_env.sh

# Or manually activate
source venv/bin/activate
```

### Basic Commands
```bash
# Run tests
pytest

# Run linting
pre-commit run --all-files

# Start Jupyter Lab
jupyter lab

# Run specific tests
python -m pytest tests/test_ann_dataset.py

# Build documentation
cd docs && make html
```

## Development Workflow

### Pre-commit Hooks
Pre-commit hooks are installed and configured to run:
- **ruff check**: Code linting and formatting
- **ruff format**: Code formatting
- **taplo**: TOML file formatting
- **codespell**: Spell checking
- **Standard hooks**: trailing whitespace, end-of-file fixing, etc.

### Testing
The project uses pytest with several plugins:
- **Coverage reporting**: pytest-cov
- **Memory profiling**: pytest-memray
- **Mocking**: pytest-mock
- **Randomized testing**: pytest-randomly
- **Parallel execution**: pytest-xdist

### Code Quality
- **Linting**: ruff (configured in pyproject.toml)
- **Formatting**: ruff format with preview features enabled
- **Type checking**: Uses type hints throughout the codebase

## Project Structure

### Key Directories
- `src/anndata/`: Main package source code
- `tests/`: Test suite
- `docs/`: Documentation source
- `benchmarks/`: Performance benchmarks

### Configuration Files
- `pyproject.toml`: Main project configuration (dependencies, build, tools)
- `hatch.toml`: Hatch environment configuration
- `.pre-commit-config.yaml`: Pre-commit hooks configuration
- `docs/conf.py`: Sphinx documentation configuration

## Development Features

### AnnDataset (New Feature)
The development environment includes the new `AnnDataset` PyTorch integration:
- **Location**: `src/anndata/experimental/pytorch/_ann_dataset.py`
- **Tests**: `src/anndata/tests/test_ann_dataset.py`
- **Documentation**: `docs/tutorials/pytorch-dataset.md`

### Key Capabilities
- **Memory-efficient**: Handles large datasets without loading everything into memory
- **Multiprocessing-safe**: Follows h5py best practices for concurrent access
- **PyTorch integration**: Standard Dataset interface for ML workflows
- **Flexible transforms**: Support for data preprocessing and augmentation

## Troubleshooting

### Common Issues
1. **Import errors**: Ensure the virtual environment is activated
2. **Test failures**: Check if all optional dependencies are installed
3. **Pre-commit failures**: Run `pre-commit run --all-files` to fix issues

### Environment Verification
```python
import anndata as ad
import numpy as np

# Test basic functionality
X = np.random.randn(100, 20)
adata = ad.AnnData(X=X)
print(f"✅ AnnData version: {ad.__version__}")
print(f"✅ Shape: {adata.shape}")
```

## Additional Resources

- **Official Documentation**: https://anndata.readthedocs.io/
- **GitHub Repository**: https://github.com/scverse/anndata
- **Contributing Guide**: docs/contributing.md
- **API Reference**: docs/api.md

## Environment Variables
- `PYTHONPATH`: Set to include the source directory for development
- Development tools respect standard environment variables (e.g., `PYTEST_ARGS`)

---

**Created**: September 24, 2025
**Last Updated**: September 24, 2025
**Python Version**: 3.11
**AnnData Version**: 0.13.0.dev90+gdcfa1021a.d20250924
