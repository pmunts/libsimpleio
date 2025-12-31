# Linux Simple I/O Library

**libsimpleio** is an attempt to encapsulate (as much as possible) the
ugliness of Linux I/O device access. It provides services for the
following types of I/O devices:

- [Industrial I/O
  Subsystem](https://wiki.analog.com/software/linux/docs/iio/iio) A/D
  (Analog to Digital) Converter Devices
- [Industrial I/O
  Subsystem](https://wiki.analog.com/software/linux/docs/iio/iio) D/A
  (Digital to Analog) Converter Devices
- GPIO (General Purpose Input/Output) Pins
- Raw HID (Human Interface Device) Devices
- I<sup>2</sup>C (Inter-Integrated Circuit) Bus Devices
- PWM (Pulse Width Modulated) Output Devices
- [Remote I/O
  Protocol](https://repo.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf)
  Devices
- Serial Ports
- SPI (Serial Peripheral Interface) Bus Devices
- [Stream Framing
  Protocol](https://repo.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf)
  Devices
- TCP and UDP over IPv4 Network Devices
- Watchdog Timer Devices

Although **libsimpleio** was originally intended for Linux
microcomputers such as the Raspberry Pi, it can also be useful on larger
desktop Linux systems.

The C wrapper functions exported by **libsimpleio** all follow the same
uniform pattern:

- All C wrapper functions are proper procedures (**`void f()`** in C).
- All input arguments of primitive types (**`int`**, **`float`**, etc.)
  are passed by value.
- All output arguments of primitive types are passed by reference
  (**`int *`**, **`float *`**, etc.).
- All composite types are passed by reference.
- **`int32_t`** is used wherever possible for **`int`** and **`bool`**
  arguments.

All of the C wrapper functions are declared between **`_BEGIN_STD_C`**
and **`_END_STD_C`** for C++. Additional source code libraries are
provided for Ada, C++, C#, Free Pascal, Modula-2, and Python that define
OOP (Object Oriented Programming) thick binding classes for
**libsimpleio**.

The Ada library unit packages in the **libsimpleio** code tree are
especially rich and are both more numerous and more refined than those
for other programming languages. Ada was originally developed and
released in 1983 to replace a myriad of other programming languages used
for developing software for military aircraft and other complex weapons
systems. With the help of **libsimpleio**, Ada is still one of the best
languages around for developing reliable embedded systems software for
Linux computers.

See also [MuntsOS Embedded Linux](https://github.com/pmunts/muntsos),
which uses **libsimpleio** pervasively.

## Documentation at <https://repo.munts.com/libsimpleio/doc>

### User Manual:

<https://repo.munts.com/libsimpleio/doc/UserManual.pdf>

### C Wrapper Functions API Specification:

<https://repo.munts.com/libsimpleio/doc/libsimpleio.html>

### .Net Binding API Specifications:

<https://repo.munts.com/libsimpleio/doc/libremoteio.dll>  
<https://repo.munts.com/libsimpleio/doc/libsimpleio.dll>

## Git Repository

The **libsimpleio** source code tree is available at:

<https://github.com/pmunts/libsimpleio>

Use the following command to clone it:

**`git clone https://github.com/pmunts/libsimpleio.git`**

## Debian Package Repository

Prebuilt **`libsimpleio`** packages for [Debian](http://www.debian.org)
Linux are available at:

<https://repo.munts.com/debian13>

## [Alire](https://alire.ada.dev) Crates

[![libsimpleio](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/libsimpleio.json)](https://alire.ada.dev/crates/libsimpleio.html)
[![mcp2221](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/mcp2221.json)](https://alire.ada.dev/crates/mcp2221.html)
[![remoteio](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/remoteio.json)](https://alire.ada.dev/crates/remoteio.html)  
[![wioe5_ham1](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/wioe5_ham1.json)](https://alire.ada.dev/crates/wioe5_ham1)
[![wioe5_ham2](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/wioe5_ham2.json)](https://alire.ada.dev/crates/wioe5_ham2.html)
[![wioe5_p2p](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/wioe5_p2p.json)](https://alire.ada.dev/crates/wioe5_p2p.html)

Ada programs using the **`libsimpleio`** crate run only on Linux target
computers.

Ada programs using the **`mcp2221`** crate can run on Linux, macOS, or
Windows target computers, enabling you to control I/O resources on a USB
tethered [MCP2221A USB 2.0 to I<sup>2</sup>C/UART Protocol Converter
with GPIO](https://www.microchip.com/en-us/product/MCP2221A), perhaps
using a module like the [Adafruit MCP2221A
Breakout](https://www.adafruit.com/product/4471).

Ada programs using the **`remoteio`** crate can run on Linux, macOS, or
Windows target computers, enabling you to control GPIO resources on a
USB tethered or networked [Remote I/O
Protocol](https://repo.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf)
server.

## [NuGet](https://nuget.org/) Packages for [.Net](https://dotnet.microsoft.com)

[![libremoteio](https://img.shields.io/nuget/v/libremoteio?style=flat&logo=nuget&label=libremoteio)](https://www.nuget.org/packages/libremoteio)
[![libremoteio-templates](https://img.shields.io/nuget/v/libremoteio-templates?style=flat&logo=nuget&label=libremoteio-templates)](https://www.nuget.org/packages/libremoteio-templates)  
[![libsimpleio](https://img.shields.io/nuget/v/libsimpleio?style=flat&logo=nuget&label=libsimpleio)](https://www.nuget.org/packages/libsimpleio)
[![libsimpleio-templates](https://img.shields.io/nuget/v/libsimpleio-templates?style=flat&logo=nuget&label=libsimpleio-templates)](https://www.nuget.org/packages/libsimpleio-templates)

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

Questions or comments to Philip Munts <phil@munts.net>
