# AMD Ryzen AI Max+ 395

## CachyOS (Arch Linux)
Using Arch Linux based CachyOS for best performance and latest ROCm support.
```bash
pacman -S ollama-rocm
```

## GPU kernel memory - GTT
We need to assign enough GTT memory for large models to load properly.
Set the VRAM size in BIOS to minimum (1GB) to maximize GTT size.
```bash
# kernel params to assign GTT memory:
# ttm size: (Size in GB * 1024 * 1024) / 4,096
# e.g. 80 GB GTT: 20480000
# ttm.pages_limit=20480000 ttm.page_tool_size=20480000
# e.g. 120GB 
# ttm.pages_limit=30720000 ttm.page_tool_size=30720000
```

## GPU kernel parameters - stability
These paraters help with GPU stability.
```bash
# kernel params for stability:

# Lockup Timeout
# 0 (GFX): 5s (was 10s)
# 1 (Compute): 10s (was 60s wtf)
# 2 (SDMA): 10s (was 10s)
# 3 (Video): 5s (was 10s)

# Enable GPU reset and relax lockup timeout:
# amdgpu.gpu_recovery=1 amdgpu.lockup_timeout=60000,60000,60000,60000

# Keep IOMMU (data flow checks) on and use pass-through for
# performance and SVM stability:
# amd_iommu=on iommu=pt

# Prefer GFX ring for VM updates (helps when SDMA is disabled):
# amdgpu.vm_update_mode=0
```

## Hard Restart
If the GPU hangs, you can trigger a hard restart of the whole system via sysrq:
Still need to find a way to only reset the GPU... The user space tools don't work reliably.
```bash
sudo sh -c "echo b > /proc/sysrq-trigger"
```

## Ollama settings (Disable SDMA for now)
**Note:** Ollama still has issues getting the memory size when loading / unloading models
and thus loads models into CPU memory instead of GPU memory.
Unload models manually, avoid changing model parameters on the fly.

Important parameter is HSA_ENABLE_SDMA=0 to disable SDMA engine which seems to cause issues.
512 GPU layers seems to be the default for a lot of tools, so we keep that to avoid reloading.
```bash
# Ollama env vars (esp disabling SDMA):
# OLLAMA_HOST=0.0.0.0 \
# OLLAMA_KEEP_ALIVE=-1 \
# OLLAMA_MAX_LOADED_MODELS=1 \
# OLLAMA_CONTEXT_LENGTH=40960 \
# OLLAMA_NUM_GPU_LAYERS=512 \
# OLLAMA_FLASH_ATTENTION=1 \
# OLLAMA_BATCH_SIZE=512 \
# OLLAMA_NOPRUNE=1 \
# OLLAMA_LOAD_TIMEOUT=5m \
# OLLAMA_LLM_LIBRARY=ROCm \
# HIP_VISIBLE_DEVICES=0 \
# ROCR_VISIBLE_DEVICES=0 \
# HSA_ENABLE_SDMA=0 \ 

```

## Ollama service (limits!)
Create a systemd service to run ollama on boot with proper limits:
```bash
<<CONTENT
[Unit]
Description=Ollama LLM Server
After=syslog.target network-online.target

[Service]
Type=simple
LimitMEMLOCK=infinity
LimitNOFILE=1048576
ExecStart=/home/normen/ai-server/ollama-run.sh
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
CONTENT
```

## Max map counts
We need to increase the max map counts for large models to work properly,
otherwise you get errors like: "failed to sample token"
```bash
# increase max map counts for memory access:
sudoedit /etc/sysctl.d/99-llm.conf
<<CONTENT
vm.max_map_count=1048576
CONTENT
```
