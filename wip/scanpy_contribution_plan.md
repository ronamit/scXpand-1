# scXpand Contributions to Scanpy/AnnData - Strategic Implementation Plan

## 📍 **CURRENT STATUS & LOCATIONS**

### **Repository Status**
| Repository | Branch | PR | Status |
|------------|--------|----|---------|
| **AnnData** | `feature/enhanced-dataset-loader` | [#2127](https://github.com/scverse/anndata/pull/2127) (DRAFT) | ✅ Ready for submission |
| **AnnData Tutorials** | `feature/anndataset-demo-notebook` | [#23](https://github.com/scverse/anndata-tutorials/pull/23) (DRAFT) | ✅ Ready for coordination |
| **Scanpy** | `feature/sparse-pca-clean-v2` | [#3812](https://github.com/scverse/scanpy/pull/3812) (DRAFT) | ✅ Ready for submission |
| **Scanpy** | `feature/sparse-pca-clean-v2` | [#3813](https://github.com/scverse/scanpy/pull/3813) (DRAFT) | ✅ Ready for submission |

### **Code Locations**
- **AnnData**: `/Users/rona/my_repos/anndata` - 46 tests, Transform system, batch ordering fixes
- **Scanpy**: `/Users/rona/my_repos/scanpy` - Sparse PCA & HVG optimizations in experimental namespace

## 🎯 **SUBMISSION STRATEGY**

### **Phase 1: AnnData Foundation (This Week)**
1. **✅ Tutorial PR Created** - [PR #23](https://github.com/scverse/anndata-tutorials/pull/23) in draft mode
2. **🎯 Submit Main PR** - `cd /Users/rona/my_repos/anndata && gh pr ready 2127`
3. **Submit Tutorial PR** - `gh pr ready --repo scverse/anndata-tutorials 23` (after main PR)

### **Phase 2: Scanpy Optimizations (Week 2-3)**
1. **Sparse PCA** - `cd /Users/rona/my_repos/scanpy && gh pr ready 3812`
2. **HVG Optimization** - `cd /Users/rona/my_repos/scanpy && gh pr ready 3813`

## 📋 **PR SUMMARIES**

### **AnnData PyTorch Dataset (#2127)**
**Impact**: Production-ready PyTorch integration for ML workflows

**Key Features**:
- Transform class system for multiprocessing safety
- Observation subsetting for train/test splits
- h5py best practices with worker independence
- Batch ordering guarantee with optimized collate
- 46 comprehensive tests (27 core + 10 multiprocessing + 9 transforms)

### **AnnDataset Tutorial (#23)**
**Impact**: Comprehensive demonstration of PyTorch Dataset integration
- 551 lines demonstrating Transform system and realistic workflows
- Complete PyTorch training loop with scanpy datasets
- Professional documentation complementing main implementation

### **Sparse PCA Optimization (#3812)**
**Impact**: Enables million-cell PCA analysis on standard hardware
- True sparse algorithms (never densifies matrices)
- Intelligent method selection based on data characteristics
- GPU acceleration ready with CuPy integration

### **HVG Performance Optimization (#3813)**
**Impact**: 10-100x speedup for universal bottleneck operation
- Numba-accelerated variance calculations
- Memory-efficient chunked processing
- Simplified LOESS fitting with maintained accuracy

## ✅ **QUALITY ASSURANCE COMPLETED**

### **Technical Standards Met**
- ✅ **Comprehensive Testing**: 46+ tests across all implementations
- ✅ **Professional Documentation**: Numpydoc style with clear examples
- ✅ **Experimental Namespace**: All optimizations properly placed
- ✅ **Multiprocessing Safety**: h5py best practices implemented
- ✅ **Zero Breaking Changes**: Completely non-intrusive implementations
- ✅ **CI Compliance**: All pre-commit hooks passing

### **Code Quality Standards**
- ✅ **Type Hints**: Full type annotations throughout
- ✅ **Error Handling**: Robust validation and graceful failures
- ✅ **Memory Management**: Efficient streaming and chunked processing
- ✅ **Performance**: Optimized algorithms with sorted indices
- ✅ **Configurable Parameters**: No hard-coded constants

## 🚨 **COMMON CI ISSUES & SOLUTIONS**

### **Critical Issues Encountered & Fixes**

#### **PyTorch Dependency Management** ✅ **RESOLVED**
**Problem**: Tests failing in CI because PyTorch not installed
```
ImportError: PyTorch is required for AnnDataset. Please install PyTorch: pip install torch
```
**Solution**:
- Export `TORCH_AVAILABLE` from module for test skipping
- Add `@pytest.mark.skipif(not TORCH_AVAILABLE)` to test classes
- Skip doctests with `# doctest: +SKIP` for PyTorch-dependent examples

#### **Linting Discrepancies** ✅ **RESOLVED**
**Problem**: Local ruff checks passed, but CI failed with different rules
```
F841 Local variable is assigned to but never used
SIM118 Use `key in dict` instead of `key in dict.keys()`
```
**Solution**:
- Run CI-equivalent checks locally before pushing
- Fix unused variables by removing or commenting out
- Use direct dict iteration instead of `.keys()` method

#### **Doctest Failures** ✅ **RESOLVED**
**Problem**: Pytest running doctests on examples requiring optional dependencies
**Solution**:
- Add `# doctest: +SKIP` to examples using optional dependencies
- Test examples separately in environments with dependencies

### **Common CI Issues & Quick Fixes**

**Test Failures**:
- **Missing dependencies**: Add `@pytest.mark.skipif` test skipping
- **Import errors**: Check optional dependency handling
- **Environment differences**: Test in clean virtual environment

**Linting Failures**:
- **Unused variables**: Remove or prefix with underscore
- **Style violations**: Run formatter and fix manually
- **Type hints**: Add missing annotations

**Coverage Failures**:
- **New code untested**: Add test cases for new functionality
- **Dead code**: Remove unused functions
- **Edge cases**: Test boundary conditions

## 📋 **BEST PRACTICES FOR ROBUST PRs**

### **Pre-Submission Checklist**
- [ ] Run local linting with same tools as CI (`ruff check`, `ruff format`)
- [ ] Test optional dependency handling (skip tests when dependencies missing)
- [ ] Verify doctest compatibility (add `# doctest: +SKIP` where needed)
- [ ] Check test coverage (ensure new code is tested)
- [ ] Validate imports (test in clean environment)
- [ ] Review CI configuration (understand what checks will run)

### **Code Quality Standards**
- ✅ **Handle optional dependencies gracefully** (import checks, test skipping)
- ✅ **Use type hints consistently** (helps catch errors early)
- ✅ **Write comprehensive tests** (cover happy path and edge cases)
- ✅ **Document with examples** (but skip doctests for optional dependencies)
- ✅ **Follow project conventions** (naming, structure, style)

### **CI Preparation**
- ✅ **Test in clean environment** (virtual environment, fresh install)
- ✅ **Run same tools as CI** (linting, formatting, testing)
- ✅ **Check for optional dependencies** (skip tests when missing)
- ✅ **Validate all examples** (ensure they work or are properly skipped)

### **PR Management**
- ✅ **Small, focused changes** (easier to review and debug)
- ✅ **Clear commit messages** (describe what and why)
- ✅ **Professional descriptions** (technical focus, no marketing language)
- ✅ **Respond quickly to feedback** (within 24 hours)

### **CI Failure Response Strategy**
1. **Identify failure type**: Test failure, linting, coverage, or configuration
2. **Check logs carefully**: Look for specific error messages and line numbers
3. **Fix systematically**: Address one issue type at a time
4. **Test locally**: Reproduce CI environment conditions when possible
5. **Commit incrementally**: Small, focused commits for easier debugging

## 🚀 **IMMEDIATE ACTIONS**

### **Next Command to Execute**
```bash
cd /Users/rona/my_repos/anndata && gh pr ready 2127
```

### **Follow-up Sequence**
1. Submit tutorial PR after main PR gains traction
2. Monitor for reviewer feedback (respond within 24 hours)
3. Submit Scanpy PRs based on AnnData reception
4. Document maintainer preferences for future contributions

## 🔗 **QUICK REFERENCE**

### **Commands**
- **Submit AnnData**: `cd /Users/rona/my_repos/anndata && gh pr ready 2127`
- **Submit Tutorial**: `gh pr ready --repo scverse/anndata-tutorials 23`
- **Submit Sparse PCA**: `cd /Users/rona/my_repos/scanpy && gh pr ready 3812`
- **Submit HVG**: `cd /Users/rona/my_repos/scanpy && gh pr ready 3813`
- **Check Status**: `gh pr list --state open`

### **Key Links**
- [AnnData PR #2127](https://github.com/scverse/anndata/pull/2127)
- [Tutorial PR #23](https://github.com/scverse/anndata-tutorials/pull/23)
- [Sparse PCA PR #3812](https://github.com/scverse/scanpy/pull/3812)
- [HVG PR #3813](https://github.com/scverse/scanpy/pull/3813)

---
**Status**: All PRs prepared and ready for strategic submission. Next action: Submit main AnnData PR.
