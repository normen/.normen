# AMD Ryzen AI Max+ 395

## GPU kernel memory
```bash
# kernel params to assign GTT memory:
# ttm size: (Size in GB * 1024 * 1024) / 4,096
# e.g. 80 GB GTT: 20480000
# ttm.pages_limit=20480000 ttm.page_tool_size=20480000
```

## GPU kernel stability
```bash
# kernel params for stability:

# Lockup Timeout
# 0 (GFX): 5s (was 10s)
# 1 (Compute): 10s (was 60s wtf)
# 2 (SDMA): 10s (was 10s)
# 3 (Video): 5s (was 10s)
# amdgpu.lockup_timeout=5000,10000,10000,5000 \

# Enable GPU reset and relax lockup timeout:
# amdgpu.gpu_recovery=1 amdgpu.lockup_timeout=10000

# Keep IOMMU (data flow checks) on and use pass-through for
# performance and SVM stability:
# amd_iommu=on iommu=pt

# Prefer GFX ring for VM updates (helps when SDMA is disabled):
# amdgpu.vm_update_mode=0
```

## Ollama settings
```bash
# Ollama env vars (esp disabling SDMA):
# OLLAMA_HOST=0.0.0.0 \
# OLLAMA_KEEP_ALIVE=-1 \
# OLLAMA_MAX_LOADED_MODELS=1 \
# OLLAMA_CONTEXT_LENGTH=120000 \
# OLLAMA_NUM_GPU_LAYERS=9999 \
# OLLAMA_FLASH_ATTENTION=1 \
# OLLAMA_BATCH_SIZE=512 \
# OLLAMA_NOPRUNE=1 \
# OLLAMA_LOAD_TIMEOUT=5m \
# OLLAMA_LLM_LIBRARY=ROCm \
# HIP_VISIBLE_DEVICES=0 \
# HSA_ENABLE_SDMA=0 \ 

```
