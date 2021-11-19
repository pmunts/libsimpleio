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
   [8][mcp2221.json]     [9]mcp2221.pdf
   [10][remoteio.json]   [11]remoteio.pdf

Quick Setup Instructions for the Impatient

   Instructions for installing libsimpleio are found in
   [12]UserManual.pdf, on pages 5 and 6.

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
       the [13]Remote I/O Protocol for raw HID servers (like [14]this or
       [15]this), in response to a request from a customer who wants to
       develop a Python Remote I/O Protocol client program that can run on
       Windows 10 64-bit. Accomplishing this requires a new Windows shared
       library libremoteio.dll, which was written in the Ada programming
       language. It also contains the latest [16]hidapi code. Precompiled
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
     * 20 August 2021 -- An [17]Alire library crate for libsimpleio has
       been [18]published. Some more library crates for the [19]Remote I/O
       Protocol and the [20]MCP2221 USB I/O Expander are also forthcoming.
     * 21 August 2021 -- Added experimental support for cross-compiling
       libsimpleio programs with cross-toolchains from the Debian package
       repository. You can cross-compile Ada, C++, and Go (and on Debian
       11 Modula-2) programs, with certain limitations: No support for
       [21]AWS, [22]hidapi, or [23]libusb. Just set the CROSS_COMPILE
       environment variable to select a cross-toolchain instead of a
       native compile:

       cd libsimpleio/ada/programs
       export CROSS_COMPILE=aarch64-linux-gnu-
       make test_hello

       Select cross-compiled libsimpleio packages have been added to the
       Munts Technologies Debian Package Repositories for [24]Debian 10
       (Buster) and [25]Debian 11 (Bullseye).
     * 3 September 2021 -- The Alire crates [26]mcp2221 and [27]remoteio
       have now been published.
     * 18 November 2021 -- Updated C# projects and templates for .Net 6.

Documentation

   The user manual for libsimpleio is available at [28]UserManual.pdf.

   The man pages specifying the libsimpleio API are available at
   [29]libsimpleio.html.

Git Repository

   The source code is available at:

   [30]https://github.com/pmunts/libsimpleio

   Use the following command to clone it:

   git clone https://github.com/pmunts/libsimpleio.git

Package Repository

   Prebuilt packages for [31]Debian Linux are available at:

   [32]http://repo.munts.com/debian10

   [33]http://repo.munts.com/debian11

[34]Make With Ada Projects

     * 2017 [35]Ada Embedded Linux Framework
     * 2019 [36]Modbus RTU Framework for Ada (Prize Winner!)
   _______________________________________________________________________

   Questions or comments to Philip Munts [37]phil@munts.net

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
   8. https://alire.ada.dev/crates/mcp2221.html
   9. http://repo.munts.com/alire/mcp2221.pdf
  10. https://alire.ada.dev/crates/remoteio.html
  11. http://repo.munts.com/alire/remoteio.pdf
  12. http://git.munts.com/libsimpleio/doc/UserManual.pdf
  13. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
  14. https://www.tindie.com/products/pmunts/usb-flexible-io-adapter
  15. https://www.tindie.com/products/pmunts/usb-grove-adapter
  16. https://github.com/libusb/hidapi
  17. https://alire.ada.dev/
  18. https://alire.ada.dev/crates/libsimpleio.html
  19. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
  20. https://www.microchip.com/en-us/product/MCP2221A
  21. https://docs.adacore.com/aws-docs/aws/
  22. https://github.com/libusb/hidapi
  23. https://github.com/libusb/libusb
  24. http://repo.munts.com/debian10
  25. http://repo.munts.com/debian11
  26. https://alire.ada.dev/crates/mcp2221.html
  27. https://alire.ada.dev/crates/remoteio.html
  28. http://git.munts.com/libsimpleio/doc/UserManual.pdf
  29. http://git.munts.com/libsimpleio/doc/libsimpleio.html
  30. https://github.com/pmunts/libsimpleio
  31. http://www.debian.org/
  32. http://repo.munts.com/debian10
  33. http://repo.munts.com/debian11
  34. https://www.makewithada.org/
  35. https://www.makewithada.org/entry/ada_linux_sensor_framework
  36. https://www.hackster.io/philip-munts/modbus-rtu-framework-for-ada-f33cc6
  37. mailto:phil@munts.net
