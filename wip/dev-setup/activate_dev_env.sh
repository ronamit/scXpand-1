#!/bin/bash

# Development Environment Activation Script
# Activates the appropriate development environment based on project type

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Check if we're in a project directory
if [[ ! -f "pyproject.toml" ]] && [[ ! -f "setup.py" ]] && [[ ! -f "hatch.toml" ]]; then
    log_warning "No Python project detected in current directory"
    log_info "Looking for pyproject.toml, setup.py, or hatch.toml"
    return 1 2>/dev/null || exit 1
fi

# Detect project type
PROJECT_TYPE=""
if [[ -f "hatch.toml" ]]; then
    PROJECT_TYPE="hatch"
elif [[ -f "pyproject.toml" ]] && grep -q "build-backend.*hatchling" pyproject.toml 2>/dev/null; then
    PROJECT_TYPE="hatch"
elif [[ -d ".venv" ]]; then
    PROJECT_TYPE="uv"
else
    PROJECT_TYPE="unknown"
fi

# Activate based on project type
case "$PROJECT_TYPE" in
    hatch)
        log_info "Detected Hatch project"
        log_success "Hatch manages environments automatically"

        # Show available environments
        if command -v hatch >/dev/null 2>&1; then
            log_info "Available Hatch environments:"
            hatch env show 2>/dev/null || log_warning "Could not show Hatch environments"
        else
            log_warning "Hatch not found. Install with: uv tool install hatch"
        fi

        # Set up shell aliases for convenience
        alias htest='hatch test'
        alias hdocs='hatch run docs:build'
        alias hopen='hatch run docs:open'
        alias hcheck='hatch run pre-commit run --all-files'

        log_info "Hatch aliases available: htest, hdocs, hopen, hcheck"
        ;;

    uv)
        log_info "Detected UV project with virtual environment"

        # Check if already activated
        if [[ -n "${VIRTUAL_ENV:-}" ]] && [[ "$VIRTUAL_ENV" == "$(pwd)/.venv" ]]; then
            log_success "Virtual environment already activated"
        else
            # Activate virtual environment
            if [[ -f ".venv/bin/activate" ]]; then
                source .venv/bin/activate
                log_success "Virtual environment activated: $(python --version)"
            else
                log_warning "Virtual environment not found. Run setup script first."
                return 1 2>/dev/null || exit 1
            fi
        fi

        # Set up convenient aliases
        alias pytest-fast='pytest -n auto'
        alias pytest-cov='pytest --cov=src --cov-report=html'
        alias check='pre-commit run --all-files'

        log_info "Aliases available: pytest-fast, pytest-cov, check"
        ;;

    unknown)
        log_warning "Could not detect project type"

        # Try to activate .venv if it exists
        if [[ -f ".venv/bin/activate" ]]; then
            source .venv/bin/activate
            log_success "Activated .venv virtual environment"
        else
            log_info "No .venv found. Consider running the setup script."
        fi
        ;;
esac

# Common development aliases (available for all project types)
alias ll='ls -la'
alias la='ls -la'
alias ..='cd ..'
alias ...='cd ../..'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'

# Development helpers
alias ports='lsof -i -P -n | grep LISTEN'
alias myip='curl -s ifconfig.me'

# Function to show project info
show_project_info() {
    echo ""
    echo "📋 Project Information:"
    echo "   Type: $PROJECT_TYPE"
    echo "   Directory: $(pwd)"

    if [[ "$PROJECT_TYPE" == "hatch" ]]; then
        if command -v hatch >/dev/null 2>&1; then
            echo "   Hatch version: $(hatch --version)"
        fi
    elif [[ "$PROJECT_TYPE" == "uv" ]]; then
        if [[ -n "${VIRTUAL_ENV:-}" ]]; then
            echo "   Python: $(python --version)"
            echo "   Virtual env: $VIRTUAL_ENV"
        fi
    fi

    if [[ -f "pyproject.toml" ]]; then
        local project_name=$(grep -m1 '^name = ' pyproject.toml 2>/dev/null | cut -d'"' -f2)
        if [[ -n "$project_name" ]]; then
            echo "   Project: $project_name"
        fi
    fi
    echo ""
}

# Function to show available commands
show_dev_commands() {
    echo "🛠️  Development Commands:"

    if [[ "$PROJECT_TYPE" == "hatch" ]]; then
        echo "   htest                         # Run tests"
        echo "   hatch test -p                 # Run tests in parallel"
        echo "   hdocs                         # Build documentation"
        echo "   hopen                         # Open docs in browser"
        echo "   hcheck                        # Run pre-commit checks"
        echo "   hatch run towncrier:create    # Create changelog entry"
    else
        echo "   pytest                        # Run tests"
        echo "   pytest-fast                   # Run tests in parallel"
        echo "   pytest-cov                    # Run tests with coverage"
        echo "   check                         # Run pre-commit checks"
    fi

    echo ""
    echo "📚 Documentation Commands:"
    if [[ "$PROJECT_TYPE" == "hatch" ]]; then
        echo "   hdocs && hopen                # Build and open docs"
    else
        echo "   cd docs && make html          # Build docs (if Sphinx)"
        echo "   sphinx-build docs docs/_build/html  # Alternative build"
    fi

    echo ""
    echo "🔧 Utility Commands:"
    echo "   show_project_info             # Show project information"
    echo "   show_dev_commands             # Show this help"
    echo ""
}

# Export functions for use in shell
export -f show_project_info
export -f show_dev_commands

# Show project info on activation
show_project_info

# Helpful message
if [[ "$PROJECT_TYPE" == "hatch" ]]; then
    log_info "Hatch project ready! Try 'htest' to run tests or 'show_dev_commands' for more options."
elif [[ "$PROJECT_TYPE" == "uv" ]]; then
    log_info "Development environment ready! Try 'pytest' to run tests or 'show_dev_commands' for more options."
fi
