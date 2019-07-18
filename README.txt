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
     * Serial Ports
     * SPI (Serial Peripheral Interface) Bus Devices
     * [4]Stream Framing Protocol Devices
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

News

     * 9 January 2019 -- Continued working on the Ada Remote I/O code.
       Continued working on the Pascal Remote I/O code. Compiling Pascal
       Remote I/O client programs on Windows is now supported.
     * 16 January 2019 -- The C wrapper function source files have been
       moved to the c/ subdirectory. The source code is now published on
       [5]GitHub at [6]https://github.com/pmunts/libsimpleio. The old
       repository at [7]http://git.munts.com (which actually just mirrors
       a private Subversion repository and then pushed to GitHub) will be
       maintained, but you should clone from GitHub, which will be much
       faster.
     * 8 February 2019 -- Reworked PWM device handling for the Linux 4.19
       kernel. Cleaned up some stale links and commands in the user
       manual. Cleaned up some loose ends in the [8]MY-BASIC bindings and
       example programs.
     * 12 March 2019 -- The Debian native packages now depend on
       libhidapi-dev, for Remote I/O over USB raw HID.
     * 10 June 2019 -- Material from the Controlling I/O Devices with Ada
       using the Remote I/O Protocol educational tutorial at the
       [9]Ada-Europe 2019 conference is available at
       [10]http://git.munts.com/ada-remoteio-tutorial.
     * 18 July 2019 -- Packages for Debian 10 (Buster) are now available
       [11]http://repo.munts.com/debian10.

Documentation

   The user manual for libsimpleio is available at
   [12]http://git.munts.com/libsimpleio/doc/UserManual.pdf

   The man pages specifying the libsimpleio API are available at
   [13]libsimpleio.html

Git Repository

   The source code is available at:

   [14]https://github.com/pmunts/libsimpleio

   Use the following command to clone it:

   git clone https://github.com/pmunts/libsimpleio.git

Package Repository

   Prebuilt packages for Debian are available at:

   [15]http://repo.munts.com/debian9 and
   [16]http://repo.munts.com/debian10.
   _______________________________________________________________________

   Questions or comments to Philip Munts [17]phil@munts.net

   I am available for custom system development (hardware and software) of
   products using ARM Linux or other microcomputers.

References

   1. https://wiki.analog.com/software/linux/docs/iio/iio
   2. https://wiki.analog.com/software/linux/docs/iio/iio
   3. https://www.labviewmakerhub.com/doku.php?id=learn:libraries:linx:spec:start
   4. http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf
   5. https://github.com/
   6. https://github.com/pmunts/libsimpleio
   7. http://git.munts.com/
   8. https://github.com/paladin-t/my_basic
   9. https://ae2019.edc.pl/
  10. http://git.munts.com/ada-remoteio-tutorial
  11. http://repo.munts.com/debian10
  12. http://git.munts.com/libsimpleio/doc/UserManual.pdf
  13. http://git.munts.com/libsimpleio/doc/libsimpleio.html
  14. https://github.com/pmunts/libsimpleio
  15. http://repo.munts.com/debian9
  16. http://repo.munts.com/debian10
  17. mailto:phil@munts.net
