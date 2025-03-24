#!/usr/bin/env python3
"""
Compatibility fixes for IDM-VTON when running with Python 3.12.4 and newer libraries
"""

import os
import sys
import re
import importlib.util
import importlib.machinery
from pathlib import Path

def fix_huggingface_hub_cached_download():
    """
    Fix the deprecated cached_download function in huggingface_hub
    """
    try:
        from huggingface_hub import hf_hub_download
        import diffusers.utils.dynamic_modules_utils as dmu
        import inspect
        
        # Check if the module is using cached_download
        source_code = inspect.getsource(dmu)
        if "cached_download" in source_code:
            # Find the file path
            file_path = inspect.getfile(dmu)
            print(f"Patching {file_path}")
            
            # Read the current content
            with open(file_path, "r") as file:
                content = file.read()
            
            # Replace the problematic import line
            fixed_content = content.replace(
                "from huggingface_hub import cached_download, hf_hub_download, model_info",
                "from huggingface_hub import hf_hub_download, model_info\n# Compatibility for older diffusers versions\ndef cached_download(*args, **kwargs):\n    return hf_hub_download(*args, **kwargs)"
            )
            
            # Write the corrected content back to the file
            with open(file_path, "w") as file:
                file.write(fixed_content)
            
            print("✅ Successfully patched huggingface_hub cached_download")
        else:
            print("ℹ️ No need to patch huggingface_hub cached_download")
            
    except Exception as e:
        print(f"❌ Failed to patch huggingface_hub cached_download: {e}")

def fix_huggingface_hub_resume_download():
    """
    Fix the deprecated resume_download parameter in huggingface_hub
    """
    try:
        import inspect
        from huggingface_hub import file_download
        
        # Check if the module has resume_download parameter warnings
        source_code = inspect.getsource(file_download.hf_hub_download)
        if "resume_download" in source_code:
            # Find the file path
            file_path = inspect.getfile(file_download)
            print(f"Patching {file_path}")
            
            # Read the current content
            with open(file_path, "r") as file:
                content = file.read()
            
            # Find all usages of resume_download parameter
            pattern = r'resume_download\s*=\s*([^,\)]+)'
            matches = re.findall(pattern, content)
            
            if matches:
                # Replace resume_download with force_download=not <value>
                for match in set(matches):
                    content = content.replace(
                        f"resume_download={match},", 
                        f"force_download=not {match},")
                
                # Write the corrected content back to the file
                with open(file_path, "w") as file:
                    file.write(content)
                
                print("✅ Successfully patched huggingface_hub resume_download parameter")
            else:
                print("ℹ️ No resume_download parameters found to patch")
        else:
            print("ℹ️ No need to patch huggingface_hub resume_download parameter")
            
    except Exception as e:
        print(f"❌ Failed to patch huggingface_hub resume_download parameter: {e}")

def fix_torch_pytree_registration():
    """
    Fix deprecated _register_pytree_node in torch.utils._pytree
    """
    try:
        import torch
        import diffusers.utils.outputs as outputs
        import inspect
        
        # Check if the module is using _register_pytree_node
        source_code = inspect.getsource(outputs)
        if "_register_pytree_node" in source_code:
            # Find the file path
            file_path = inspect.getfile(outputs)
            print(f"Patching {file_path}")
            
            # Read the current content
            with open(file_path, "r") as file:
                content = file.read()
            
            # Replace the problematic function call
            fixed_content = content.replace(
                "torch.utils._pytree._register_pytree_node",
                "torch.utils._pytree.register_pytree_node"
            )
            
            # Write the corrected content back to the file
            with open(file_path, "w") as file:
                file.write(fixed_content)
            
            print("✅ Successfully patched torch.utils._pytree._register_pytree_node")
        else:
            print("ℹ️ No need to patch torch.utils._pytree._register_pytree_node")
            
    except Exception as e:
        print(f"❌ Failed to patch torch.utils._pytree._register_pytree_node: {e}")

def apply_all_fixes():
    """Apply all compatibility fixes"""
    print("Applying compatibility fixes for Python 3.12.4 and newer dependencies...")
    try:
        import inspect
        fix_huggingface_hub_cached_download()
        fix_huggingface_hub_resume_download()
        fix_torch_pytree_registration()
        print("✅ All compatibility fixes applied successfully")
    except Exception as e:
        print(f"❌ Error applying compatibility fixes: {e}")
        
if __name__ == "__main__":
    apply_all_fixes() 