# Documentation Build Instructions

## 🚀 **Quick Start - AnnData Documentation**

### **Build and View Documentation Locally**
```bash
# Navigate to AnnData repository
cd /Users/rona/my_repos/anndata

# Set environment variables (required)
export VIRTUAL_ENV="" && export PYENV_VIRTUAL_ENV=""

# Clear cache to ensure latest version (RECOMMENDED)
hatch run docs:clean

# Build the documentation
hatch run docs:build

# Open in browser (RECOMMENDED - Official Method)
hatch run docs:open

# Alternative: Serve on localhost
cd docs/_build/html && python3 -m http.server 8000
# Then open: http://localhost:8000
```

### **Alternative Manual Approach**
```bash
# If hatch approach has issues, use direct Sphinx
cd /Users/rona/my_repos/anndata
source venv/bin/activate
cd docs

# Clear cache first
make clean

# Build documentation
make html

# Open manually
open _build/html/index.html
```

## 📋 **Documentation Structure**

### **Key Files & Locations**
- **Main Index**: `docs/_build/html/index.html`
- **PyTorch Tutorial**: `docs/_build/html/tutorials/pytorch-dataset.html`
- **AnnDataset Demo**: `docs/_build/html/tutorials/notebooks/anndataset-demo.html`
- **API Reference**: `docs/_build/html/api.html#pytorch-dataset`

### **Your Contributions**
- ✅ **PyTorch Dataset Tutorial**: `/docs/tutorials/pytorch-dataset.md`
- ✅ **AnnDataset Demo Notebook**: `/docs/tutorials/notebooks/anndataset-demo.ipynb`
- ✅ **API Documentation**: Added to `/docs/api.md`
- ✅ **Index References**: Updated `/docs/tutorials/index.md`

## 🔧 **Development Workflow**

### **Make Changes and Rebuild**
```bash
cd /Users/rona/my_repos/anndata

# Set environment variables
export VIRTUAL_ENV="" && export PYENV_VIRTUAL_ENV=""

# Always clear cache before rebuilding (RECOMMENDED)
hatch run docs:clean

# Rebuild after changes
hatch run docs:build

# Open updated docs (official method)
hatch run docs:open

# Or serve on localhost
cd docs/_build/html && python3 -m http.server 8000
```

### **Stop/Start Localhost Server**
```bash
# Stop server: Ctrl+C in terminal where server is running

# Start server again
cd /Users/rona/my_repos/anndata/docs/_build/html
python -m http.server 8000

# Or use different port if 8000 is busy
python -m http.server 8080  # Access at http://localhost:8080
```

### **Common Build Issues & Solutions**

#### **Environment Variable Errors**
```bash
# If you get PYENV_VIRTUAL_ENV errors:
export PYENV_VIRTUAL_ENV=""

# Or unset it:
unset PYENV_VIRTUAL_ENV
```

#### **Cache Issues (Official Guidance)**
```bash
# ALWAYS clear cache when rebuilding to avoid stale content:
cd /Users/rona/my_repos/anndata
export VIRTUAL_ENV="" && export PYENV_VIRTUAL_ENV=""
hatch run docs:clean
hatch run docs:build
hatch run docs:open

# If docs still not updating as expected:
# 1. Force reload browser page (Cmd+Shift+R on Mac, Ctrl+Shift+R on others)
# 2. Clear browser cache completely
# 3. Try different browser or incognito mode
```

#### **Missing Dependencies**
```bash
# If Sphinx is missing:
cd /Users/rona/my_repos/anndata
source venv/bin/activate
pip install sphinx sphinx-rtd-theme
```

## 📖 **Viewing Your Work**

### **Access Documentation**

#### **Localhost Server (RECOMMENDED)**
- **Main Docs**: http://localhost:8000
- **PyTorch Tutorial**: http://localhost:8000/tutorials/pytorch-dataset.html
- **Demo Notebook**: http://localhost:8000/tutorials/notebooks/anndataset-demo.html

#### **Direct File Links (Alternative)**
- **Main Docs**: `file:///Users/rona/my_repos/anndata/docs/_build/html/index.html`
- **PyTorch Tutorial**: `file:///Users/rona/my_repos/anndata/docs/_build/html/tutorials/pytorch-dataset.html`
- **Demo Notebook**: `file:///Users/rona/my_repos/anndata/docs/_build/html/tutorials/notebooks/anndataset-demo.html`

### **Navigation Path**
1. Open main docs → **Tutorials** → **PyTorch Dataset**
2. Or **Tutorials** → **Notebooks** → **AnnDataset Demo**
3. Or **API** → scroll to **PyTorch Dataset** section

## 🎯 **Quality Check**

### **Verify Your Contributions**
- [ ] PyTorch tutorial loads without errors
- [ ] Demo notebook renders properly with outputs
- [ ] API documentation shows AnnDataset class
- [ ] Internal links work between tutorial and notebook
- [ ] Code examples are properly formatted
- [ ] Transform class documentation is clear

### **Expected Warnings (Safe to Ignore)**
```
WARNING: py:class reference target not found: torch.utils.data.Dataset
WARNING: py:class reference target not found: anndata.experimental.pytorch.Transform
```
These are expected since PyTorch classes aren't in the AnnData environment.

## 📝 **Notes for PR Review**

### **Documentation Features Added**
- ✅ **Comprehensive Tutorial**: Step-by-step PyTorch Dataset integration guide
- ✅ **Interactive Notebook**: Complete ML workflow with real data
- ✅ **API Documentation**: Full class and method documentation
- ✅ **Cross-References**: Links between tutorial, notebook, and API docs
- ✅ **Code Examples**: Runnable examples with proper formatting
- ✅ **Best Practices**: Transform class usage and multiprocessing safety

### **Build Status**
- ✅ Documentation builds successfully with `hatch run docs:build`
- ✅ Only expected warnings about external PyTorch classes
- ✅ All internal links and references work properly
- ✅ Notebook outputs render correctly in HTML

---

**Last Updated**: September 25, 2025
**Build Command**: `export PYENV_VIRTUAL_ENV="" && hatch run docs:build`
**View Command**: `hatch run docs:open`
