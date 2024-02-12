// Copyright (C)2019-2023, Philip Munts dba Munts Technologies.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#define LIBSIMPLEIO_BINDINGS 1

typedef int int32_t;
typedef long int ssize_t;
typedef long unsigned int size_t;

/*****************************************************************************/

extern void ADC_get_name(int32_t chip, char *name, int32_t namesize, int32_t *error);
extern void ADC_open(int32_t chip, int32_t channel, int32_t *fd, int32_t *error);
extern void ADC_close(int32_t fd, int32_t *error);
extern void ADC_read(int32_t fd, int32_t *sample, int32_t *error);

/*****************************************************************************/

extern void DAC_get_name(int32_t chip, char *name, int32_t namesize, int32_t *error);
extern void DAC_open(int32_t chip, int32_t channel, int32_t *fd, int32_t *error);
extern void DAC_close(int32_t fd, int32_t *error);
extern void DAC_write(int32_t fd, int32_t sample, int32_t *error);

/*****************************************************************************/

#define EPOLLIN      ((int32_t) 0x00000001)
#define EPOLLPRI     ((int32_t) 0x00000002)
#define EPOLLOUT     ((int32_t) 0x00000004)
#define EPOLLRDNORM  ((int32_t) 0x00000040)
#define EPOLLRDBAND  ((int32_t) 0x00000080)
#define EPOLLWRNORM  ((int32_t) 0x00000100)
#define EPOLLWRBAND  ((int32_t) 0x00000200)
#define EPOLLMSG     ((int32_t) 0x00000400)
#define EPOLLERR     ((int32_t) 0x00000008)
#define EPOLLHUP     ((int32_t) 0x00000010)
#define EPOLLRDHUP   ((int32_t) 0x00002000)
#define EPOLLWAKEUP  ((int32_t) 0x20000000)
#define EPOLLONESHOT ((int32_t) 0x40000000)
#define EPOLLET      ((int32_t) 0x80000000)

extern void EVENT_open(int32_t *epfd, int32_t *error);
extern void EVENT_register_fd(int32_t epfd, int32_t fd, int32_t events, int32_t handle, int32_t *error);
extern void EVENT_modify_fd(int32_t epfd, int32_t fd, int32_t events, int32_t handle, int32_t *error);
extern void EVENT_unregister_fd(int32_t epfd, int32_t fd, int32_t *error);
extern void EVENT_wait(int32_t epfd, int32_t *fd, int32_t *event, int32_t *handle, int32_t timeoutms, int32_t *error);
extern void EVENT_close(int32_t epfd, int32_t *error);

/*****************************************************************************/

#define LINE_INFO_KERNEL         0x0001
#define LINE_INFO_OUTPUT         0x0002
#define LINE_INFO_ACTIVE_LOW     0x0004
#define LINE_INFO_OPEN_DRAIN     0x0008
#define LINE_INFO_OPEN_SOURCE    0x0010

#define LINE_REQUEST_INPUT       0x0001
#define LINE_REQUEST_OUTPUT      0x0002
#define LINE_REQUEST_ACTIVE_HIGH 0x0000
#define LINE_REQUEST_ACTIVE_LOW  0x0004
#define LINE_REQUEST_PUSH_PULL   0x0000
#define LINE_REQUEST_OPEN_DRAIN  0x0008
#define LINE_REQUEST_OPEN_SOURCE 0x0010

#define EVENT_REQUEST_NONE       0x0000
#define EVENT_REQUEST_RISING     0x0001
#define EVENT_REQUEST_FALLING    0x0002
#define EVENT_REQUEST_BOTH       0x0003

extern void GPIO_chip_info(int32_t chip, char *name, int32_t namesize, char *label, int32_t labelsize, int32_t *lines, int32_t *error);
extern void GPIO_line_info(int32_t chip, int32_t line, int32_t *flags, char *name, int32_t namesize, char *label, int32_t labelsize, int32_t *error);
extern void GPIO_line_open(int32_t chip, int32_t line, int32_t flags, int32_t events, int32_t state, int32_t *fd, int32_t *error);
extern void GPIO_line_read(int32_t fd, int32_t *state, int32_t *error);
extern void GPIO_line_write(int32_t fd, int32_t state, int32_t *error);
extern void GPIO_line_event(int32_t fd, int32_t *state, int32_t *error);
extern void GPIO_line_close(int32_t fd, int32_t *error);

