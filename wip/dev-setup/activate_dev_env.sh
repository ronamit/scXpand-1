#!/bin/bash
# Development Environment Activation Script
# Usage: source activate_dev_env.sh

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find project root by looking for pyproject.toml or other indicators
PROJECT_ROOT="$SCRIPT_DIR"
while [[ "$PROJECT_ROOT" != "/" ]]; do
    if [[ -f "$PROJECT_ROOT/pyproject.toml" ]] || [[ -f "$PROJECT_ROOT/setup.py" ]] || [[ -f "$PROJECT_ROOT/Pipfile" ]]; then
        break
    fi
    PROJECT_ROOT="$(dirname "$PROJECT_ROOT")"
done

# If we didn't find a project root, use the parent of the script directory
if [[ "$PROJECT_ROOT" == "/" ]]; then
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
fi

# Change to project root
cd "$PROJECT_ROOT"

# Check if venv exists, create if not
if [[ ! -d "venv" ]]; then
    echo "🔧 Creating virtual environment with uv..."
    uv venv
fi

# Activate the virtual environment
source venv/bin/activate

# Set up environment variables
export PYTHONPATH="$PROJECT_ROOT/src:$PYTHONPATH"

# Get project name from pyproject.toml or directory name
PROJECT_NAME=$(basename "$PROJECT_ROOT")
if [[ -f "pyproject.toml" ]]; then
    PROJECT_NAME=$(grep -E '^name\s*=' pyproject.toml | sed 's/name\s*=\s*["\x27]\([^"\x27]*\)["\x27].*/\1/' | head -1)
fi

echo "🚀 Development Environment Activated!"
echo "📍 Project: $PROJECT_NAME"
echo "📍 Python: $(which python)"
echo "📂 Working directory: $(pwd)"
echo ""

# Try to get version if it's a Python package
if [[ -f "pyproject.toml" ]]; then
    echo "📦 Package version: $(python -c "import $PROJECT_NAME; print($PROJECT_NAME.__version__)" 2>/dev/null || echo "Not installed yet")"
fi

echo ""
echo "Available commands:"
echo "  - pytest                     # Run tests"
echo "  - pre-commit run --all-files # Run linting"
echo "  - jupyter lab                # Start Jupyter Lab"
echo "  - uv pip install -e .       # Install in editable mode"
echo "  - uv pip install -e \".[dev,test,doc]\" # Install with dev dependencies"
echo ""
echo "Happy coding! 🚀"
