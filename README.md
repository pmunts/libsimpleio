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
and **`_END_STD_C`** for C++. Binding modules are provided for Ada, C\#,
Java, and Free Pascal. Additional source code libraries are provided for
Ada, C++, C\#, Java, and Free Pascal that define OOP (Object Oriented
Programming) classes for **libsimpleio**.

Quick Setup Instructions for the Impatient
------------------------------------------

Instructions for installing **libsimpleio** are found in
[UserManual.pdf](http://git.munts.com/libsimpleio/doc/UserManual.pdf),
on pages 5 and 6.

News
----

-   10 February 2021 -- Added support for GPIO output pins implemented
    using PWM outputs. This is useful for controlling an ON/OFF device
    such as an LED or solenoid valve driven by PWM output.
-   18 March 2021 -- Modified the package building procedure to only
    install the absolute minimum files for the MuntsOS cross-compiled
    packages. An issue with `dpkg` installation script execution order
    may require you to run the following commands after upgrading to
    this version of **libsimpleio**:

        sudo find /usr/local -name '*-tmp' -exec rm {} ";"
        sudo apt install --reinstall munts-libsimpleio

    If you have previously installed the MuntsOS cross-compiled
    packages, you will also need to run one or more of the following
    commands:

        sudo apt install --reinstall gcc-aarch64-linux-gnu-muntsos-crosstool
        sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-BeagleBone-crosstool
        sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-RaspberryPi1-crosstool
        sudo apt install --reinstall gcc-arm-linux-gnueabihf-muntsos-RaspberryPi2-crosstool

Documentation
-------------

The user manual for **libsimpleio** is available at
[UserManual.pdf](http://git.munts.com/libsimpleio/doc/UserManual.pdf).

The man pages specifying the **libsimpleio** API are available at
[libsimpleio.html](http://git.munts.com/libsimpleio/doc/libsimpleio.html).

Git Repository
--------------

The source code is available at:

<https://github.com/pmunts/libsimpleio>

Use the following command to clone it:

    git clone https://github.com/pmunts/libsimpleio.git

Package Repository
------------------

Prebuilt packages for [Debian](http://www.debian.org) Linux are
available at:

<http://repo.munts.com/debian10>

[Make With Ada](https://www.makewithada.org/) Projects
------------------------------------------------------

-   2017 [Ada Embedded Linux
    Framework](https://www.makewithada.org/entry/ada_linux_sensor_framework)
-   2019 [Modbus RTU Framework for
    Ada](https://www.hackster.io/philip-munts/modbus-rtu-framework-for-ada-f33cc6)
    (Prize Winner!)

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>

I am available for custom system development (hardware and software) of
products using ARM Linux or other microcomputers.
