## MIDI
```
Voice Message           Status Byte      Data Byte1          Data Byte2
-------------           -----------   -----------------   -----------------
Note off                      8x      Key number          Note Off velocity
Note on                       9x      Key number          Note on velocity
Polyphonic Key Pressure       Ax      Key number          Amount of pressure
Control Change                Bx      Controller number   Controller value
Program Change                Cx      Program number      None
Channel Pressure              Dx      Pressure value      None            
Pitch Bend                    Ex      MSB                 LSB

System Real-Time Message         Status Byte 
------------------------         -----------
Timing Clock                         F8
Start Sequence                       FA
Continue Sequence                    FB
Stop Sequence                        FC
Active Sensing                       FE
System Reset                         FF

System Common Message   Status Byte      Number of Data Bytes
---------------------   -----------      --------------------
MIDI Timing Code            F1                   1
Song Position Pointer       F2                   2
Song Select                 F3                   1
Tune Request                F6                  None
```
