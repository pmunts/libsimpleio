ROSF   libsimpleio-thin[0  p    __ImportSpec__libsimpleio-thin.hSystembits/stdint-intn.hsys/types.hstddef.hIO.Bindings.libsimpleio$      IO.Bindings.libsimpleio.__Global-     'IO.Bindings.libsimpleio.STREAM_readfn_t .     (IO.Bindings.libsimpleio.STREAM_writefn_t "Island"rtl(( ( (( ((((( ( ( ((3�+    t   ADC_get_name"ADC_get_name+   chip+   name+   namesize+	   errorS    ) ADC_get_namee   ADC_open"ADC_open+   chip+   channel+   fd+	   errorS    ) ADC_openK   	ADC_close"	ADC_close+   fd+	   errorS    ) 	ADC_closeW   ADC_read"ADC_read+   fd+
   sample+	   errorS    ) ADC_readt   DAC_get_name"DAC_get_name+   chip+   name+   namesize+	   errorS    ) DAC_get_namee   DAC_open"DAC_open+   chip+   channel+   fd+	   errorS    ) DAC_openK   	DAC_close"	DAC_close+   fd+	   errorS    ) 	DAC_closeZ   	DAC_write"	DAC_write+   fd+
   sample+	   errorS    ) 	DAC_writeP   
EVENT_open"
EVENT_open+   epfd+	   errorS    ) 
EVENT_open�   EVENT_register_fd"EVENT_register_fd+   epfd+   fd+
   events+
   handle+	   errorS    ) EVENT_register_fd�   EVENT_modify_fd"EVENT_modify_fd+   epfd+   fd+
   events+
   handle+	   errorS    ) EVENT_modify_fdv   EVENT_unregister_fd"EVENT_unregister_fd+   epfd+   fd+	   errorS    ) EVENT_unregister_fd�   
EVENT_wait"
EVENT_wait+   epfd+   fd+	   event+
   handle+   	timeoutms+	   errorS    ) 
EVENT_waitS   EVENT_close"EVENT_close+   epfd+	   errorS    ) EVENT_close�   GPIO_chip_info"GPIO_chip_info+   chip+   name+   namesize+	   label+   	labelsize+	   lines+	   errorS    ) GPIO_chip_info�   GPIO_line_info"GPIO_line_info+   chip+   line+	   flags+   name+   namesize+	   label+   	labelsize+	   errorS    ) GPIO_line_info�   GPIO_line_open"GPIO_line_open+   chip+   line+	   flags+
   events+	   state+   fd+	   errorS    ) GPIO_line_openh   GPIO_line_read"GPIO_line_read+   fd+	   state+	   errorS    ) GPIO_line_readk   GPIO_line_write"GPIO_line_write+   fd+	   state+	   errorS    ) GPIO_line_writek   GPIO_line_event"GPIO_line_event+   fd+	   state+	   errorS    ) GPIO_line_event]   GPIO_line_close"GPIO_line_close+   fd+	   errorS    ) GPIO_line_closea   HIDRAW_open1"HIDRAW_open1+   name+   fd+	   errorS    ) HIDRAW_open1l   HIDRAW_open2"HIDRAW_open2+   VID+   PID+   fd+	   errorS    ) HIDRAW_open2{   HIDRAW_open3"HIDRAW_open3+   VID+   PID+
   serial+   fd+	   errorS    ) HIDRAW_open3T   HIDRAW_close"HIDRAW_close+   fd+	   errorS    ) HIDRAW_close{   HIDRAW_get_name"HIDRAW_get_name+   fd+   name+   namesize+	   errorS    ) HIDRAW_get_name�   HIDRAW_get_info"HIDRAW_get_info+   fd+   bustype+
   vendor+   product+	   errorS    ) HIDRAW_get_info{   HIDRAW_send"HIDRAW_send+   fd+   buf+   bufsize+	   count+	   errorS    ) HIDRAW_send�   HIDRAW_receive"HIDRAW_receive+   fd+   buf+   bufsize+	   count+	   errorS    ) HIDRAW_receiveU   I2C_open"I2C_open+   name+   fd+	   errorS    ) I2C_openK   	I2C_close"	I2C_close+   fd+	   errorS    ) 	I2C_close�   I2C_transaction"I2C_transaction+   fd+   	slaveaddr+   cmd+
   cmdlen+   resp+   resplen+	   errorS    ) I2C_transactionc   IPV4_resolve"IPV4_resolve+   name+   addr+	   errorS    ) IPV4_resolvei   	IPV4_ntoa"	IPV4_ntoa+   addr+   dst+   dstsize+	   errorS    ) 	IPV4_ntoan   TCP4_connect"TCP4_connect+   addr+   port+   fd+	   errorS    ) TCP4_connectk   TCP4_accept"TCP4_accept+   addr+   port+   fd+	   errorS    ) TCP4_acceptk   TCP4_server"TCP4_server+   addr+   port+   fd+	   errorS    ) TCP4_serverN   
