Linux Simple I/O Library

libsimpleio is an attempt to encapsulate (as much as possible) the
ugliness of Linux I/O device access. It provides services for the
following types of I/O devices:

-   Industrial I/O Subsystem A/D (Analog to Digital) Converter Devices
-   Industrial I/O Subsystem D/A (Digital to Analog) Converter Devices
-   GPIO (General Purpose Input/Output) Pins
-   Raw HID (Human Interface Device) Devices
-   I²C (Inter-Integrated Circuit) Bus Devices
-   Labview LINX Remote I/O Devices
-   PWM (Pulse Width Modulated) Output Devices
-   Remote I/O Protocol Devices
-   Serial Ports
-   SPI (Serial Peripheral Interface) Bus Devices
-   Stream Framing Protocol Devices
-   TCP and UDP over IPv4 Network Devices
-   Watchdog Timer Devices

Although libsimpleio was originally intended for Linux microcomputers
such as the Raspberry Pi, it can also be useful on larger desktop Linux
systems.

The C wrapper functions exported by libsimpleio all follow the same
uniform pattern:

-   All C wrapper functions are proper procedures (void f() in C).
-   All input arguments of primitive types (int, float, etc.) are passed
    by value.
-   All output arguments of primitive types are passed by reference
    (int *, float *, etc.).
-   All composite types are passed by reference.
-   int32_t is used wherever possible for int and bool arguments.

All of the C wrapper functions are declared between _BEGIN_STD_C and
_END_STD_C for C++. Additional source code libraries are provided for
Ada, C++, C#, Free Pascal, Modula-2, and Python that define OOP (Object
Oriented Programming) thick binding classes for libsimpleio.

Documentation

The user manual for libsimpleio is available at UserManual.pdf.
Installation instructions are on pages 6 and 7.

The man pages specifying the libsimpleio API are available at
libsimpleio.html.

Git Repository

The libsimpleio source code tree is available at:

https://github.com/pmunts/libsimpleio

Use the following command to clone it:

git clone https://github.com/pmunts/libsimpleio.git

Debian Package Repository

Prebuilt libsimpleio packages for Debian Linux are available at:

http://repo.munts.com/debian11

Alire Crates

  ---- -----------------
  []   libsimpleio.pdf
  []   mcp2221.pdf
  []   remoteio.pdf
  ---- -----------------

Make With Ada Projects

2017 Ada Embedded Linux Framework
2019 Modbus RTU Framework for Ada (Prize Winner!)

NuGet Packages for .Net

libremoteio
libremoteio-templates
libsimpleio
libsimpleio-templates

------------------------------------------------------------------------

Questions or comments to Philip Munts phil@munts.net
