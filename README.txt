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
   _END_STD_C for C++. Binding modules are provided for Ada, C#, and Free
   Pascal. Additional source code libraries are provided for Ada, C++, C#,
   and Free Pascal that define OOP (Object Oriented Programming) classes
   for libsimpleio.

Documentation

   The user manual for libsimpleio is available at [6]UserManual.pdf.
   Installation instructions are on pages 6 and 7.

   The man pages specifying the libsimpleio API are available at
   [7]libsimpleio.html.

Git Repository

   The libsimpleio source code tree is available at:

   [8]https://github.com/pmunts/libsimpleio

   Use the following command to clone it:

   git clone https://github.com/pmunts/libsimpleio.git

Debian Package Repository

   Prebuilt libsimpleio packages for [9]Debian Linux are available at:

   [10]http://repo.munts.com/debian11

[11]Alire Crates

   [12][libsimpleio.json] [13]libsimpleio.pdf
   [14][mcp2221.json]     [15]mcp2221.pdf
   [16][remoteio.json]    [17]remoteio.pdf

[18]Make With Ada Projects

   2017 [19]Ada Embedded Linux Framework
   2019 [20]Modbus RTU Framework for Ada (Prize Winner!)

[21]NuGet Packages for [22].Net

   [23]libremoteio
   [24]libremoteio-templates
   [25]libsimpleio
   [26]libsimpleio-templates
   _______________________________________________________________________

   Questions or comments to Philip Munts [27]phil@munts.net

References

   1. https://wiki.analog.com/software/linux/docs/iio/iio
   2. https://wiki.analog.com/software/linux/docs/iio/iio
   3. https://www.labviewmakerhub.com/doku.php?id=learn:libraries:linx:spec:start
   4. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
   5. http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf
   6. http://git.munts.com/libsimpleio/doc/UserManual.pdf
   7. http://git.munts.com/libsimpleio/doc/libsimpleio.html
   8. https://github.com/pmunts/libsimpleio
   9. http://www.debian.org/
  10. http://repo.munts.com/debian11
  11. https://alire.ada.dev/
  12. https://alire.ada.dev/crates/libsimpleio.html
  13. http://repo.munts.com/alire/libsimpleio.pdf
  14. https://alire.ada.dev/crates/mcp2221.html
  15. http://repo.munts.com/alire/mcp2221.pdf
  16. https://alire.ada.dev/crates/remoteio.html
  17. http://repo.munts.com/alire/remoteio.pdf
  18. https://www.makewithada.org/
  19. https://www.makewithada.org/entry/ada_linux_sensor_framework
  20. https://www.hackster.io/philip-munts/modbus-rtu-framework-for-ada-f33cc6
  21. https://nuget.org/
  22. https://dotnet.microsoft.com/
  23. https://www.nuget.org/packages/libremoteio
  24. https://www.nuget.org/packages/libremoteio-templates
  25. https://www.nuget.org/packages/libsimpleio
  26. https://www.nuget.org/packages/libsimpleio-templates
  27. mailto:phil@munts.net
