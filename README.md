Linux Simple I/O Library
========================

**libsimpleio** is an attempt to encapsulate (as much as possible) the ugliness of Linux I/O device access. It provides services for the following types of I/O devices:

-   [Industrial I/O Subsystem](https://wiki.analog.com/software/linux/docs/iio/iio) A/D (Analog to Digital) Converter Devices
-   [Industrial I/O Subsystem](https://wiki.analog.com/software/linux/docs/iio/iio) D/A (Digital to Analog) Converter Devices
-   GPIO (General Purpose Input/Output) Pins
-   Raw HID (Human Interface Device) Devices
-   I^2^C (Inter-Integrated Circuit) Bus Devices
-   [Labview LINX Remote I/O](https://www.labviewmakerhub.com/doku.php?id=learn:libraries:linx:spec:start) Devices
-   PWM (Pulse Width Modulated) Output Devices
-   [Remote I/O Protocol](http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf) Devices
-   Serial Ports
-   SPI (Serial Peripheral Interface) Bus Devices
-   [Stream Framing Protocol](http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf) Devices
-   TCP and UDP over IPv4 Network Devices
-   Watchdog Timer Devices

Although **libsimpleio** was originally intended for Linux microcomputers such as the Raspberry Pi, it can also be useful on larger desktop Linux systems.

The C wrapper functions exported by **libsimpleio** all follow the same uniform pattern:

-   All C wrapper functions are proper procedures (**`void f()`** in C).
-   All input arguments of primitive types (**`int`**, **`float`**, etc.) are passed by value.
-   All output arguments of primitive types are passed by reference (**`int *`**, **`float *`**, etc.).
-   All composite types are passed by reference.
-   **`int32_t`** is used wherever possible for **`int`** and **`bool`** arguments.

All of the C wrapper functions are declared between **`_BEGIN_STD_C`** and **`_END_STD_C`** for C++. Binding modules are provided for Ada, C\#, Java, and Free Pascal. Additional source code libraries are provided for Ada, C++, C\#, Java, and Free Pascal that define OOP (Object Oriented Programming) classes for **libsimpleio**.

Alire Crates
------------

  ----------------------------------------------------------------------------------------------------------------------------------------- ----------------------------------------------------------------
  [![](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/libsimpleio.json)](https://alire.ada.dev/crates/libsimpleio.html)   [libsimpleio.pdf](http://repo.munts.com/alire/libsimpleio.pdf)
  [![](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/mcp2221.json)](https://alire.ada.dev/crates/mcp2221.html)           [mcp2221.pdf](http://repo.munts.com/alire/mcp2221.pdf)
  [![](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/remoteio.json)](https://alire.ada.dev/crates/remoteio.html)         [remoteio.pdf](http://repo.munts.com/alire/remoteio.pdf)
  ----------------------------------------------------------------------------------------------------------------------------------------- ----------------------------------------------------------------

Quick Setup Instructions for the Impatient
------------------------------------------

Instructions for installing **libsimpleio** are found in [UserManual.pdf](http://git.munts.com/libsimpleio/doc/UserManual.pdf), on pages 5 and 6.

News
----

-   10 February 2021 \-- Added support for GPIO output pins implemented using PWM outputs. This is useful for controlling an ON/OFF device such as an LED or solenoid valve driven by PWM output.

-   18 March 2021 \-- Modified the package building procedure to only install the absolute minimum files for the MuntsOS cross-compiled packages. An issue with `dpkg` installation script execution order may require you to run the following commands after upgrading to this version of **libsimpleio**:

        sudo find /usr/local -name '*-tmp' -exec rm {} ";"
        sudo apt install --reinstall munts-libsimpleio

    If you have previously installed the MuntsOS cross-compiled packages, you will also need to run one or more of the following commands:

        sudo apt install --reinstall gcc-aarch64-linux-gnu-muntsos-crosstool-libsimpleio
        sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-beaglebone-crosstool-libsimpleio
        sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-raspberrypi1-crosstool-libsimpleio
        sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-raspberrypi2-crosstool-libsimpleio

-   25 March 2021 \-- Added some rudimentary Python client support for the [Remote I/O Protocol](http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf) for raw HID servers (like [this](https://www.tindie.com/products/pmunts/usb-flexible-io-adapter) or [this](https://www.tindie.com/products/pmunts/usb-grove-adapter)), in response to a request from a customer who wants to develop a Python Remote I/O Protocol client program that can run on Windows 10 64-bit. Accomplishing this requires a new Windows shared library **`libremoteio.dll`**, which was written in the Ada programming language. It also contains the latest [hidapi](https://github.com/libusb/hidapi) code. Precompiled library files have been added to **`win/win64/`**. A few \"proof of concept\" Python3 programs are in **`python/`.**

-   29 March 2021 \-- The new **`libremoteio.dll`** also works with Visual Studio C++ programs. Added some Visual Studio C++ projects for creating Remote I/O Protocol client programs for 64-Bit Windows 10.

-   20 April 2021 \-- Added support to **`SERIAL_open()`** for more baud rates above 1000000 bps. Fixed issue with raw mode on Raspberry Pi serial ports.

-   18 May 2021 \-- Added support for stepper motors to Ada and .Net. Renamed **`basic/`** to **`mybasic/`**, **`modula2/`** to **`gm2/`**, and **`pascal/`** to **`freepascal/`**.

-   25 July 2021 \-- Prebuild an Ada library project for the Linux Simple I/O Library Ada binding.

-   20 August 2021 \-- An [Alire](https://alire.ada.dev) library crate for **libsimpleio** has been [published](https://alire.ada.dev/crates/libsimpleio.html). Some more library crates for the [Remote I/O Protocol](http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf) and the [MCP2221 USB I/O Expander](https://www.microchip.com/en-us/product/MCP2221A) are also forthcoming.

-   21 August 2021 \-- Added experimental support for cross-compiling **libsimpleio** programs with cross-toolchains from the Debian package repository. You can cross-compile Ada, C++, and Go (and on Debian 11 Modula-2) programs, with certain limitations: No support for [AWS](https://docs.adacore.com/aws-docs/aws/), [hidapi](https://github.com/libusb/hidapi), or [libusb](https://github.com/libusb/libusb). Just set the **`CROSS_COMPILE`** environment variable to select a cross-toolchain instead of a native compile:

        cd libsimpleio/ada/programs
        export CROSS_COMPILE=aarch64-linux-gnu-
        make test_hello

    Select cross-compiled **libsimpleio** packages have been added to the Munts Technologies Debian Package Repositories for [Debian 10](http://repo.munts.com/debian10) (Buster) and [Debian 11](http://repo.munts.com/debian11) (Bullseye).

-   3 September 2021 \-- The Alire crates [mcp2221](https://alire.ada.dev/crates/mcp2221.html) and [remoteio](https://alire.ada.dev/crates/remoteio.html) have now been published.

-   18 November 2021 \-- Updated C\# projects and templates for .Net 6.

Documentation
-------------

The user manual for **libsimpleio** is available at [UserManual.pdf](http://git.munts.com/libsimpleio/doc/UserManual.pdf).

The man pages specifying the **libsimpleio** API are available at [libsimpleio.html](http://git.munts.com/libsimpleio/doc/libsimpleio.html).

Git Repository
--------------

The source code is available at:

<https://github.com/pmunts/libsimpleio>

Use the following command to clone it:

    git clone https://github.com/pmunts/libsimpleio.git

Package Repository
------------------

Prebuilt packages for [Debian](http://www.debian.org) Linux are available at:

<http://repo.munts.com/debian10>

<http://repo.munts.com/debian11>

[Make With Ada](https://www.makewithada.org/) Projects
------------------------------------------------------

-   2017 [Ada Embedded Linux Framework](https://www.makewithada.org/entry/ada_linux_sensor_framework)
-   2019 [Modbus RTU Framework for Ada](https://www.hackster.io/philip-munts/modbus-rtu-framework-for-ada-f33cc6) (Prize Winner!)

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>

I am available for custom system development (hardware and software) of products using ARM Linux or other microcomputers.
