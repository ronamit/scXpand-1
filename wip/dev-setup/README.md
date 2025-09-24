# Development Environment Setup

General-purpose scripts for Python development environments using `uv`.

## Quick Usage

```bash
# Copy to your project
cp -r /Users/rona/my_repos/scXpand/wip/dev-setup /path/to/your/project/
cd /path/to/your/project

# First time setup
source dev-setup/setup_dev_env.sh

# Subsequent activations
source dev-setup/activate_dev_env.sh
```

## Or Use Directly

```bash
# From any project directory
source /Users/rona/my_repos/scXpand/wip/dev-setup/activate_dev_env.sh
```

## Requirements

- `uv`: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Python 3.11+
