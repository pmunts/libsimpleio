                            Linux Simple I/O Library

   libsimpleio is an attempt to encapsulate (as much as possible) the
   ugliness of Linux I/O device access. It provides services for the
   following types of I/O devices:

     * [1]Industrial I/O Subsystem A/D (Analog to Digital) Converter
       Devices
     * [2]Industrial I/O Subsystem D/A (Digital to Analog) Converter
       Devices
     * GPIO (General Purpose Input/Output) Pins
     * Raw HID (Human Interface Device) Devices
     * I2C (Inter-Integrated Circuit) Bus Devices
     * [3]Labview LINX Remote I/O Devices
     * PWM (Pulse Width Modulated) Output Devices
     * [4]Remote I/O Protocol Devices
     * Serial Ports
     * SPI (Serial Peripheral Interface) Bus Devices
     * [5]Stream Framing Protocol Devices
     * TCP and UDP over IPv4 Network Devices
     * Watchdog Timer Devices

   Although libsimpleio was originally intended for Linux microcomputers
   such as the Raspberry Pi, it can also be useful on larger desktop Linux
   systems.

   The C wrapper functions exported by libsimpleio all follow the same
   uniform pattern:

     * All C wrapper functions are proper procedures (void f() in C).
     * All input arguments of primitive types (int, float, etc.) are
       passed by value.
     * All output arguments of primitive types are passed by reference
       (int *, float *, etc.).
     * All composite types are passed by reference.
     * int32_t is used wherever possible for int and bool arguments.

   All of the C wrapper functions are declared between _BEGIN_STD_C and
   _END_STD_C for C++. Binding modules are provided for Ada, C#, Java, and
   Free Pascal. Additional source code libraries are provided for Ada,
   C++, C#, Java, and Free Pascal that define OOP (Object Oriented
   Programming) classes for libsimpleio.

Quick Setup Instructions for the Impatient

   Instructions for installing libsimpleio are found in [6]UserManual.pdf,
   on pages 5 and 6.

News

     * 10 February 2021 -- Added support for GPIO output pins implemented
       using PWM outputs. This is useful for controlling an ON/OFF device
       such as an LED or solenoid valve driven by PWM output.
     * 18 March 2021 -- Modified the package building procedure to only
       install the absolute minimum files for the MuntsOS cross-compiled
       packages. An issue with dpkg installation script execution order
       may require you to run the following commands after upgrading to
       this version of libsimpleio:

       sudo find /usr/local -name '*-tmp' -exec rm {} ";"
       sudo apt install --reinstall munts-libsimpleio

       If you have previously installed the MuntsOS cross-compiled
       packages, you will also need to run one or more of the following
       commands:

       sudo apt install --reinstall gcc-aarch64-linux-gnu-muntsos-crosstool
       sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-BeagleBone-crosstool
       sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-RaspberryPi1-crosstool
       sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-RaspberryPi2-crosstool

Documentation

   The user manual for libsimpleio is available at [7]UserManual.pdf.

   The man pages specifying the libsimpleio API are available at
   [8]libsimpleio.html.

Git Repository

   The source code is available at:

   [9]https://github.com/pmunts/libsimpleio

   Use the following command to clone it:

   git clone https://github.com/pmunts/libsimpleio.git

Package Repository

   Prebuilt packages for [10]Debian Linux are available at:
   [11]http://repo.munts.com/debian10

[12]Make With Ada Projects

     * 2017 [13]Ada Embedded Linux Framework
     * 2019 [14]Modbus RTU Framework for Ada (Prize Winner!)
   _______________________________________________________________________

   Questions or comments to Philip Munts [15]phil@munts.net

   I am available for custom system development (hardware and software) of
   products using ARM Linux or other microcomputers.

References

   1. https://wiki.analog.com/software/linux/docs/iio/iio
   2. https://wiki.analog.com/software/linux/docs/iio/iio
   3. https://www.labviewmakerhub.com/doku.php?id=learn:libraries:linx:spec:start
   4. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
   5. http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf
   6. http://git.munts.com/libsimpleio/doc/UserManual.pdf
   7. http://git.munts.com/libsimpleio/doc/UserManual.pdf
   8. http://git.munts.com/libsimpleio/doc/libsimpleio.html
   9. https://github.com/pmunts/libsimpleio
  10. http://www.debian.org/
  11. http://repo.munts.com/debian10
  12. https://www.makewithada.org/
  13. https://www.makewithada.org/entry/ada_linux_sensor_framework
  14. https://www.hackster.io/philip-munts/modbus-rtu-framework-for-ada-f33cc6
  15. mailto:phil@munts.net
