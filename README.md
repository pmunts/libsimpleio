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

-   All C wrapper functions are proper procedures (`void f()` in C).
-   All input arguments of primitive types (`int`, `float`, etc.) are
    passed by value.
-   All output arguments of primitive types are passed by reference
    (`int *`, `float *`, etc.).
-   All composite types are passed by reference.
-   `int32_t` is used wherever possible for `int` and `bool` arguments.

All of the C wrapper functions are declared between `_BEGIN_STD_C` and
`_END_STD_C` for C++. Binding modules are provided for Ada, C++, C\#,
Java, and Free Pascal. Additional source code libraries are provided for
Ada, C++, C\#, Java, and Free Pascal that define OOP (Object Oriented
Programming) classes for **libsimpleio**.

News
----

-   9 January 2019 -- Continued working on the Ada Remote I/O code.
    Continued working on the Pascal Remote I/O code. Compiling Pascal
    Remote I/O client programs on Windows is now supported.

Documentation
-------------

The user manual for **libsimpleio** is available at:
<http://git.munts.com/libsimpleio/doc/UserManual.pdf>

The man pages specifying the **libsimpleio** API are available at:
[libsimpleio.html](http://git.munts.com/libsimpleio/doc/libsimpleio.html)

The source code is available at: <http://git.munts.com>

Use the following command to clone it:

    git clone http://git.munts.com/libsimpleio.git

Copyright:
----------

Original works herein are copyrighted as follows:


    Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.

Redistributed works herein are copyrighted and/or licensed by their
respective authors.

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>

I am available for custom system development (hardware and software) of
products using ARM Linux or other microcomputers.
