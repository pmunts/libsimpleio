                            Linux Simple I/O Library

   libsimpleio is an attempt to encapsulate (as much as possible) the
   ugliness of Linux I/O device access. It provides services for the
   following types of I/O devices:

     * GPIO (General Purpose Input/Output) Pins
     * Raw HID (Human Interface Device) Devices
     * I^2C (Inter-Integrated Circuit) Bus Devices
     * [1]Labview LINX Remote I/O Devices
     * PWM (Pulse Width Modulated) Output Devices
     * Serial Ports
     * SPI (Serial Peripheral Interface) Bus Devices
     * [2]Stream Framing Protocol Devices
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
   _END_STD_C for C++. Binding modules are provided for [3]Ada, [4]Java,
   and [5]Free Pascal.

Documentation

   New The user manual for libsimpleio is available at:
   [6]http://git.munts.com/libsimpleio/doc/UserManual.pdf

   The man pages specifying the libsimpleio API are available at:
   [7]libsimpleio.html

Git Repository

   The source code is available at: [8]http://git.munts.com

   Use the following command to clone it:
   git clone http://git.munts.com/libsimpleio.git

Copyright:

   Original works herein are copyrighted as follows:

Copyright (C)2016-2017, Philip Munts, President, Munts AM Corp.

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

   Questions or comments to Philip Munts [9]phil@munts.net

   I am available for custom system development (hardware and software) of
   products using ARM Linux or other microcomputers.

References

   1. https://www.labviewmakerhub.com/doku.php?id=learn:libraries:linx:spec:start
   2. http://git.munts.com/libsimpleio/doc/StreamFramingProtocol.pdf
   3. http://git.munts.com/libsimpleio/ada
   4. http://git.munts.com/libsimpleio/java
   5. http://git.munts.com/libsimpleio/pascal
   6. http://git.munts.com/libsimpleio/doc/UserManual.pdf
   7. http://git.munts.com/libsimpleio/doc/libsimpleio.html
   8. http://git.munts.com/
   9. mailto:phil@munts.net
