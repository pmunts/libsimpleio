namespace IO.Bindings.libsimpleio;

// This code file is automatically generated to show the contents of
// libsimpleio-thin.fx, and is not meant to be compiled.
//
// Import of libsimpleio-thin (1.0)
// Frameworks:
// Targets: arm64
// Platform: Linux
// Dependencies (.fx): Island, rtl
//

type
  IO.Bindings.libsimpleio.__Global = public class
  public
    class method ADC_get_name(chip: rtl.int32_t; name: ^AnsiChar; namesize: rtl.int32_t; error: ^rtl.int32_t);
    class method ADC_open(chip: rtl.int32_t; channel: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method ADC_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method ADC_read(fd: rtl.int32_t; sample: ^rtl.int32_t; error: ^rtl.int32_t);
    class method DAC_get_name(chip: rtl.int32_t; name: ^AnsiChar; namesize: rtl.int32_t; error: ^rtl.int32_t);
    class method DAC_open(chip: rtl.int32_t; channel: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method DAC_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method DAC_write(fd: rtl.int32_t; sample: rtl.int32_t; error: ^rtl.int32_t);
    class method EVENT_open(epfd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method EVENT_register_fd(epfd: rtl.int32_t; fd: rtl.int32_t; events: rtl.int32_t; handle: rtl.int32_t; error: ^rtl.int32_t);
    class method EVENT_modify_fd(epfd: rtl.int32_t; fd: rtl.int32_t; events: rtl.int32_t; handle: rtl.int32_t; error: ^rtl.int32_t);
    class method EVENT_unregister_fd(epfd: rtl.int32_t; fd: rtl.int32_t; error: ^rtl.int32_t);
    class method EVENT_wait(epfd: rtl.int32_t; fd: ^rtl.int32_t; &event: ^rtl.int32_t; handle: ^rtl.int32_t; timeoutms: rtl.int32_t; error: ^rtl.int32_t);
    class method EVENT_close(epfd: rtl.int32_t; error: ^rtl.int32_t);
    class method GPIO_chip_info(chip: rtl.int32_t; name: ^AnsiChar; namesize: rtl.int32_t; label: ^AnsiChar; labelsize: rtl.int32_t; lines: ^rtl.int32_t; error: ^rtl.int32_t);
    class method GPIO_line_info(chip: rtl.int32_t; line: rtl.int32_t; &flags: ^rtl.int32_t; name: ^AnsiChar; namesize: rtl.int32_t; label: ^AnsiChar; labelsize: rtl.int32_t; error: ^rtl.int32_t);
    class method GPIO_line_open(chip: rtl.int32_t; line: rtl.int32_t; &flags: rtl.int32_t; events: rtl.int32_t; state: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method GPIO_line_read(fd: rtl.int32_t; state: ^rtl.int32_t; error: ^rtl.int32_t);
    class method GPIO_line_write(fd: rtl.int32_t; state: rtl.int32_t; error: ^rtl.int32_t);
    class method GPIO_line_event(fd: rtl.int32_t; state: ^rtl.int32_t; error: ^rtl.int32_t);
    class method GPIO_line_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method HIDRAW_open1(name: ^AnsiChar; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method HIDRAW_open2(VID: rtl.int32_t; PID: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method HIDRAW_open3(VID: rtl.int32_t; PID: rtl.int32_t; serial: ^AnsiChar; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method HIDRAW_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method HIDRAW_get_name(fd: rtl.int32_t; name: ^AnsiChar; namesize: rtl.int32_t; error: ^rtl.int32_t);
    class method HIDRAW_get_info(fd: rtl.int32_t; bustype: ^rtl.int32_t; vendor: ^rtl.int32_t; product: ^rtl.int32_t; error: ^rtl.int32_t);
    class method HIDRAW_send(fd: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method HIDRAW_receive(fd: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method I2C_open(name: ^AnsiChar; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method I2C_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method I2C_transaction(fd: rtl.int32_t; slaveaddr: rtl.int32_t; cmd: ^Void; cmdlen: rtl.int32_t; resp: ^Void; resplen: rtl.int32_t; error: ^rtl.int32_t);
    class method IPV4_resolve(name: ^AnsiChar; addr: ^rtl.int32_t; error: ^rtl.int32_t);
    class method IPV4_ntoa(addr: rtl.int32_t; dst: ^AnsiChar; dstsize: rtl.int32_t; error: ^rtl.int32_t);
    class method TCP4_connect(addr: rtl.int32_t; port: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method TCP4_accept(addr: rtl.int32_t; port: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method TCP4_server(addr: rtl.int32_t; port: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method TCP4_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method TCP4_send(fd: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method TCP4_receive(fd: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method UDP4_open(addr: rtl.int32_t; port: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method UDP4_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method UDP4_send(fd: rtl.int32_t; addr: rtl.int32_t; port: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; &flags: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method UDP4_receive(fd: rtl.int32_t; addr: ^rtl.int32_t; port: ^rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; &flags: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method LINUX_detach(error: ^rtl.int32_t);
    class method LINUX_drop_privileges(username: ^AnsiChar; error: ^rtl.int32_t);
    class method LINUX_openlog(id: ^AnsiChar; options: rtl.int32_t; facility: rtl.int32_t; error: ^rtl.int32_t);
    class method LINUX_errno: rtl.int32_t;
    class method LINUX_syslog(priority: rtl.int32_t; msg: ^AnsiChar; error: ^rtl.int32_t);
    class method LINUX_strerror(error: rtl.int32_t; buf: ^AnsiChar; bufsize: rtl.int32_t);
    class method LINUX_poll(numfiles: rtl.int32_t; files: ^rtl.int32_t; events: ^rtl.int32_t; results: ^rtl.int32_t; timeout: rtl.int32_t; error: ^rtl.int32_t);
    class method LINUX_usleep(microseconds: rtl.int32_t; error: ^rtl.int32_t);
    class method LINUX_command(cmd: ^AnsiChar; ret: ^rtl.int32_t; error: ^rtl.int32_t);
    class method PWM_configure(chip: rtl.int32_t; channel: rtl.int32_t; period: rtl.int32_t; ontime: rtl.int32_t; polarity: rtl.int32_t; error: ^rtl.int32_t);
    class method PWM_open(chip: rtl.int32_t; channel: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method PWM_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method PWM_write(fd: rtl.int32_t; ontime: rtl.int32_t; error: ^rtl.int32_t);
    class method SERIAL_open(name: ^AnsiChar; baudrate: rtl.int32_t; parity: rtl.int32_t; databits: rtl.int32_t; stopbits: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method SERIAL_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method SERIAL_send(fd: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method SERIAL_receive(fd: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method SPI_open(name: ^AnsiChar; mode: rtl.int32_t; wordsize: rtl.int32_t; speed: rtl.int32_t; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method SPI_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method SPI_transaction(spifd: rtl.int32_t; csfd: rtl.int32_t; cmd: ^Void; cmdlen: rtl.int32_t; delayus: rtl.int32_t; resp: ^Void; resplen: rtl.int32_t; error: ^rtl.int32_t);
    class method STREAM_change_readfn(newread: method(fd: Integer; buf: ^Void; count: rtl.size_t): rtl.ssize_t; error: ^rtl.int32_t);
    class method STREAM_change_writefn(newwrite: method(fd: Integer; buf: ^Void; count: rtl.size_t): rtl.ssize_t; error: ^rtl.int32_t);
    class method STREAM_encode_frame(src: ^Void; srclen: rtl.int32_t; dst: ^Void; dstsize: rtl.int32_t; dstlen: ^rtl.int32_t; error: ^rtl.int32_t);
    class method STREAM_decode_frame(src: ^Void; srclen: rtl.int32_t; dst: ^Void; dstsize: rtl.int32_t; dstlen: ^rtl.int32_t; error: ^rtl.int32_t);
    class method STREAM_receive_frame(fd: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; framesize: ^rtl.int32_t; error: ^rtl.int32_t);
    class method STREAM_send_frame(fd: rtl.int32_t; buf: ^Void; bufsize: rtl.int32_t; count: ^rtl.int32_t; error: ^rtl.int32_t);
    class method WATCHDOG_open(name: ^AnsiChar; fd: ^rtl.int32_t; error: ^rtl.int32_t);
    class method WATCHDOG_close(fd: rtl.int32_t; error: ^rtl.int32_t);
    class method WATCHDOG_get_timeout(fd: rtl.int32_t; timeout: ^rtl.int32_t; error: ^rtl.int32_t);
    class method WATCHDOG_set_timeout(fd: rtl.int32_t; newtimeout: rtl.int32_t; timeout: ^rtl.int32_t; error: ^rtl.int32_t);
    class method WATCHDOG_kick(fd: rtl.int32_t; error: ^rtl.int32_t);
    class const LIBSIMPLEIO_BINDINGS: Integer = 1;
    class const EPOLLIN: Integer = 1;
    class const EPOLLPRI: Integer = 2;
    class const EPOLLOUT: Integer = 4;
    class const EPOLLRDNORM: Integer = 64;
    class const EPOLLRDBAND: Integer = 128;
    class const EPOLLWRNORM: Integer = 256;
    class const EPOLLWRBAND: Integer = 512;
    class const EPOLLMSG: Integer = 1024;
    class const EPOLLERR: Integer = 8;
    class const EPOLLHUP: Integer = 16;
    class const EPOLLRDHUP: Integer = 8192;
    class const EPOLLWAKEUP: Integer = 536870912;
    class const EPOLLONESHOT: Integer = 1073741824;
    class const EPOLLET: Integer = -2147483648;
    class const LINE_INFO_KERNEL: Integer = 1;
    class const LINE_INFO_OUTPUT: Integer = 2;
    class const LINE_INFO_ACTIVE_LOW: Integer = 4;
    class const LINE_INFO_OPEN_DRAIN: Integer = 8;
    class const LINE_INFO_OPEN_SOURCE: Integer = 16;
    class const LINE_REQUEST_INPUT: Integer = 1;
    class const LINE_REQUEST_OUTPUT: Integer = 2;
    class const LINE_REQUEST_ACTIVE_HIGH: Integer = 0;
    class const LINE_REQUEST_ACTIVE_LOW: Integer = 4;
    class const LINE_REQUEST_PUSH_PULL: Integer = 0;
    class const LINE_REQUEST_OPEN_DRAIN: Integer = 8;
    class const LINE_REQUEST_OPEN_SOURCE: Integer = 16;
    class const EVENT_REQUEST_NONE: Integer = 0;
    class const EVENT_REQUEST_RISING: Integer = 1;
    class const EVENT_REQUEST_FALLING: Integer = 2;
    class const EVENT_REQUEST_BOTH: Integer = 3;
    class const INADDR_ANY: Integer = 0;
    class const INADDR_LOOPBACK: Integer = 2130706433;
    class const INADDR_BROADCAST: Integer = -1;
    class const MSG_DONTROUTE: Integer = 4;
    class const MSG_DONTWAIT: Integer = 64;
    class const MSG_MORE: Integer = 32768;
    class const LOG_PID: Integer = 1;
    class const LOG_CONS: Integer = 2;
    class const LOG_ODELAY: Integer = 4;
    class const LOG_NDELAY: Integer = 8;
    class const LOG_NOWAIT: Integer = 16;
    class const LOG_PERROR: Integer = 32;
    class const LOG_KERN: Integer = 0;
    class const LOG_USER: Integer = 8;
    class const LOG_MAIL: Integer = 16;
    class const LOG_DAEMON: Integer = 24;
    class const LOG_AUTH: Integer = 32;
    class const LOG_SYSLOG: Integer = 40;
    class const LOG_LPR: Integer = 48;
    class const LOG_NEWS: Integer = 56;
    class const LOG_UUCP: Integer = 64;
    class const LOG_CRON: Integer = 72;
    class const LOG_AUTHPRIV: Integer = 80;
    class const LOG_FTP: Integer = 88;
    class const LOG_LOCAL0: Integer = 128;
    class const LOG_LOCAL1: Integer = 136;
    class const LOG_LOCAL2: Integer = 144;
    class const LOG_LOCAL3: Integer = 152;
    class const LOG_LOCAL4: Integer = 160;
    class const LOG_LOCAL5: Integer = 168;
    class const LOG_LOCAL6: Integer = 176;
    class const LOG_LOCAL7: Integer = 184;
    class const LOG_EMERG: Integer = 0;
    class const LOG_ALERT: Integer = 1;
    class const LOG_CRIT: Integer = 2;
    class const LOG_ERR: Integer = 3;
    class const LOG_WARNING: Integer = 4;
    class const LOG_NOTICE: Integer = 5;
    class const LOG_INFO: Integer = 6;
    class const LOG_DEBUG: Integer = 7;
    class const POLLIN: Integer = 1;
    class const POLLPRI: Integer = 2;
    class const POLLOUT: Integer = 4;
    class const POLLERR: Integer = 8;
    class const POLLHUP: Integer = 16;
    class const POLLNVAL: Integer = 32;
    class const PWM_POLARITY_ACTIVELOW: Integer = 0;
    class const PWM_POLARITY_ACTIVEHIGH: Integer = 1;
    class const SERIAL_PARITY_NONE: Integer = 0;
    class const SERIAL_PARITY_EVEN: Integer = 1;
    class const SERIAL_PARITY_ODD: Integer = 2;
    class const SPI_AUTO_CS: Integer = -1;
  end;

  IO.Bindings.libsimpleio.STREAM_readfn_t = public block(fd: Integer; buf: ^Void; count: rtl.size_t): rtl.ssize_t;

  IO.Bindings.libsimpleio.STREAM_writefn_t = public block(fd: Integer; buf: ^Void; count: rtl.size_t): rtl.ssize_t;

end.
