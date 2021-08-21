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

Alire Crates

   [6][libsimpleio.json] [7]libsimpleio.pdf

Quick Setup Instructions for the Impatient

   Instructions for installing libsimpleio are found in [8]UserManual.pdf,
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

       sudo apt install --reinstall gcc-aarch64-linux-gnu-muntsos-crosstool-libsimpleio
       sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-beaglebone-crosstool-libsimpleio
       sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-raspberrypi1-crosstool-libsimpleio
       sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-raspberrypi2-crosstool-libsimpleio

     * 25 March 2021 -- Added some rudimentary Python client support for
       the [9]Remote I/O Protocol for raw HID servers (like [10]this or
       [11]this), in response to a request from a customer who wants to
       develop a Python Remote I/O Protocol client program that can run on
       Windows 10 64-bit. Accomplishing this requires a new Windows shared
       library libremoteio.dll, which was written in the Ada programming
       language. It also contains the latest [12]hidapi code. Precompiled
       library files have been added to win/win64/. A few "proof of
       concept" Python3 programs are in python/.
     * 29 March 2021 -- The new libremoteio.dll also works with Visual
       Studio C++ programs. Added some Visual Studio C++ projects for
       creating Remote I/O Protocol client programs for 64-Bit Windows 10.
     * 20 April 2021 -- Added support to SERIAL_open() for more baud rates
       above 1000000 bps. Fixed issue with raw mode on Raspberry Pi serial
       ports.
     * 18 May 2021 -- Added support for stepper motors to Ada and .Net.
       Renamed basic/ to mybasic/, modula2/ to gm2/, and pascal/ to
       freepascal/.
     * 25 July 2021 -- Prebuild an Ada library project for the Linux
       Simple I/O Library Ada binding.
     * 20 August 2021 -- An [13]Alire library crate for libsimpleio has
       been [14]published. Some more library crates for the [15]Remote I/O
       Protocol and the [16]MCP2221 USB I/O Expander are also forthcoming.
     * 21 August 2021 -- Added experimental support for cross-compiling
       libsimpleio programs with cross-toolchains from the Debian package
       repository. You can cross-compile Ada, C++, and Go (and on Debian
       11 Modula-2) programs, with certain limitations: No support for
       [17]AWS, [18]hidapi, or [19]libusb. Just set the CROSS_COMPILE
       environment variable to select a cross-toolchain instead of a
       native compile:

       cd libsimpleio/ada/programs
       export CROSS_COMPILE=aarch64-linux-gnu-
       make test_hello

       Select cross-compiled libsimpleio packages have been added to the
       Munts Technologies Debian Package Repositories for [20]Debian 10
       (Buster) and [21]Debian 11 (Bullseye).

Documentation

   The user manual for libsimpleio is available at [22]UserManual.pdf.

   The man pages specifying the libsimpleio API are available at
   [23]libsimpleio.html.

Git Repository

   The source code is available at:

   [24]https://github.com/pmunts/libsimpleio

   Use the following command to clone it:

   git clone https://github.com/pmunts/libsimpleio.git

Package Repository

   Prebuilt packages for [25]Debian Linux are available at:

   [26]http://repo.munts.com/debian10

   [27]http://repo.munts.com/debian11

[28]Make With Ada Projects

     * 2017 [29]Ada Embedded Linux Framework
     * 2019 [30]Modbus RTU Framework for Ada (Prize Winner!)
   _______________________________________________________________________

   Questions or comments to Philip Munts [31]phil@munts.net

   I am available for custom system development (hardware and software) of
   products using ARM Linux or other microcomputers.

References

   1. https://wiki.analog.com/software/linux/docs/iio/iio
   2. https://wiki.analog.com/software/linux/docs/iio/iio
   3. https://www.labviewmakerhub.com/doku.php?id=learn:libraries:linx:spec:start
   4. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
   5. http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf
   6. https://alire.ada.dev/crates/libsimpleio.html
   7. http://repo.munts.com/alire/libsimpleio.pdf
   8. http://git.munts.com/libsimpleio/doc/UserManual.pdf
   9. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
  10. https://www.tindie.com/products/pmunts/usb-flexible-io-adapter
  11. https://www.tindie.com/products/pmunts/usb-grove-adapter
  12. https://github.com/libusb/hidapi
  13. https://alire.ada.dev/
  14. https://alire.ada.dev/crates/libsimpleio.html
  15. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
  16. https://www.microchip.com/en-us/product/MCP2221A
  17. https://docs.adacore.com/aws-docs/aws/
  18. https://github.com/libusb/hidapi
  19. https://github.com/libusb/libusb
  20. http://repo.munts.com/debian10
  21. http://repo.munts.com/debian11
  22. http://git.munts.com/libsimpleio/doc/UserManual.pdf
  23. http://git.munts.com/libsimpleio/doc/libsimpleio.html
  24. https://github.com/pmunts/libsimpleio
  25. http://www.debian.org/
  26. http://repo.munts.com/debian10
  27. http://repo.munts.com/debian11
  28. https://www.makewithada.org/
  29. https://www.makewithada.org/entry/ada_linux_sensor_framework
  30. https://www.hackster.io/philip-munts/modbus-rtu-framework-for-ada-f33cc6
  31. mailto:phil@munts.net
