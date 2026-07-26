#! /bin/python3

import munts.remoteio.common
import munts.remoteio.zeromq

print("")
print("Remote I/O Device Information Query")
print("")

srv = munts.remoteio.zeromq.Server("usbgadget.munts.net", 8088)

print("Server Info:  " + srv.version)
print("Capabilities: " + srv.capability)
print("")

if srv.ADC_Channels != set():
    print("ADC Inputs:       ", end="")
    print(srv.ADC_Channels)

if srv.DAC_Channels != set():
    print("DAC Outputs:      ", end="")
    print(srv.DAC_Channels)

if srv.GPIO_Channels != set():
    print("GPIO Pins:        ", end="")
    print(srv.GPIO_Channels)

if srv.I2C_Channels != set():
    print("I2C Buses:        ", end="")
    print(srv.I2C_Channels)

if srv.PWM_Channels != set():
    print("PWM Outputs:      ", end="")
    print(srv.PWM_Channels)

if srv.SPI_Channels != set():
    print("SPI Slaves:       ", end="")
    print(srv.SPI_Channels)

if srv.DEVICE_Channels != set():
    print("Abstract Devices: ", end="")
    print(srv.DEVICE_Channels)
