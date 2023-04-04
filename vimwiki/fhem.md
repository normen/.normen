# FHEM
```
rlwrap telnet localhost 7072
inform on
inform log
set CULMAX0 pairmode 60
-> pair on device
shutdown restart
```
## nanoCUL flashen
```bash
sudo apt install avrdude gcc-avr avr-libc
#wget http://culfw.de/culfw-1.67.tar.gz
#tar -xf culfw-1.67.tar.gz
#cd culfw-1.67
svn checkout svn://svn.code.sf.net/p/culfw/code/trunk/
cd trunk
vim clib/rf_send.h
#-> #define MAX_CREDIT 3600
cd Devices/nanoCul
vim board.h
#-> comment out 433MHz
make
avrdude -D -p atmega328p -P /dev/serial/by-path/platform-3f980000.usb-usb-0:1.2:1.0-port0 -b 115200 -c arduino    -U flash:w:nanoCUL.hex
# a-culfw
wget https://www.nanocul.de/upload/a-culfw_nanoCUL433_1.26.06.zip
unzip a-culfw_nanoCUL433_1.26.06.zip
#git clone https://github.com/heliflieger/a-culfw
avrdude -D -p atmega328p -P /dev/serial/by-path/platform-3f980000.usb-usb-0:1.4:1.0-port0 -b 115200 -c arduino    -U flash:w:a-culfw-1.26.06-nanoCUL433.hex
# signalduino
wget https://github.com/RFD-FHEM/SIGNALDuino/releases/download/3.5.0/SIGNALDuino_nanocc1101_3.5.0.hex
avrdude -D -p atmega328p -P /dev/serial/by-path/platform-3f980000.usb-usb-0:1.4:1.0-port0 -b 115200 -c arduino    -U flash:w:SIGNALDuino_nanocc1101_3.5.0.hex
# write flash esp
python3 -m pip install esptool
python3 -m esptool --port /dev/tty.usbserial-14130 -b 115200 write_flash 0x00000 SIGNALDuino_ESP8266cc1101_3.5.0.hex
```
## HB Characteristics
```
Device AccessoryInformation 
// Required Characteristics
	        Identify
	        Manufacturer
	        Model
	        Name
	        SerialNumber
	        FirmwareRevision
// Optional Characteristics
	     HardwareRevision
	     AccessoryFlags

Device AirPurifier 
// Required Characteristics
	        Active
	        CurrentAirPurifierState
	        TargetAirPurifierState
// Optional Characteristics
	     LockPhysicalControls
	     Name
	     SwingMode
	     RotationSpeed

Device AirQualitySensor 
// Required Characteristics
	        AirQuality
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusTampered
	     StatusLowBattery
	     Name
	     OzoneDensity
	     NitrogenDioxideDensity
	     SulphurDioxideDensity
	     PM2_5Density
	     PM10Density
	     VOCDensity
	     CarbonMonoxideLevel
	     CarbonDioxideLevel

Device BatteryService 
// Required Characteristics
	        BatteryLevel
	        ChargingState
	        StatusLowBattery
// Optional Characteristics
	     Name

Device CameraRTPStreamManagement 
// Required Characteristics
	        SupportedVideoStreamConfiguration
	        SupportedAudioStreamConfiguration
	        SupportedRTPConfiguration
	        SelectedRTPStreamConfiguration
	        StreamingStatus
	        SetupEndpoints
// Optional Characteristics
	     Name

Device CarbonDioxideSensor 
// Required Characteristics
	        CarbonDioxideDetected
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusLowBattery
	     StatusTampered
	     CarbonDioxideLevel
	     CarbonDioxidePeakLevel
	     Name

Device CarbonMonoxideSensor 
// Required Characteristics
	        CarbonMonoxideDetected
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusLowBattery
	     StatusTampered
	     CarbonMonoxideLevel
	     CarbonMonoxidePeakLevel
	     Name

Device ContactSensor 
// Required Characteristics
	        ContactSensorState
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusTampered
	     StatusLowBattery
	     Name

Device Door 
// Required Characteristics
	        CurrentPosition
	        PositionState
	        TargetPosition
// Optional Characteristics
	     HoldPosition
	     ObstructionDetected
	     Name

Device Doorbell 
// Required Characteristics
	        ProgrammableSwitchEvent
// Optional Characteristics
	     Brightness
	     Volume
	     Name

Device Fan 
// Required Characteristics
	        On
// Optional Characteristics
	     RotationDirection
	     RotationSpeed
	     Name

Device Fanv2 
// Required Characteristics
	        Active
// Optional Characteristics
	     CurrentFanState
	     TargetFanState
	     LockPhysicalControls
	     Name
	     RotationDirection
	     RotationSpeed
	     SwingMode

Device FilterMaintenance 
// Required Characteristics
	        FilterChangeIndication
// Optional Characteristics
	     FilterLifeLevel
	     ResetFilterIndication
	     Name

Device Faucet 
// Required Characteristics
	        Active
// Optional Characteristics
	     Name
	     StatusFault

Device GarageDoorOpener 
// Required Characteristics
	        CurrentDoorState
	        TargetDoorState
	        ObstructionDetected
// Optional Characteristics
	     LockCurrentState
	     LockTargetState
	     Name

Device HeaterCooler 
// Required Characteristics
	        Active
	        CurrentHeaterCoolerState
	        TargetHeaterCoolerState
	        CurrentTemperature
// Optional Characteristics
	     LockPhysicalControls
	     Name
	     SwingMode
	     CoolingThresholdTemperature
	     HeatingThresholdTemperature
	     TemperatureDisplayUnits
	     RotationSpeed

Device HumidifierDehumidifier 
// Required Characteristics
	        CurrentRelativeHumidity
	        CurrentHumidifierDehumidifierState
	        TargetHumidifierDehumidifierState
	        Active
// Optional Characteristics
	     LockPhysicalControls
	     Name
	     SwingMode
	     WaterLevel
	     RelativeHumidityDehumidifierThreshold
	     RelativeHumidityHumidifierThreshold
	     RotationSpeed

Device HumiditySensor 
// Required Characteristics
	        CurrentRelativeHumidity
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusTampered
	     StatusLowBattery
	     Name

Device IrrigationSystem 
// Required Characteristics
	        Active
	        ProgramMode
	        InUse
// Optional Characteristics
	     Name
	     RemainingDuration
	     StatusFault

Device LeakSensor 
// Required Characteristics
	        LeakDetected
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusTampered
	     StatusLowBattery
	     Name

Device LightSensor 
// Required Characteristics
	        CurrentAmbientLightLevel
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusTampered
	     StatusLowBattery
	     Name

Device Lightbulb 
// Required Characteristics
	        On
// Optional Characteristics
	     Brightness
	     Hue
	     Saturation
	     Name
//Manual fix to add temperature

Device LockManagement 
// Required Characteristics
	        LockControlPoint
	        Version
// Optional Characteristics
	     Logs
	     AudioFeedback
	     LockManagementAutoSecurityTimeout
	     AdministratorOnlyAccess
	     LockLastKnownAction
	     CurrentDoorState
	     MotionDetected
	     Name

Device LockMechanism 
// Required Characteristics
	        LockCurrentState
	        LockTargetState
// Optional Characteristics
	     Name

Device Microphone 
// Required Characteristics
	        Mute
// Optional Characteristics
	     Volume
	     Name

Device MotionSensor 
// Required Characteristics
	        MotionDetected
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusTampered
	     StatusLowBattery
	     Name

Device OccupancySensor 
// Required Characteristics
	        OccupancyDetected
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusTampered
	     StatusLowBattery
	     Name

Device Outlet 
// Required Characteristics
	        On
	        OutletInUse
// Optional Characteristics
	     Name

Device SecuritySystem 
// Required Characteristics
	        SecuritySystemCurrentState
	        SecuritySystemTargetState
// Optional Characteristics
	     StatusFault
	     StatusTampered
	     SecuritySystemAlarmType
	     Name

Device ServiceLabel 
// Required Characteristics
	        ServiceLabelNamespace
// Optional Characteristics
	     Name

Device Slat 
// Required Characteristics
	        SlatType
	        CurrentSlatState
// Optional Characteristics
	     Name
	     CurrentTiltAngle
	     TargetTiltAngle
	     SwingMode

Device SmokeSensor 
// Required Characteristics
	        SmokeDetected
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusTampered
	     StatusLowBattery
	     Name

Device Speaker 
// Required Characteristics
	        Mute
// Optional Characteristics
	     Volume
	     Name

Device StatelessProgrammableSwitch 
// Required Characteristics
	        ProgrammableSwitchEvent
// Optional Characteristics
	     Name
	     ServiceLabelIndex

Device Switch 
// Required Characteristics
	        On
// Optional Characteristics
	     Name

Device TemperatureSensor 
// Required Characteristics
	        CurrentTemperature
// Optional Characteristics
	     StatusActive
	     StatusFault
	     StatusLowBattery
	     StatusTampered
	     Name

Device Thermostat 
// Required Characteristics
	        CurrentHeatingCoolingState
	        TargetHeatingCoolingState
	        CurrentTemperature
	        TargetTemperature
	        TemperatureDisplayUnits
// Optional Characteristics
	     CurrentRelativeHumidity
	     TargetRelativeHumidity
	     CoolingThresholdTemperature
	     HeatingThresholdTemperature
	     Name

Device Valve 
// Required Characteristics
	        Active
	        InUse
	        ValveType
// Optional Characteristics
	     SetDuration
	     RemainingDuration
	     IsConfigured
	     ServiceLabelIndex
	     StatusFault
	     Name

Device Window 
// Required Characteristics
	        CurrentPosition
	        TargetPosition
	        PositionState
// Optional Characteristics
	     HoldPosition
	     ObstructionDetected
	     Name

Device WindowCovering 
// Required Characteristics
	        CurrentPosition
	        TargetPosition
	        PositionState
// Optional Characteristics
	     HoldPosition
	     TargetHorizontalTiltAngle
	     TargetVerticalTiltAngle
	     CurrentHorizontalTiltAngle
	     CurrentVerticalTiltAngle
	     ObstructionDetected
	     Name
```