/*****************************************************************************/

extern void HIDRAW_open1(const char *name, int32_t *fd, int32_t *error);
extern void HIDRAW_open2(int32_t VID, int32_t PID, int32_t *fd, int32_t *error);
extern void HIDRAW_open3(int32_t VID, int32_t PID, const char *serial, int32_t *fd, int32_t *error);
extern void HIDRAW_close(int32_t fd, int32_t *error);
extern void HIDRAW_get_name(int32_t fd, char *name, int32_t namesize, int32_t *error);
extern void HIDRAW_get_info(int32_t fd, int32_t *bustype, int32_t *vendor, int32_t *product, int32_t *error);
extern void HIDRAW_send(int32_t fd, void *buf, int32_t bufsize, int32_t *count, int32_t *error);
extern void HIDRAW_receive(int32_t fd, void *buf, int32_t bufsize, int32_t *count, int32_t *error);

/*****************************************************************************/

extern void I2C_open(const char *name, int32_t *fd, int32_t *error);
extern void I2C_close(int32_t fd, int32_t *error);
extern void I2C_transaction(int32_t fd, int32_t slaveaddr, void *cmd, int32_t cmdlen, void *resp, int32_t resplen, int32_t *error);

/*****************************************************************************/

#define INADDR_ANY       ((int32_t) 0x00000000)
#define INADDR_LOOPBACK  ((int32_t) 0x7F000001)
#define INADDR_BROADCAST ((int32_t) 0xFFFFFFFF)

#define MSG_DONTROUTE    0x0004
#define MSG_DONTWAIT     0x0040
#define MSG_MORE         0x8000

extern void IPV4_resolve(const char *name, int32_t *addr, int32_t *error);
extern void IPV4_ntoa(int32_t addr, char *dst, int32_t dstsize, int32_t *error);

extern void TCP4_connect(int32_t addr, int32_t port, int32_t *fd, int32_t *error);
extern void TCP4_accept(int32_t addr, int32_t port, int32_t *fd, int32_t *error);
extern void TCP4_server(int32_t addr, int32_t port, int32_t *fd, int32_t *error);
extern void TCP4_close(int32_t fd, int32_t *error);
extern void TCP4_send(int32_t fd, void *buf, int32_t bufsize, int32_t *count, int32_t *error);
extern void TCP4_receive(int32_t fd, void *buf, int32_t bufsize, int32_t *count, int32_t *error);

extern void UDP4_open(int32_t addr, int32_t port, int32_t *fd, int32_t *error);
extern void UDP4_close(int32_t fd, int32_t *error);
extern void UDP4_send(int32_t fd, int32_t addr, int32_t port, void *buf, int32_t bufsize, int32_t flags, int32_t *count, int32_t *error);
extern void UDP4_receive(int32_t fd, int32_t *addr, int32_t *port, void *buf, int32_t bufsize, int32_t flags, int32_t *count, int32_t *error);

/*****************************************************************************/

#define LOG_PID      0x0001
#define LOG_CONS     0x0002
#define LOG_ODELAY   0x0004
#define LOG_NDELAY   0x0008
#define LOG_NOWAIT   0x0010
#define LOG_PERROR   0x0020

#define LOG_KERN     0x0000
#define LOG_USER     0x0008
#define LOG_MAIL     0x0010
#define LOG_DAEMON   0x0018
#define LOG_AUTH     0x0020
#define LOG_SYSLOG   0x0028
#define LOG_LPR      0x0030
#define LOG_NEWS     0x0038
#define LOG_UUCP     0x0040
#define LOG_CRON     0x0048
#define LOG_AUTHPRIV 0x0050
#define LOG_FTP      0x0058

#define LOG_LOCAL0   0x0080
#define LOG_LOCAL1   0x0088
#define LOG_LOCAL2   0x0090
#define LOG_LOCAL3   0x0098
#define LOG_LOCAL4   0x00A0
#define LOG_LOCAL5   0x00A8
#define LOG_LOCAL6   0x00B0
#define LOG_LOCAL7   0x00B8