TCP4_close"
TCP4_close+   fd+	   errorS    ) 
TCP4_closeu   	TCP4_send"	TCP4_send+   fd+   buf+   bufsize+	   count+	   errorS    ) 	TCP4_send~   TCP4_receive"TCP4_receive+   fd+   buf+   bufsize+	   count+	   errorS    ) TCP4_receivee   	UDP4_open"	UDP4_open+   addr+   port+   fd+	   errorS    ) 	UDP4_openN   
UDP4_close"
UDP4_close+   fd+	   errorS    ) 
UDP4_close�   	UDP4_send"	UDP4_send+   fd+   addr+   port+   buf+   bufsize+	   flags+	   count+	   errorS    ) 	UDP4_send�   UDP4_receive"UDP4_receive+   fd+   addr+   port+   buf+   bufsize+	   flags+	   count+	   errorS    ) UDP4_receiveI   LINUX_detach"LINUX_detach+	   errorS    ) LINUX_detachu   LINUX_drop_privileges"LINUX_drop_privileges+   username+	   errorS    ) LINUX_drop_privilegesx   LINUX_openlog"LINUX_openlog+   id+   options+   facility+	   errorS    ) LINUX_openlog8   LINUX_errno"LINUX_errnoS    ) LINUX_errnof   LINUX_syslog"LINUX_syslog+   priority+   msg+	   errorS    ) LINUX_syslogk   LINUX_strerror"LINUX_strerror+	   error+   buf+   bufsizeS    ) LINUX_strerror�   
LINUX_poll"
LINUX_poll+   numfiles+	   files+
   events+   results+   timeout+	   errorS    ) 
LINUX_poll^   LINUX_usleep"LINUX_usleep+   microseconds+	   errorS    ) LINUX_usleepd   LINUX_command"LINUX_command+   cmd+   ret+	   errorS    ) LINUX_command�   PWM_configure"PWM_configure+   chip+   channel+
   period+
   ontime+   polarity+	   errorS    ) PWM_configuree   PWM_open"PWM_open+   chip+   channel+   fd+	   errorS    ) PWM_openK   	PWM_close"	PWM_close+   fd+	   errorS    ) 	PWM_closeZ   	PWM_write"	PWM_write+   fd+
   ontime+	   errorS    ) 	PWM_write�   SERIAL_open"SERIAL_open+   name+   baudrate+
   parity+   databits+   stopbits+   fd+	   errorS    ) SERIAL_openT   SERIAL_close"SERIAL_close+   fd+	   errorS    ) SERIAL_close{   SERIAL_send"SERIAL_send+   fd+   buf+   bufsize+	   count+	   errorS    ) SERIAL_send�   SERIAL_receive"SERIAL_receive+   fd+   buf+   bufsize+	   count+	   errorS    ) SERIAL_receive�   SPI_open"SPI_open+   name+   mode+   wordsize+	   speed+   fd+	   errorS    ) SPI_openK   	SPI_close"	SPI_close+   fd+	   errorS    ) 	SPI_close�   SPI_transaction"SPI_transaction+	   spifd+   csfd+   cmd+
   cmdlen+   delayus+   resp+   resplen+	   errorS    ) SPI_transactionq   STREAM_change_readfn"STREAM_change_readfn+   newread+	   errorS    ) STREAM_change_readfnu   STREAM_change_writefn"STREAM_change_writefn+   newwrite+	   errorS    ) STREAM_change_writefn�   STREAM_encode_frame"STREAM_encode_frame+   src+
   srclen+   dst+   dstsize+
   dstlen+	   errorS    ) STREAM_encode_frame�   STREAM_decode_frame"STREAM_decode_frame+   src+
   srclen+   dst+   dstsize+
   dstlen+	   errorS    ) STREAM_decode_frame�   STREAM_receive_frame"STREAM_receive_frame+   fd+   buf+   bufsize+   	framesize+	   errorS    ) STREAM_receive_frame�   STREAM_send_frame"STREAM_send_frame+   fd+   buf+   bufsize+	   count+	   errorS    ) STREAM_send_framed   WATCHDOG_open"WATCHDOG_open+   name+   fd+	   errorS    ) WATCHDOG_openZ   WATCHDOG_close"WATCHDOG_close+   fd+	   errorS    ) WATCHDOG_close|   WATCHDOG_get_timeout"WATCHDOG_get_timeout+   fd+   timeout+	   errorS    ) WATCHDOG_get_timeout�   WATCHDOG_set_timeout"WATCHDOG_set_timeout+   fd+   
