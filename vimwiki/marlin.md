## marlin
```
Vase mode -> 0,6 extrusion width!
Speed depends on time for layer
7 sec min / 50% outline speed -> Seems safe with USB Fan
3 sec min / 100% outline speed -> NOT safe

pm2 for autostart (npm)
PolyFlex Filament: "Schuhe" - Recht hart aber flexibel
TPU: Gummi

# MARLIN 4 RigidBot
Configuration.h
Configuration_adv.h
-> Board type, PID, Autolevel+Manual

# Cold Extrusion
M302 P1 - Enable cold extrude
M83 - Relative Mode Extrusion
G1 E100 - Extrude 10cm

M106 / M107 - Fan On/Off

M302         ; report current cold extrusion state
M302 P0      ; enable cold extrusion checking
M302 P1      ; disable cold extrusion checking
M302 S0      ; always allow extrusion (disable checking)
M302 S170    ; only allow extrusion above 170
M302 S170 P1 ; set min extrude temp to 170 but leave disabled


# FAN
M106 S0 (S255) #fan speed

# EEPROM
M500 #Store current settings in EEPROM for the next startup or M501.
M501 #Read all parameters from EEPROM. (Or, undo changes.)
M502 #Reset current settings to defaults, as set in Configurations.h. (Follow with M500 to reset the EEPROM too.)
M503 #Print the current settings – ''Not the settings stored in EEPROM.''

# BED LEVELING
M111 S247 # max loggging
G28 # home
G29 # probe -> repeat for each
M500 # save
# start&tool change script!
M420 S1; enable bed leveling

# PID TUNING
M106 (startet den Lüfter auf 100%)
M303 E-0 S220 C8 (wählt das PID Tuning, wählt Extruder 0, Zieltemperatur 230 Grad und 8 Messzyklen)
# enter values
M301 P19.56 I1.48 D64.72
M500 zum speichern

# M501:
Send: M501
Recv: echo:SD init fail
Recv:  T:19.26 /0.00 B:19.37 /0.00 @:0 B@:0
Recv: ok
Recv: echo:V47 stored settings retrieved (614 bytes; crc 53533)
Recv: echo:  G21    ; Units in mm
Recv: echo:  M149 C ; Units in Celsius
Recv: 
Recv: echo:Filament settings: Disabled
Recv: echo:  M200 D3.00
Recv: echo:  M200 D0
Recv: echo:Steps per unit:
Recv: echo:  M92 X44.31 Y22.15 Z1600.00 E44.42
Recv: echo:Maximum feedrates (units/s):
Recv: echo:  M203 X500.00 Y500.00 Z5.00 E25.00
Recv: echo:Maximum Acceleration (units/s2):
Recv: echo:  M201 X800 Y800 Z100 E10000
Recv: echo:Acceleration (units/s2): P<print_accel> R<retract_accel> T<travel_accel>
Recv: echo:  M204 P600.00 R1000.00 T3000.00
Recv: echo:Advanced: S<min_feedrate> T<min_travel_feedrate> B<min_segment_time_us> X<max_xy_jerk> Z<max_z_jerk> E<max_e_jerk>
Recv: echo:  M205 S0.00 T0.00 B20000 X8.00 Y8.00 Z0.30 E5.00
Recv: echo:Home offset:
Recv: echo:  M206 X0.00 Y0.00 Z0.00
Recv: echo:Material heatup parameters:
Recv: echo:  M145 S0 H180 B70 F255
Recv: echo:  M145 S1 H240 B110 F255
Recv: echo:PID settings:
Recv: echo:  M301 P16.54 I0.97 D70.79
Recv: ok

New 24V+Fan:
Recv: #define DEFAULT_Kp 28.63
Recv: #define DEFAULT_Ki 2.30
Recv: #define DEFAULT_Kd 89.14

```
