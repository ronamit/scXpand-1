#!/bin/bash
# Development Environment Setup Script
# Usage: source setup_dev_env.sh

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

echo "🚀 Setting up development environment for $(basename "$PROJECT_ROOT")"
echo "📂 Project root: $PROJECT_ROOT"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ uv is not installed. Please install it first:"
    echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo "   Then restart your terminal and run this script again."
    return 1
fi

echo "✅ uv is available: $(uv --version)"

# Create virtual environment
echo "🔧 Creating virtual environment..."
uv venv

# Activate the virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate

# Install the project in editable mode with dev dependencies
echo "📦 Installing project in editable mode with dev dependencies..."
if [[ -f "pyproject.toml" ]]; then
    uv pip install -e ".[dev,test,doc]"
else
    echo "⚠️  No pyproject.toml found. Installing basic dependencies..."
    uv pip install pytest pre-commit jupyter
fi

# Set up pre-commit hooks if they exist
if [[ -f ".pre-commit-config.yaml" ]]; then
    echo "🔧 Setting up pre-commit hooks..."
    pre-commit install
fi

echo ""
echo "🎉 Development environment setup complete!"
echo ""
echo "To activate the environment in the future, run:"
echo "   source dev-setup/activate_dev_env.sh"
echo ""
echo "Or manually:"
echo "   source venv/bin/activate"
echo ""
echo "Happy coding! 🚀"
