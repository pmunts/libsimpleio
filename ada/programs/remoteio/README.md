Ada Remote I/O Client Programs
==============================

The query programs illustrate six different methods of communicating with a [Remote I/O Protocol](http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf) server: Four variations of raw HID (Human Interface Device) plus serial port and UDP (User Datagram Protocol).

The device test programs all use raw HID via the [HIDAPI](https://github.com/signal11/hidapi) library, the most portable of the four raw HID variations. They will compile and run on Linux, MacOS, and Windows client computers. Unfortunately, they will not work on a [MuntsOS](http://git.munts.com/muntsos) **client** computer, as MuntsOS does not currently support `libhidapi`. Use `libsimpleio` instead, as illustrated in `test_query_libsimpleio.adb`.

On all Posix systems, use `make` to compile the test programs. I use [Cygwin](https://www.cygwin.com) `make` on Windows as well, but if you don't have and don't want Cygwin on your Windows system, you can use the script command files `compile.cmd` and `clean.cmd` instead.

------------------------------------------------------------------------

Questions or comments to Philip Munts <phil@munts.net>

I am available for custom system development (hardware and software) of products using ARM Linux or other microcomputers.