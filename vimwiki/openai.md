# OpenAI
## GPT-2
```bash
git clone https://github.com/openai/gpt-2.git
cd gpt-2/
python3 -m venv ~/venv-gpt-2
. ~/venv-gpt-2/bin/activate
pip install tensorflow-gpu-macosx
#==1.12
pip install -r requirements.txt
./download_model.py 345M

sed -i 's/top_k=0/top_k=40/g' src/interactive_conditional_samples.py
python3 src/interactive_conditional_samples.py


```
