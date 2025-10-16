## OpenAI Codex tool
```bash
# Arch
yay -S openai-codex-bin
# any os
npm i -g @openai/codex

# install profile for ollama models:
vim ~/.codex/config.toml
<< CONTENT
[model_providers.ollama]
name = "Ollama"
base_url = "http://localhost:11434/v1"
[profiles.qwen3-coder-30b-ollama]
model_provider = "ollama"
model = "qwen3-coder:30b"
[profiles.qwen3-30b-ollama]
model_provider = "ollama"
model = "qwen3:30b"
CONTENT

# run codex:
codex --profile qwen3-30b-ollama
```

## Github Copilot
```bash
yay -S github-copilot
```