newtimeout+   timeout+	   errorS    ) WATCHDOG_set_timeoutW   WATCHDOG_kick"WATCHDOG_kick+   fd+	   errorS    ) WATCHDOG_kick   LIBSIMPLEIO_BINDINGS
8    EPOLLIN
8    EPOLLPRI
8   EPOLLOUT
8   EPOLLRDNORM
8   EPOLLRDBAND
8   EPOLLWRNORM
8   EPOLLWRBAND
8   EPOLLMSG
8   EPOLLERR
8   EPOLLHUP
8	   
EPOLLRDHUP
8
   EPOLLWAKEUP
8   EPOLLONESHOT
8   EPOLLET
8   LINE_INFO_KERNEL
8    LINE_INFO_OUTPUT
8   LINE_INFO_ACTIVE_LOW
8   LINE_INFO_OPEN_DRAIN
8   LINE_INFO_OPEN_SOURCE
8	   LINE_REQUEST_INPUT
8    LINE_REQUEST_OUTPUT
8"   LINE_REQUEST_ACTIVE_HIGH
8!   LINE_REQUEST_ACTIVE_LOW
8    LINE_REQUEST_PUSH_PULL
8!   LINE_REQUEST_OPEN_DRAIN
8"   LINE_REQUEST_OPEN_SOURCE
8	   EVENT_REQUEST_NONE
8   EVENT_REQUEST_RISING
8    EVENT_REQUEST_FALLING
8   EVENT_REQUEST_BOTH
8   
INADDR_ANY
8   INADDR_LOOPBACK
8   INADDR_BROADCAST
8   MSG_DONTROUTE
8   MSG_DONTWAIT
8   MSG_MORE
8   LOG_PID
8    LOG_CONS
8   
LOG_ODELAY
8   
LOG_NDELAY
8   
LOG_NOWAIT
8	   
LOG_PERROR
8   LOG_KERN
8   LOG_USER
8   LOG_MAIL
8	   
LOG_DAEMON
8   LOG_AUTH
8   
LOG_SYSLOG
8   LOG_LPR
8   LOG_NEWS
8   LOG_UUCP
8   LOG_CRON
8   LOG_AUTHPRIV
8   LOG_FTP
8   
LOG_LOCAL0
8   
LOG_LOCAL1
8   
LOG_LOCAL2
8   
LOG_LOCAL3
8   
LOG_LOCAL4
8   
LOG_LOCAL5
8   
LOG_LOCAL6
8    
LOG_LOCAL7
8!   	LOG_EMERG
8   	LOG_ALERT
8    LOG_CRIT
8   LOG_ERR
8   LOG_WARNING
8   
LOG_NOTICE
8"   LOG_INFO
8#   	LOG_DEBUG
8$   POLLIN
8    POLLPRI
8   POLLOUT
8   POLLERR
8   POLLHUP
8	   POLLNVAL
8    PWM_POLARITY_ACTIVELOW
8!   PWM_POLARITY_ACTIVEHIGH
8    SERIAL_PARITY_NONE
8   SERIAL_PARITY_EVEN
8    SERIAL_PARITY_ODD
8   SPI_AUTO_CS
883!   
RemObjects.Elements.System.Void3    
rtl.int32_t3    3%   
#RemObjects.Elements.System.AnsiChar3    3    3    34    +    	+   fd
+   buf+	   count(3    
rtl.ssize_t3"   
 RemObjects.Elements.System.Int323    

rtl.size_t34    +    	+   fd
+   buf+	   count(3    :aarch64-linux-gnuk    )libsimpleio.sox x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x x �      �      �      �   @   �   �   �      �      �      �      �      �       �       �      @�      ��    �      �     �   �����    �  �       �      �   (   �   0   �   8   �   H   �   P   �   X   �   �   �   �   �   �   �   �   �   �   �   �   �   �   �      �      �      M  Z1.0bLinuxhpy      