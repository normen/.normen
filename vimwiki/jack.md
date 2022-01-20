## jack / alsa
```bash
sudo apt install jack-tools
jack_control ds alsa
jack_control dp
jack_control dps device hw:3
jack_control dps rate 44100
jack_control dps period 128
jack_control start
cpanm Audio::Nama
nama
# start manually
jackd -d alsa -dhw:3 -p 128 -r 44100
```
