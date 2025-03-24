# IDM-VTON - Updated for Python 3.12.4 and CUDA 12.4

This is an updated version of the IDM-VTON project that works with Python 3.12.4 and CUDA 12.4. The original project is a diffusion-based virtual try-on system that can generate realistic try-on images given a person's image and a clothing item.

## Requirements

- Python 3.12.4
- CUDA 12.4
- PyTorch 2.3.0
- NVIDIA GPU with at least 8GB VRAM

## Installation

### Option 1: Using pip (Recommended)

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/IDM-VTON.git
   cd IDM-VTON
   ```

2. Run the setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

### Option 2: Using conda

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/IDM-VTON.git
   cd IDM-VTON
   ```

2. Create a conda environment using the environment.yaml file:
   ```bash
   conda env create -f environment.yaml
   conda activate idm
   ```

3. Apply compatibility fixes:
   ```bash
   python compatibility_fix.py
   ```

## Usage

### Training

To train the model:

```bash
python train_xl.py --data_dir "path/to/your/dataset" \
                  --gradient_checkpointing \
                  --use_8bit_adam \
                  --output_dir result \
                  --train_batch_size 1 \
                  --enable_xformers_memory_efficient_attention \
                  --gradient_accumulation_steps 2
```

### Inference

To run inference on test images:

```bash
python inference.py --pretrained_model_name_or_path "yisol/IDM-VTON" \
                   --data_dir "path/to/your/dataset" \
                   --num_inference_steps 30 \
                   --guidance_scale 2.0
```

### Gradio Demo

To run the Gradio demo:

```bash
python gradio_demo/app.py
```

## Compatibility Notes

This version has been updated to work with:
- Python 3.12.4 (upgraded from 3.10.0)
- CUDA 12.4 (upgraded from 11.8)
- PyTorch 2.3.0 (upgraded from 2.0.1)
- Diffusers 0.27.2 (upgraded from 0.25.0)
- Transformers 4.40.0 (upgraded from 4.36.2)

The following compatibility fixes have been applied:
1. Fixed deprecated `cached_download` function in HuggingFace Hub
2. Fixed deprecated `_register_pytree_node` function in PyTorch
3. Updated dependencies to their latest compatible versions

## Troubleshooting

If you encounter any issues:

1. Make sure you have the correct Python and CUDA versions installed
2. Try running the compatibility fix script again:
   ```bash
   python compatibility_fix.py
   ```
3. Check for any error messages during setup and installation

## Citation

If you use this project in your research, please cite the original IDM-VTON paper:

```
@InProceedings{jiang2023idmvton,
  title={IDM-VTON: Improving Diffusion Models for Virtual Try-On},
  author={Jiang, Yisol and Lee, Hyunsoo and Hwang, Wonseok and Kim, Dahun and Lee, Hyunsu},
  booktitle={SIGGRAPH Asia 2023 Conference Papers},
  year={2023}
}
``` 