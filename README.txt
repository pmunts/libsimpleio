                            Linux Simple I/O Library

   libsimpleio is an attempt to encapsulate (as much as possible) the
   ugliness of Linux I/O device access. It provides services for the
   following types of I/O devices:

     * [1]Industrial I/O Subsystem A/D (Analog to Digital) Converter
       Devices
     * GPIO (General Purpose Input/Output) Pins
     * Raw HID (Human Interface Device) Devices
     * I2C (Inter-Integrated Circuit) Bus Devices
     * [2]Labview LINX Remote I/O Devices
     * PWM (Pulse Width Modulated) Output Devices
     * Serial Ports
     * SPI (Serial Peripheral Interface) Bus Devices
     * [3]Stream Framing Protocol Devices
     * TCP and UDP over IPv4 Network Devices
     * Watchdog Timer Devices

   Although libsimpleio was originally intended for Linux microcomputers
   such as the Raspberry Pi, it can also be useful on larger desktop Linux
   systems.

   The wrapper functions exported by libsimpleio all follow the same
   uniform pattern:

     * All wrapper functions are proper procedures (void f() in C).
     * All input arguments of primitive types (int, float, etc.) are
       passed by value.
     * All output arguments of primitive types are passed by reference
       (int *, float *, etc.).
     * All composite types are passed by reference.
     * int32_t is used wherever possible for int and bool arguments.

   All of the wrapper functions are declared between _BEGIN_STD_C and
   _END_STD_C for C++. Binding modules are provided for [4]Ada, [5]C#,
   [6]Java, and [7]Free Pascal.

   Source code files for Ada, C++, C#, Java, and Free Pascal that define
   OOP (Object Oriented Programming) classes for libsimpleio are also
   provided. Since libsimpleio is intended for general utility, as a
   matter of policy these classes will provide interface and device
   services, but not any platform dependent services.

   Some platform specific libraries and test programs using libsimpleio
   are available at: [8]http://git.munts.com/arm-linux-mcu/examples.

News

     * 15 November 2017 -- Started writing libsimpleio unit tests. Added
       many, many parameter checks to the functions in libsimpleio. Fixed
       a number of errors in the man pages.
     * 16 November 2017 -- Released C# bindings for libsimpleio.
     * 6 December 2017 -- Added functions STREAM_change_readfn() and
       STREAM_change_writefn() to replace read() and write inside
       libstream. This is probably most useful with [9]LWIP on
       microcontrollers.
     * 3 January 2018 -- Imported C++, C#, and Free Pascal interfaces and
       objects. Imported the .Net assembly libsimplio.dll.
     * 12 January 2018 -- Imported Ada and Java interfaces and objects.
     * 17 January 2018 -- Extensively reworked the C++ interfaces and
       objects.
     * 26 February 2018 -- Added LINUX_poll(), which wraps poll().
     * 12 March 2018 -- Reworked GPIO and PWM routines and udev rules.
     * 6 April 2018 -- Imported a project to build libremoteio.dll, an
       implementation of the [10]Remote I/O Protocol that is portable
       across Linux, MacOS, and Windows.
     * 12 May 2018 -- Switched from the deprecated GPIO sysfs API to the
       new GPIO descriptor API.
     * 14 May 2018 -- Install include files to
       /usr/local/include/libsimpleio/.
     * 16 June 2018 -- Added LINUX_usleep().
     * 18 June 2018 -- Minor fixes and consistency cleanups.
     * 27 June 2018 -- Added UDP over IPv4 services.

Documentation

   New The user manual for libsimpleio is available at:
   [11]http://git.munts.com/libsimpleio/doc/UserManual.pdf

   The man pages specifying the libsimpleio API are available at:
   [12]libsimpleio.html

Git Repository

   The source code is available at: [13]http://git.munts.com

   Use the following command to clone it:

   git clone http://git.munts.com/libsimpleio.git

Copyright:

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
   ___________________________________________________________________

   Questions or comments to Philip Munts [14]phil@munts.net

   I am available for custom system development (hardware and software) of
   products using ARM Linux or other microcomputers.

References

   1. https://wiki.analog.com/software/linux/docs/iio/iio
   2. https://www.labviewmakerhub.com/doku.php?id=learn:libraries:linx:spec:start
   3. http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf
   4. http://git.munts.com/libsimpleio/ada
   5. https://docs.microsoft.com/en-us/dotnet/csharp
   6. http://git.munts.com/libsimpleio/java
   7. http://git.munts.com/libsimpleio/pascal
   8. http://git.munts.com/arm-linux-mcu/examples
   9. http://savannah.nongnu.org/projects/lwip
  10. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
  11. http://git.munts.com/libsimpleio/doc/UserManual.pdf
  12. http://git.munts.com/libsimpleio/doc/libsimpleio.html
  13. http://git.munts.com/
  14. mailto:phil@munts.net
