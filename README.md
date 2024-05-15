Linux Simple I/O Library
========================

**libsimpleio** is an attempt to encapsulate (as much as possible) the
ugliness of Linux I/O device access. It provides services for the
following types of I/O devices:

-   [Industrial I/O
    Subsystem](https://wiki.analog.com/software/linux/docs/iio/iio) A/D
    (Analog to Digital) Converter Devices
-   [Industrial I/O
    Subsystem](https://wiki.analog.com/software/linux/docs/iio/iio) D/A
    (Digital to Analog) Converter Devices
-   GPIO (General Purpose Input/Output) Pins
-   Raw HID (Human Interface Device) Devices
-   I<sup>2</sup>C (Inter-Integrated Circuit) Bus Devices
-   [Labview LINX Remote
    I/O](https://www.labviewmakerhub.com/doku.php?id=learn:libraries:linx:spec:start)
    Devices
-   PWM (Pulse Width Modulated) Output Devices
-   [Remote I/O
    Protocol](http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf)
    Devices
-   Serial Ports
-   SPI (Serial Peripheral Interface) Bus Devices
-   [Stream Framing
    Protocol](http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf)
    Devices
-   TCP and UDP over IPv4 Network Devices
-   Watchdog Timer Devices

Although **libsimpleio** was originally intended for Linux
microcomputers such as the Raspberry Pi, it can also be useful on larger
desktop Linux systems.

The C wrapper functions exported by **libsimpleio** all follow the same
uniform pattern:

-   All C wrapper functions are proper procedures (**`void f()`** in C).
-   All input arguments of primitive types (**`int`**, **`float`**,
    etc.) are passed by value.
-   All output arguments of primitive types are passed by reference
    (**`int *`**, **`float *`**, etc.).
-   All composite types are passed by reference.
-   **`int32_t`** is used wherever possible for **`int`** and **`bool`**
    arguments.

All of the C wrapper functions are declared between **`_BEGIN_STD_C`**
and **`_END_STD_C`** for C++. Additional source code libraries are
provided for Ada, C++, C\#, Free Pascal, Modula-2, and Python that
define OOP (Object Oriented Programming) thick binding classes for
**libsimpleio**.

Documentation
-------------

The user manual for **libsimpleio** is available at
[UserManual.pdf](http://git.munts.com/libsimpleio/doc/UserManual.pdf).
Installation instructions are on pages 6 and 7.

The man pages specifying the **libsimpleio** API are available at
[libsimpleio.html](http://git.munts.com/libsimpleio/doc/libsimpleio.html).

Git Repository
--------------

The **libsimpleio** source code tree is available at:

<https://github.com/pmunts/libsimpleio>

Use the following command to clone it:

**`git clone https://github.com/pmunts/libsimpleio.git`**

Debian Package Repository
-------------------------

Prebuilt **`libsimpleio`** packages for [Debian](http://www.debian.org)
Linux are available at:

<http://repo.munts.com/debian11>

[Alire](https://alire.ada.dev) Crates
-------------------------------------

[![](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/libsimpleio.json)](https://alire.ada.dev/crates/libsimpleio.html)
[![](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/mcp2221.json)](https://alire.ada.dev/crates/mcp2221.html)
[![](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/remoteio.json)](https://alire.ada.dev/crates/remoteio.html)

The Munts Technologies Alire crate index fork is available at:

<https://github.com/pmunts/alire-index.git>

Use the following command to reference it:

**`alr index --add git+https://github.com/pmunts/alire-index.git --name pmunts --before community`**

[NuGet](https://nuget.org/) Packages for [.Net](https://dotnet.microsoft.com)
-----------------------------------------------------------------------------

[libremoteio](https://www.nuget.org/packages/libremoteio)  
[libremoteio-templates](https://www.nuget.org/packages/libremoteio-templates)  
[libsimpleio](https://www.nuget.org/packages/libsimpleio)  
[libsimpleio-templates](https://www.nuget.org/packages/libsimpleio-templates)

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>
