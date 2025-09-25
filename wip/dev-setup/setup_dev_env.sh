#!/bin/bash

# Development Environment Setup Script
# Based on scverse ecosystem best practices
# Compatible with AnnData, Scanpy, and other scientific Python projects

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Configuration
PROJECT_TYPE=""
PYTHON_VERSION="3.11"
INSTALL_EXTRAS="dev,test,doc"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --type)
            PROJECT_TYPE="$2"
            shift 2
            ;;
        --python)
            PYTHON_VERSION="$2"
            shift 2
            ;;
        --extras)
            INSTALL_EXTRAS="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --type TYPE       Project type: hatch, uv, or auto (default: auto)"
            echo "  --python VERSION  Python version (default: 3.11)"
            echo "  --extras EXTRAS   Install extras (default: dev,test,doc)"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Detect project type if not specified
detect_project_type() {
    if [[ -f "hatch.toml" ]]; then
        PROJECT_TYPE="hatch"
    elif [[ -f "pyproject.toml" ]] && grep -q "build-backend.*hatchling" pyproject.toml 2>/dev/null; then
        PROJECT_TYPE="hatch"
    elif [[ -f "pyproject.toml" ]]; then
        PROJECT_TYPE="uv"
    else
        PROJECT_TYPE="uv"
    fi
    log_info "Detected project type: $PROJECT_TYPE"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install UV if not present
install_uv() {
    if ! command_exists uv; then
        log_info "Installing UV..."
        curl -LsSf https://astral.sh/uv/install.sh | sh

        # Add to PATH for current session
        export PATH="$HOME/.local/bin:$PATH"

        if command_exists uv; then
            log_success "UV installed successfully"
        else
            log_error "Failed to install UV"
            exit 1
        fi
    else
        log_info "UV already installed"
    fi
}

# Install Hatch if not present
install_hatch() {
    if ! command_exists hatch; then
        log_info "Installing Hatch..."
        if command_exists uv; then
            uv tool install hatch
        else
            pip install hatch
        fi

        if command_exists hatch; then
            log_success "Hatch installed successfully"
        else
            log_error "Failed to install Hatch"
            exit 1
        fi
    else
        log_info "Hatch already installed"
    fi
}

# Setup Hatch-based project
setup_hatch_project() {
    log_info "Setting up Hatch-based project..."

    # Install hatch if needed
    install_hatch

    # Install pre-commit in hatch environment if pyproject.toml includes it
    if grep -q "pre-commit" pyproject.toml 2>/dev/null; then
        log_info "Installing pre-commit hooks..."
        hatch run pip install pre-commit
        hatch run pre-commit install
        log_success "Pre-commit hooks installed"
    fi

    log_success "Hatch project setup complete"

    # Show available environments
    log_info "Available Hatch environments:"
    hatch env show 2>/dev/null || log_warning "Could not show Hatch environments"
}

# Setup UV-based project
setup_uv_project() {
    log_info "Setting up UV-based project..."

    # Install UV if needed
    install_uv

    # Create virtual environment
    log_info "Creating virtual environment with Python $PYTHON_VERSION..."
    uv venv --python "$PYTHON_VERSION"

    # Source the virtual environment
    source .venv/bin/activate

    # Install project in development mode
    log_info "Installing project dependencies..."
    if [[ -f "pyproject.toml" ]]; then
        uv pip install -e ".[$INSTALL_EXTRAS]"
    else
        log_warning "No pyproject.toml found, installing basic dependencies..."
        uv pip install -e .
    fi

    # Install pre-commit if requirements include it or if .pre-commit-config.yaml exists
    if [[ -f ".pre-commit-config.yaml" ]]; then
        log_info "Installing pre-commit..."
        uv pip install pre-commit
        pre-commit install
        log_success "Pre-commit hooks installed"
    fi

    log_success "UV project setup complete"
}

# Verify installation
verify_installation() {
    log_info "Verifying installation..."

    if [[ "$PROJECT_TYPE" == "hatch" ]]; then
        # Test hatch commands
        if hatch env show >/dev/null 2>&1; then
            log_success "Hatch environment is working"
        else
            log_warning "Hatch environment may have issues"
        fi
    else
        # Check virtual environment
        if [[ -d ".venv" ]] && [[ -n "${VIRTUAL_ENV:-}" ]]; then
            log_success "Virtual environment is active"
            python --version
        else
            log_warning "Virtual environment may not be properly activated"
        fi
    fi

    # Check pre-commit
    if command_exists pre-commit; then
        log_success "Pre-commit is available"
    else
        log_warning "Pre-commit not found"
    fi
}

# Print usage instructions
print_usage_instructions() {
    echo ""
    log_success "Setup complete! Here's how to use your development environment:"
    echo ""

    if [[ "$PROJECT_TYPE" == "hatch" ]]; then
        echo "🔧 Hatch Commands:"
        echo "  hatch test                    # Run tests"
        echo "  hatch test -p                 # Run tests in parallel"
        echo "  hatch run docs:build          # Build documentation"
        echo "  hatch run docs:open           # Open docs in browser"
        echo "  hatch run pre-commit run --all-files  # Run code quality checks"
        echo ""
        echo "📚 Documentation:"
        echo "  hatch run docs:build && hatch run docs:open"
        echo ""
    else
        echo "🔧 Development Commands:"
        echo "  source .venv/bin/activate     # Activate environment (if not active)"
        echo "  pytest                        # Run tests"
        echo "  pytest -n auto                # Run tests in parallel"
        echo "  pre-commit run --all-files    # Run code quality checks"
        echo ""
        echo "📚 Documentation (if configured):"
        echo "  cd docs && make html          # Build docs"
        echo "  open docs/_build/html/index.html  # Open docs"
        echo ""
    fi

    echo "🌟 Next Steps:"
    echo "  1. Create a feature branch: git switch -c feature/your-feature"
    echo "  2. Make your changes"
    echo "  3. Run tests and quality checks"
    echo "  4. Commit and push your changes"
    echo ""
    echo "📖 For more information, see the README.md in this directory"
}

# Main execution
main() {
    log_info "Starting development environment setup..."

    # Auto-detect project type if not specified
    if [[ -z "$PROJECT_TYPE" ]] || [[ "$PROJECT_TYPE" == "auto" ]]; then
        detect_project_type
    fi

    # Setup based on project type
    case "$PROJECT_TYPE" in
        hatch)
            setup_hatch_project
            ;;
        uv)
            setup_uv_project
            ;;
        *)
            log_error "Unknown project type: $PROJECT_TYPE"
            exit 1
            ;;
    esac

    # Verify installation
    verify_installation

    # Print usage instructions
    print_usage_instructions
}

# Run main function
main "$@"
