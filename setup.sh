#!/bin/bash

# Setup script for IDM-VTON with Python 3.12.4 and CUDA 12.4

# Exit on error
set -e

echo "Setting up IDM-VTON for Python 3.12.4 and CUDA 12.4..."

# Install dependencies
if [ -x "$(command -v conda)" ]; then
    echo "Installing with conda..."
    conda env create -f environment.yaml
    conda activate idm
else
    echo "Installing with pip..."
    pip install -r requirements.txt
fi

# Run compatibility fixes
python compatibility_fix.py

# Check CUDA availability
python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('CUDA version:', torch.version.cuda if torch.cuda.is_available() else 'N/A')"

echo "Setup complete! You can now use IDM-VTON with Python 3.12.4 and PyTorch 2.3.0"

chmod +x setup.sh 