namespace IO.Bindings.libsimpleio;

// Import of libsimpleio_bindings (1.0)
// Frameworks: 
// Targets: arm64
// Dep fx:rtl
// Dep libs:
// Platform: Linux
// 

type
  IO.Bindings.libsimpleio.__Global = class
  private

    class method EVENT_open(epfd: ^int32_t; error: ^int32_t); public;
    class method EVENT_register_fd(epfd: int32_t; fd: int32_t; events: int32_t; handle: int32_t; error: ^int32_t); public;
    class method EVENT_modify_fd(epfd: int32_t; fd: int32_t; events: int32_t; handle: int32_t; error: ^int32_t); public;
    class method EVENT_unregister_fd(epfd: int32_t; fd: int32_t; error: ^int32_t); public;
    class method EVENT_wait(epfd: int32_t; fd: ^int32_t; &event: ^int32_t; handle: ^int32_t; timeoutms: int32_t; error: ^int32_t); public;
    class method EVENT_close(epfd: int32_t; error: ^int32_t); public;
    class method GPIO_chip_info(chip: int32_t; name: ^AnsiChar; namesize: int32_t; label: ^AnsiChar; labelsize: int32_t; lines: ^int32_t; error: ^int32_t); public;
    class method GPIO_line_info(chip: int32_t; line: int32_t; &flags: ^int32_t; name: ^AnsiChar; namesize: int32_t; label: ^AnsiChar; labelsize: int32_t; error: ^int32_t); public;
    class method GPIO_line_open(chip: int32_t; line: int32_t; &flags: int32_t; events: int32_t; state: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method GPIO_line_read(fd: int32_t; state: ^int32_t; error: ^int32_t); public;
    class method GPIO_line_write(fd: int32_t; state: int32_t; error: ^int32_t); public;
    class method GPIO_line_event(fd: int32_t; state: ^int32_t; error: ^int32_t); public;
    class method GPIO_line_close(fd: int32_t; error: ^int32_t); public;
    class method HIDRAW_open1(name: ^AnsiChar; fd: ^int32_t; error: ^int32_t); public;
    class method HIDRAW_open2(VID: int32_t; PID: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method HIDRAW_open3(VID: int32_t; PID: int32_t; serial: ^AnsiChar; fd: ^int32_t; error: ^int32_t); public;
    class method HIDRAW_close(fd: int32_t; error: ^int32_t); public;
    class method HIDRAW_get_name(fd: int32_t; name: ^AnsiChar; namesize: int32_t; error: ^int32_t); public;
    class method HIDRAW_get_info(fd: int32_t; bustype: ^int32_t; vendor: ^int32_t; product: ^int32_t; error: ^int32_t); public;
    class method HIDRAW_send(fd: int32_t; buf: ^Void; bufsize: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method HIDRAW_receive(fd: int32_t; buf: ^Void; bufsize: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method I2C_open(name: ^AnsiChar; fd: ^int32_t; error: ^int32_t); public;
    class method I2C_close(fd: int32_t; error: ^int32_t); public;
    class method I2C_transaction(fd: int32_t; slaveaddr: int32_t; cmd: ^Void; cmdlen: int32_t; resp: ^Void; resplen: int32_t; error: ^int32_t); public;
    class method IPV4_resolve(name: ^AnsiChar; addr: ^int32_t; error: ^int32_t); public;
    class method IPV4_ntoa(addr: int32_t; dst: ^AnsiChar; dstsize: int32_t; error: ^int32_t); public;
    class method TCP4_connect(addr: int32_t; port: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method TCP4_accept(addr: int32_t; port: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method TCP4_server(addr: int32_t; port: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method TCP4_close(fd: int32_t; error: ^int32_t); public;
    class method TCP4_send(fd: int32_t; buf: ^Void; bufsize: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method TCP4_receive(fd: int32_t; buf: ^Void; bufsize: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method UDP4_open(addr: int32_t; port: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method UDP4_close(fd: int32_t; error: ^int32_t); public;
    class method UDP4_send(fd: int32_t; addr: int32_t; port: int32_t; buf: ^Void; bufsize: int32_t; &flags: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method UDP4_receive(fd: int32_t; addr: ^int32_t; port: ^int32_t; buf: ^Void; bufsize: int32_t; &flags: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method LINUX_detach(error: ^int32_t); public;
    class method LINUX_drop_privileges(username: ^AnsiChar; error: ^int32_t); public;
    class method LINUX_openlog(id: ^AnsiChar; options: int32_t; facility: int32_t; error: ^int32_t); public;
    class method LINUX_errno: int32_t; public;
    class method LINUX_syslog(priority: int32_t; msg: ^AnsiChar; error: ^int32_t); public;
    class method LINUX_strerror(error: int32_t; buf: ^AnsiChar; bufsize: int32_t); public;
    class method LINUX_poll(numfiles: int32_t; files: ^int32_t; events: ^int32_t; results: ^int32_t; timeout: int32_t; error: ^int32_t); public;
    class method LINUX_usleep(microseconds: int32_t; error: ^int32_t); public;
    class method LINUX_command(cmd: ^AnsiChar; ret: ^int32_t; error: ^int32_t); public;
    class method PWM_configure(chip: int32_t; channel: int32_t; period: int32_t; ontime: int32_t; polarity: int32_t; error: ^int32_t); public;
    class method PWM_open(chip: int32_t; channel: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method PWM_close(fd: int32_t; error: ^int32_t); public;
    class method PWM_write(fd: int32_t; ontime: int32_t; error: ^int32_t); public;
    class method SERIAL_open(name: ^AnsiChar; baudrate: int32_t; parity: int32_t; databits: int32_t; stopbits: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method SERIAL_close(fd: int32_t; error: ^int32_t); public;
    class method SERIAL_send(fd: int32_t; buf: ^Void; bufsize: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method SERIAL_receive(fd: int32_t; buf: ^Void; bufsize: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method SPI_open(name: ^AnsiChar; mode: int32_t; wordsize: int32_t; speed: int32_t; fd: ^int32_t; error: ^int32_t); public;
    class method SPI_close(fd: int32_t; error: ^int32_t); public;
    class method SPI_transaction(spifd: int32_t; csfd: int32_t; cmd: ^Void; cmdlen: int32_t; delayus: int32_t; resp: ^Void; resplen: int32_t; error: ^int32_t); public;
    class method STREAM_change_readfn(newread: method(fd: Int32; buf: ^Void; count: size_t): ssize_t; error: ^int32_t); public;
    class method STREAM_change_writefn(newwrite: method(fd: Int32; buf: ^Void; count: size_t): ssize_t; error: ^int32_t); public;
    class method STREAM_encode_frame(src: ^Void; srclen: int32_t; dst: ^Void; dstsize: int32_t; dstlen: ^int32_t; error: ^int32_t); public;
    class method STREAM_decode_frame(src: ^Void; srclen: int32_t; dst: ^Void; dstsize: int32_t; dstlen: ^int32_t; error: ^int32_t); public;
    class method STREAM_receive_frame(fd: int32_t; buf: ^Void; bufsize: int32_t; framesize: ^int32_t; error: ^int32_t); public;
    class method STREAM_send_frame(fd: int32_t; buf: ^Void; bufsize: int32_t; count: ^int32_t; error: ^int32_t); public;
    class method WATCHDOG_open(name: ^AnsiChar; fd: ^int32_t; error: ^int32_t); public;
    class method WATCHDOG_close(fd: int32_t; error: ^int32_t); public;
    class method WATCHDOG_get_timeout(fd: int32_t; timeout: ^int32_t; error: ^int32_t); public;
    class method WATCHDOG_set_timeout(fd: int32_t; newtimeout: int32_t; timeout: ^int32_t; error: ^int32_t); public;
    class method WATCHDOG_kick(fd: int32_t; error: ^int32_t); public;
    class var EPOLLIN: Int32; public;
    class var EPOLLPRI: Int32; public;
    class var EPOLLOUT: Int32; public;
    class var EPOLLRDNORM: Int32; public;
    class var EPOLLRDBAND: Int32; public;
    class var EPOLLWRNORM: Int32; public;
    class var EPOLLWRBAND: Int32; public;
    class var EPOLLMSG: Int32; public;
    class var EPOLLERR: Int32; public;
    class var EPOLLHUP: Int32; public;
    class var EPOLLRDHUP: Int32; public;
    class var EPOLLWAKEUP: Int32; public;
    class var EPOLLONESHOT: Int32; public;
    class var EPOLLET: Int32; public;
    class var LINE_INFO_KERNEL: Int32; public;
    class var LINE_INFO_OUTPUT: Int32; public;
    class var LINE_INFO_ACTIVE_LOW: Int32; public;
    class var LINE_INFO_OPEN_DRAIN: Int32; public;
    class var LINE_INFO_OPEN_SOURCE: Int32; public;
    class var LINE_REQUEST_INPUT: Int32; public;
    class var LINE_REQUEST_OUTPUT: Int32; public;
    class var LINE_REQUEST_ACTIVE_HIGH: Int32; public;
    class var LINE_REQUEST_ACTIVE_LOW: Int32; public;
    class var LINE_REQUEST_PUSH_PULL: Int32; public;
    class var LINE_REQUEST_OPEN_DRAIN: Int32; public;
    class var LINE_REQUEST_OPEN_SOURCE: Int32; public;
    class var EVENT_REQUEST_NONE: Int32; public;
    class var EVENT_REQUEST_RISING: Int32; public;
    class var EVENT_REQUEST_FALLING: Int32; public;
    class var EVENT_REQUEST_BOTH: Int32; public;
    class var INADDR_ANY: Int32; public;
    class var INADDR_LOOPBACK: Int32; public;
    class var INADDR_BROADCAST: Int32; public;
    class var MSG_DONTROUTE: Int32; public;
    class var MSG_DONTWAIT: Int32; public;
    class var MSG_MORE: Int32; public;
    class var LOG_PID: Int32; public;
    class var LOG_CONS: Int32; public;
    class var LOG_ODELAY: Int32; public;
    class var LOG_NDELAY: Int32; public;
    class var LOG_NOWAIT: Int32; public;
    class var LOG_PERROR: Int32; public;
    class var LOG_KERN: Int32; public;
    class var LOG_USER: Int32; public;
    class var LOG_MAIL: Int32; public;
    class var LOG_DAEMON: Int32; public;
    class var LOG_AUTH: Int32; public;
    class var LOG_SYSLOG: Int32; public;
    class var LOG_LPR: Int32; public;
    class var LOG_NEWS: Int32; public;
    class var LOG_UUCP: Int32; public;
    class var LOG_CRON: Int32; public;
    class var LOG_AUTHPRIV: Int32; public;
    class var LOG_FTP: Int32; public;
    class var LOG_LOCAL0: Int32; public;
    class var LOG_LOCAL1: Int32; public;
    class var LOG_LOCAL2: Int32; public;
    class var LOG_LOCAL3: Int32; public;
    class var LOG_LOCAL4: Int32; public;
    class var LOG_LOCAL5: Int32; public;
    class var LOG_LOCAL6: Int32; public;
    class var LOG_LOCAL7: Int32; public;
    class var LOG_EMERG: Int32; public;
    class var LOG_ALERT: Int32; public;
    class var LOG_CRIT: Int32; public;
    class var LOG_ERR: Int32; public;
    class var LOG_WARNING: Int32; public;
    class var LOG_NOTICE: Int32; public;
    class var LOG_INFO: Int32; public;
    class var LOG_DEBUG: Int32; public;
    class var POLLIN: Int32; public;
    class var POLLPRI: Int32; public;
    class var POLLOUT: Int32; public;
    class var POLLERR: Int32; public;
    class var POLLHUP: Int32; public;
    class var POLLNVAL: Int32; public;
    class var PWM_POLARITY_ACTIVELOW: Int32; public;
    class var PWM_POLARITY_ACTIVEHIGH: Int32; public;
    class var SERIAL_PARITY_NONE: Int32; public;
    class var SERIAL_PARITY_EVEN: Int32; public;
    class var SERIAL_PARITY_ODD: Int32; public;
    class var SPI_AUTO_CS: Int32; public;

  end;

  IO.Bindings.libsimpleio.STREAM_readfn_t = block(fd: Int32; buf: ^Void; count: size_t): ssize_t;

  IO.Bindings.libsimpleio.STREAM_writefn_t = block(fd: Int32; buf: ^Void; count: size_t): ssize_t;

end.