#define LOG_EMERG    0
#define LOG_ALERT    1
#define LOG_CRIT     2
#define LOG_ERR      3
#define LOG_WARNING  4
#define LOG_NOTICE   5
#define LOG_INFO     6
#define LOG_DEBUG    7

#define POLLIN       0x0001
#define POLLPRI      0x0002
#define POLLOUT      0x0004
#define POLLERR      0x0008
#define POLLHUP      0x0010
#define POLLNVAL     0x0020

extern void LINUX_detach(int32_t *error);
extern void LINUX_drop_privileges(const char *username, int32_t *error);
extern void LINUX_openlog(const char *id, int32_t options, int32_t facility, int32_t *error);
extern int32_t LINUX_errno(void);
extern void LINUX_syslog(int32_t priority, const char *msg, int32_t *error);
extern void LINUX_strerror(int32_t error, char *buf, int32_t bufsize);
extern void LINUX_poll(int32_t numfiles, int32_t *files, int32_t *events, int32_t *results, int32_t timeout, int32_t *error);
extern void LINUX_usleep(int32_t microseconds, int32_t *error);
extern void LINUX_command(const char *cmd, int32_t *ret, int32_t *error);

/*****************************************************************************/

#define PWM_POLARITY_ACTIVELOW  0
#define PWM_POLARITY_ACTIVEHIGH 1

extern void PWM_configure(int32_t chip, int32_t channel, int32_t period, int32_t ontime, int32_t polarity, int32_t *error);
extern void PWM_open(int32_t chip, int32_t channel, int32_t *fd, int32_t *error);
extern void PWM_close(int32_t fd, int32_t *error);
extern void PWM_write(int32_t fd, int32_t ontime, int32_t *error);

/*****************************************************************************/

#define SERIAL_PARITY_NONE 0
#define SERIAL_PARITY_EVEN 1
#define SERIAL_PARITY_ODD  2

extern void SERIAL_open(const char *name, int32_t baudrate, int32_t parity, int32_t databits, int32_t stopbits, int32_t *fd, int32_t *error);
extern void SERIAL_close(int32_t fd, int32_t *error);
extern void SERIAL_send(int32_t fd, void *buf, int32_t bufsize, int32_t *count, int32_t *error);
extern void SERIAL_receive(int32_t fd, void *buf, int32_t bufsize, int32_t *count, int32_t *error);

/*****************************************************************************/

#define SPI_AUTO_CS -1

extern void SPI_open(const char *name, int32_t mode, int32_t wordsize, int32_t speed, int32_t *fd, int32_t *error);
extern void SPI_close(int32_t fd, int32_t *error);
extern void SPI_transaction(int32_t spifd, int32_t csfd, void *cmd, int32_t cmdlen, int32_t delayus, void *resp, int32_t resplen, int32_t *error);

/*****************************************************************************/

typedef ssize_t (*STREAM_readfn_t)(int fd, void *buf, size_t count);
typedef ssize_t (*STREAM_writefn_t)(int fd, const void *buf, size_t count);

extern void STREAM_change_readfn(STREAM_readfn_t newread, int32_t *error);
extern void STREAM_change_writefn(STREAM_writefn_t newwrite, int32_t *error);
extern void STREAM_encode_frame(void *src, int32_t srclen, void *dst, int32_t dstsize, int32_t *dstlen, int32_t *error);
extern void STREAM_decode_frame(void *src, int32_t srclen, void *dst, int32_t dstsize, int32_t *dstlen, int32_t *error);
extern void STREAM_receive_frame(int32_t fd, void *buf, int32_t bufsize, int32_t *framesize, int32_t *error);
extern void STREAM_send_frame(int32_t fd, void *buf, int32_t bufsize, int32_t *count, int32_t *error);

/*****************************************************************************/

extern void WATCHDOG_open(const char *name, int32_t *fd, int32_t *error);
extern void WATCHDOG_close(int32_t fd, int32_t *error);
extern void WATCHDOG_get_timeout(int32_t fd, int32_t *timeout, int32_t *error);
extern void WATCHDOG_set_timeout(int32_t fd, int32_t newtimeout, int32_t *timeout, int32_t *error);
extern void WATCHDOG_kick(int32_t fd, int32_t *error);
