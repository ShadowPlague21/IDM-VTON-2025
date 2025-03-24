#!/bin/bash

# Setup script for IDM-VTON with Python 3.12.4 and CUDA 12.4

# Exit on error
set -e

echo "Setting up IDM-VTON with Python 3.12.4 and CUDA 12.4..."

# Check Python version
PYTHON_VERSION=$(python --version 2>&1)
echo "Detected: $PYTHON_VERSION"

if [[ $PYTHON_VERSION != *"3.12"* ]]; then
  echo "Warning: You're not using Python 3.12. Some features may not work correctly."
  read -p "Continue? (y/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Check CUDA availability
if command -v nvcc &> /dev/null; then
  CUDA_VERSION=$(nvcc --version | grep -o "release [0-9]*\.[0-9]*" | grep -o "[0-9]*\.[0-9]*")
  echo "Detected CUDA version: $CUDA_VERSION"
  if [[ "$CUDA_VERSION" != "12.4" ]]; then
    echo "Warning: CUDA 12.4 is recommended. Using $CUDA_VERSION may cause issues."
    read -p "Continue? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  fi
else
  echo "Warning: CUDA not detected. This project requires CUDA 12.4."
  read -p "Continue without CUDA? (y/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Install Python dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Apply compatibility fixes
echo "Applying compatibility fixes..."
python compatibility_fix.py

echo "Setup complete! You can now run the following commands:"
echo "  - For training: python train_xl.py"
echo "  - For inference: python inference.py"
echo "  - For the demo: python app.py" 