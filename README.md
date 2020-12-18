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

News
----

-   8 January 2020 -- Added **`LINUX_errno()`**. Added
    [libmodbus](https://libmodbus.org) bindings and objects for Ada.
-   31 January 2020 -- Added .gpr project files to
    **`ada/programs/libsimpleio/`**,
    **`ada/programs/libsimpleio/mcp2221/`**, and
    **`ada/programs/libsimpleio/remoteio`** to allow building native
    programs with just **`gprbuild`**, using a command like:

        gprbuild libsimpleio.gpr -p test_userled

    Reworked Ada make files to allow building Windows applications in
    [Windows Subsystem for
    Linux](https://docs.microsoft.com/en-us/windows/wsl/faq). Until now,
    using the make files on Windows required using
    [Cygwin](https://www.cygwin.com).

-   1 February 2020 -- Added links to [Make With
    Ada](https://www.makewithada.org) projects.
-   2 February 2020 -- Flattened the **`csharp/`** directory tree.
-   7 February 2020 -- Added .Net Core 3.1 project templates for both
    **libsimpleio** and **libremoteio**. Install these from
    [NuGet](https://www.nuget.org) with the following commands:

        dotnet new -i libsimpleio-templates
        dotnet new -i libremoteio-templates

-   10 February 2020 -- Renamed NuGet package **libsimpleio-standard**
    to **libsimpleio**. Renamed NuGet package **libremoteio-standard**
    to **libremoteio**. Dropped support for building .Net Framework
    applications with **`csc.exe`**.
-   12 February 2020 -- Added Visual Studio project templates for
    **libsimpleio** and **libremoteio** for C\# console applications for
    .Net Core and .Net Framework.
-   25 February 2020 -- Added support for building NuGet C\# .Net Core
    application packages.
-   3 March 2020 -- Modified **`libsimpleio.dll`** to use
    **`IO.Objects.libsimpleio.Device.Designator`** instead of chip and
    channel to select ADC inputs, DAC outputs, GPIO pins, I<sup>2</sup>C
    buses, PWM outputs, and SPI slave selects.
-   30 April 2020 -- Added **`popen()`** wrappers
    **`LINUX_popen_read()`**, **`LINUX_popen_write()`** and
    **`LINUX_pclose()`**. Added Ada packages **`Email_Sendmail`** and
    **`Email_Mail`**, for sending email messages via
    **`/usr/sbin/sendmail`** and **`/usr/bin/mail`** respectively.
-   15 May 2020 -- Autogenerate API documentation **`.pdf`** files from
    **`libremoteio.dll.chm`** and **`libsimpleio.dll.chm`**. Include API
    documentation files (both **`.chm`** and **`.pdf`**) in the NuGet
    packages.
-   12 September 2020 -- Added or refined email services for Ada, C\#,
    and Free Pascal. This work resulted from a lengthy period of
    experimentation with sending email from a Linux embedded system.
-   18 September 2020 -- Modified udev rule handling for native Linux
    systems. The rules and their helper scripts are now installed to
    **`/usr/local/share/libsimpleio/udev/`**. If you install from a
    source checkout, you now need to do **`make install_udev_rules`**
    after **`make install`** in order to install some symbolic links in
    **`/etc/udev/rules.d`**.  
    Added a [NuGet](https://www.nuget.org) [local package
    feed](https://docs.microsoft.com/en-us/nuget/hosting-packages/local-feeds)
    to **libsimpleio**. You need to manually add an entry to the
    **`packageSources`** block in **`NuGet.Config`** (found at
    **`.config/NuGet/NuGet.Config`** on Linux or
    **`%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\NuGet\NuGet.Config`** on
    Windows) in order to use the local package feed. You should also
    comment out the entry for **`nuget.org`**, especially if you need to
    build .Net applications offline from the Internet.
-   30 October 2020 -- Added initial support for the
    [Go](https://golang.org) programming language, including a build
    framework using [gccgo](https://golang.org/doc/install/gccgo) and
    enough packages to support GPIO pins.
-   13 November 2020 -- Overhauled the C++ code base. Started
    implementing C++ Remote I/O support. Upgraded from .Net Core 3.1 to
    .Net 5.0.
-   24 November 2020 -- Made many improvements, cleanups, and
    reorganizations of the Remote I/O Protocol client implementations
    for Ada, C++, and Free Pascal.
-   5 December 2020 -- More improvements to the Remote I/O Protocol
    client implementations. Modified `libhdraw` to rename
    `HIDRAW_open()` to `HIDRAW_open1()`, `HIDRAW_open_id()` to
    `HIDRAW_open()2`, and add `HIDRAW_open3()`, which accepts as USB
    device serial number string in addition to the vendor and product
    ID's.
-   18 December 2020 -- Added Ada packages `Posix` and `HID.Posix`.
    These make it possible to build Ada Remote I/O Protocol client
    programs on [FreeBSD](https://www.freebsd.org) and
    [OpenBSD](https://www.openbsd.org). The `HID.Posix` package very
    nearly works on Linux as well, except that the ***utterly
    braindead*** GNU implementation of `strerror_r()` doesn't work
    properly: The `buf` and `buflen` arguments are usually (*but not
    always!*) ignored. This is indefensible, but the `glibc` maintainers
    don't seem inclined to fix it. Seamless use of `HID.Posix` requires
    some operating system hotplug magic. Some implementations of same
    are now in `hotplug/`. Accordingly, `udev/` has been moved to
    `hotplug/linux/`.

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
