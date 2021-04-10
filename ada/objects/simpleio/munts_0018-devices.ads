-- Define I/O device objects for the Raspberry Pi Tutorial I/O Board MUNTS-0018

WITH ADC.libsimpleio;
WITH GPIO.libsimpleio;
WITH I2C.libsimpleio;
WITH MCP3204;
WITH PWM.libsimpleio;
WITH Servo.PWM;
WITH Voltage;

PACKAGE MUNTS_0018.Devices IS

  AnalogInputs : CONSTANT ARRAY (0 .. 3) OF Voltage.Input :=
   (ADC.Create(ADC.libsimpleio.Create(MUNTS_0018.J10A0, MCP3204.Resolution), 3.3),
    ADC.Create(ADC.libsimpleio.Create(MUNTS_0018.J10A1, MCP3204.Resolution), 3.3),
    ADC.Create(ADC.libsimpleio.Create(MUNTS_0018.J11A0, MCP3204.Resolution), 3.3),
    ADC.Create(ADC.libsimpleio.Create(MUNTS_0018.J11A1, MCP3204.Resolution), 3.3));

  Button : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(MUNTS_0018.Button, GPIO.Input);

  LED    : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(MUNTS_0018.LED, GPIO.Output);

  I2C1   : CONSTANT I2C.Bus := I2C.libsimpleio.Create(MUNTS_0018.J9I2C);

  Servos : CONSTANT ARRAY (0 .. 1) OF Servo.Output :=
   (Servo.PWM.Create(PWM.libsimpleio.Create(MUNTS_0018.J2PWM, 50)),
    Servo.PWM.Create(PWM.libsimpleio.Create(MUNTS_0018.J3PWM, 50)));

END MUNTS_0018.Devices;