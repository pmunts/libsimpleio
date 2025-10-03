Linux Simple I/O Library

libsimpleio is an attempt to encapsulate (as much as possible) the
ugliness of Linux I/O device access. It provides services for the
following types of I/O devices:

-   Industrial I/O Subsystem A/D (Analog to Digital) Converter Devices
-   Industrial I/O Subsystem D/A (Digital to Analog) Converter Devices
-   GPIO (General Purpose Input/Output) Pins
-   Raw HID (Human Interface Device) Devices
-   I²C (Inter-Integrated Circuit) Bus Devices
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

The Ada library unit packages in the libsimpleio code tree are
especially rich and are both more numerous and more refined than those
for other programming languages. Ada was originally developed and
released in 1983 to replace a myriad of other programming languages used
for developing software for military aircraft and other complex weapons
systems. With the help of libsimpleio, Ada is still one of the best
languages around for developing reliable embedded systems software for
Linux computers.

See also MuntsOS Embedded Linux, which uses libsimpleio pervasively.

Documentation at https://repo.munts.com/libsimpleio/doc

User Manual:

https://repo.munts.com/libsimpleio/doc/UserManual.pdf

C Wrapper Functions API Specification:

https://repo.munts.com/libsimpleio/doc/libsimpleio.html

.Net Binding API Specifications:

https://repo.munts.com/libsimpleio/doc/libremoteio.dll
https://repo.munts.com/libsimpleio/doc/libsimpleio.dll

Git Repository

The libsimpleio source code tree is available at:

https://github.com/pmunts/libsimpleio

Use the following command to clone it:

git clone https://github.com/pmunts/libsimpleio.git

Debian Package Repository

Prebuilt libsimpleio packages for Debian Linux are available at:

https://repo.munts.com/debian12

Alire Crates

[libsimpleio] [mcp2221] [remoteio]
[wioe5_ham1] [wioe5_ham2] [wioe5_p2p]

Ada programs using the libsimpleio crate run only on Linux target
computers.

Ada programs using the mcp2221 crate can run on Linux, macOS, or Windows
target computers, enabling you to control I/O resources on a USB
tethered MCP2221A USB 2.0 to I²C/UART Protocol Converter with GPIO,
perhaps using a module like the Adafruit MCP2221A Breakout.

Ada programs using the remoteio crate can run on Linux, macOS, or
Windows target computers, enabling you to control GPIO resources on a
USB tethered or networked Remote I/O Protocol server.

NuGet Packages for .Net

[libremoteio] [libremoteio-templates]
[libsimpleio] [libsimpleio-templates]

Use one of the following command sequences to create a .Net program
project:

dotnet new install libremoteio-templates
mkdir myprogram
cd myprogram
dotnet new csharp_console_libremoteio
dotnet new sln
dotnet sln add myprogram.csproj

Or

dotnet new install libsimpleio-templates
mkdir myprogram
cd myprogram
dotnet new csharp_console_libsimpleio
dotnet new sln
dotnet sln add myprogram.csproj

------------------------------------------------------------------------

Questions or comments to Philip Munts phil@munts.net
