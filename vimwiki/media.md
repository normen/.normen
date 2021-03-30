# wmv ffpmeg
```bash
for f in *.wmv; do ffmpeg -i "$f" "${f%.wmv}.wav"; done
for f in *.wmv; do ffmpeg -i "$f" -c:a libmp3lame -q:a 2 "${f%.wmv}.mp3"; done
```
