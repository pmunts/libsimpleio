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
       at [11]http://repo.munts.com/debian10.
     * 5 August 2019 -- Started adding .Net Core example programs using
       [12]RemObjects Elements.
     * 8 January 2020 -- Added LINUX_errno(). Added [13]libmodbus bindings
       and objects for Ada.
     * 31 January 2020 -- Added .gpr project files to
       ada/programs/libsimpleio/, ada/programs/libsimpleio/mcp2221/, and
       ada/programs/libsimpleio/remoteio to allow building native programs
       with just gprbuild, using a command like:

       gprbuild libsimpleio.gpr -p test_userled

       Reworked Ada make files to allow building Windows applications in
       [14]Windows Subsystem for Linux. Until now, using the make files on
       Windows required using [15]Cygwin.
     * 1 February 2020 -- Added links to [16]Make With Ada projects.
     * 2 February 2020 -- Flattened the csharp/ directory tree. Removed
       separate Mono program directories. Now you can build a Mono program
       in one of the unified .Net project directories using a command
       like:

       make test_gpio.exe

     * 7 February 2020 -- Added .Net Core 3.1 project templates for both
       lisimpleio and libremoteio. Install these from [17]NuGet with the
       following commands:

       dotnet new -i libsimpleio-templates
       dotnet new -i libremoteio-templates

Documentation

   The user manual for libsimpleio is available at
   [18]http://git.munts.com/libsimpleio/doc/UserManual.pdf

   The man pages specifying the libsimpleio API are available at
   [19]libsimpleio.html

Git Repository

   The source code is available at:

   [20]https://github.com/pmunts/libsimpleio

   Use the following command to clone it:

   git clone https://github.com/pmunts/libsimpleio.git

Package Repository

   Prebuilt packages for [21]Debian Linux are available at:
   [22]http://repo.munts.com/debian10

[23]Make With Ada Projects

     * 2017 [24]Ada Embedded Linux Framework
     * 2019 [25]Modbus RTU Framework for Ada
   _______________________________________________________________________

   Questions or comments to Philip Munts [26]phil@munts.net

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
  12. https://www.elementscompiler.com/elements/
  13. https://libmodbus.org/
  14. https://docs.microsoft.com/en-us/windows/wsl/faq
  15. https://www.cygwin.com/
  16. https://www.makewithada.org/
  17. https://www.nuget.org/
  18. http://git.munts.com/libsimpleio/doc/UserManual.pdf
  19. http://git.munts.com/libsimpleio/doc/libsimpleio.html
  20. https://github.com/pmunts/libsimpleio
  21. http://www.debian.org/
  22. http://repo.munts.com/debian10
  23. https://www.makewithada.org/
  24. https://www.makewithada.org/entry/ada_linux_sensor_framework
  25. https://www.hackster.io/philip-munts/modbus-rtu-framework-for-ada-f33cc6
  26. mailto:phil@munts.net
