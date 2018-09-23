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

News

     * 15 November 2017 -- Started writing libsimpleio unit tests. Added
       many, many parameter checks to the functions in libsimpleio. Fixed
       a number of errors in the man pages.
     * 16 November 2017 -- Released C# bindings for libsimpleio.
     * 6 December 2017 -- Added functions STREAM_change_readfn() and
       STREAM_change_writefn() to replace read() and write inside
       libstream. This is probably most useful with [8]LWIP on
       microcontrollers.
     * 3 January 2018 -- Imported C++, C#, and Free Pascal interfaces and
       objects. Imported the .Net assembly libsimplio.dll.
     * 12 January 2018 -- Imported Ada and Java interfaces and objects.
     * 17 January 2018 -- Extensively reworked the C++ interfaces and
       objects.
     * 26 February 2018 -- Added LINUX_poll(), which wraps poll().
     * 12 March 2018 -- Reworked GPIO and PWM routines and udev rules.
     * 6 April 2018 -- Imported a project to build libremoteio.dll, an
       implementation of the [9]Remote I/O Protocol that is portable
       across Linux, MacOS, and Windows.
     * 12 May 2018 -- Switched from the deprecated GPIO sysfs API to the
       new GPIO descriptor API.
     * 14 May 2018 -- Install include files to
       /usr/local/include/libsimpleio/.
     * 16 June 2018 -- Added LINUX_usleep().
     * 18 June 2018 -- Minor fixes and consistency cleanups.
     * 27 June 2018 -- Added UDP over IPv4 services.
     * 28 June 2018 -- Imported initial support for [10]GNU Modula-2. This
       is not complete, and what is done is still pretty rough.
     * 11 July 2018 -- Imported many test programs from [11]MuntsOS
       Embedded Linux.
     * 8 August 2018 -- The .Net assembly libraries libsimpleio.dll and
       libremoteio.dll have now been published to [12]NuGet..
     * 16 August 2018 -- Rebuilt the C# library .dll files to target .Net
       Framework 4.6.1. Cleaned up the C# library .dll and package
       metadata. Added experimental [13].Net Standard library builders for
       libsimpleio and libremoteio. The published libraries will remain
       .Net Framework 4.6.1 for now, as there are still some issues using
       .Net Standard libraries with Mono. Also performed some general file
       reorganization and house cleaning.
     * 18 August 2018 -- Rebuilt the C# library .dll files to target .Net
       Framework 4.7.1. Added support for the [14]ADC121C021 A/D converter
       chip, which is used in the [15]Grove I2C A/D Converter module.
       Fixed a few issues in the I2C stack. Performed yet more file
       reorganization and house cleaning. Made C# .dll and package
       metadata more clear about what is what.
     * 22 August 2018 -- Fixed various issues with cross-compiling the
       example programs. Added more test programs for the PCA8574 I2C
       GPIO expander.
     * 26 August 2018 -- Added support for the PCA9685 I2C PWM controller
       to the .Net libraries.
     * 3 September 2018 -- Added support for the [16]Raspberry Pi LPC1114
       I/O Processor Expansion Board to the C# libraries. Added a delay
       parameter to the I2C transaction methods for Ada, C++, C#, and
       Free Pascal. The [17]Remote I/O Procotol has also been updated in
       add a delay parameter to the I2C transaction request message.
     * 23 September 2018 -- Modified libremoteio to use HidSharp 2.0.2.
       Added an optional USB serial device serial number parameter to the
       constructor for the libremoteio Messenger class. Added more C# test
       programs.

Documentation

   New The user manual for libsimpleio is available at:

   [18]http://git.munts.com/libsimpleio/doc/UserManual.pdf

   The man pages specifying the libsimpleio API are available at:

   [19]libsimpleio.html

Git Repository

   The source code is available at: [20]http://git.munts.com

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

   Questions or comments to Philip Munts [21]phil@munts.net

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
   8. http://savannah.nongnu.org/projects/lwip
   9. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
  10. https://www.nongnu.org/gm2/homepage.html
  11. http://git.munts.com/arm-linux-mcu/examples
  12. https://www.nuget.org/
  13. https://docs.microsoft.com/en-us/dotnet/standard/net-standard
  14. http://www.ti.com/product/ADC121C021
  15. http://wiki.seeedstudio.com/Grove-I2C_ADC
  16. http://git.munts.com/rpi-mcu/expansion/LPC1114
  17. http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf
  18. http://git.munts.com/libsimpleio/doc/UserManual.pdf
  19. http://git.munts.com/libsimpleio/doc/libsimpleio.html
  20. http://git.munts.com/
  21. mailto:phil@munts.net
