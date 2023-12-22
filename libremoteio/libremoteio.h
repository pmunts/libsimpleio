// API Specification for libremoteio.dll

// Copyright (C)2021-2023, Philip Munts dba Munts Technologies.
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

// See also: http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf

//=============================================================================

// Open a Raw HID Remote I/O Protocol Adapter.
//
// Valid Vendor ID and Product ID values are 0 to 65536.
// Munts Technology Raw HID devices are always 16D0:0AFA.
//
// Serial number values of "" or NULL match any board.
//
// Allowed values for the timeout parameter:
// -1 => Receive operation blocks forever, until a report is received.
//  0 => Receive operation never blocks at all.
// >0 => Receive operation blocks for the indicated number of milliseconds.
// Recommended timeout value is 1000, for a one-second timeout.
//
// On success, an adapter handle number will be returned in *handle.  This
// handle must be passed to all other functions.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void open_hid(int vid, int pid, const char *serial, int timeout,
  int *handle, int *error);

//=============================================================================

// Open a Serial Port Remote I/O Protocol Adapter.
//
// The portname parameter is operating system dependent and typically something
// like "/dev/ttyS0" for Linux and "COM1:" for Windows.
//
// The allowed values for the baudrate parameter are those supported by the
// GNAT.Serial_Communications package the shared library was built from.
//
// The timeout parameter indicates the number of milliseconds to wait for each
// serial port I/O operation to complete.
//
// On success, an adapter handle number will be returned in *handle.  This
// handle must be passed to all other functions.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void open_serial(char *portname, int baudrate, int timeout,
  int *handle, int *error);

//=============================================================================

// Open a UDP Port Remote I/O Protocol Adapter.
//
// The server parameter can either be an IPv4 address like "10.0.0.1" or a
// domain name like "usbgadget.munts.net".
//
// The allowed values for the port parameter are 1 to 65535.
//
// The timeout parameter indicates the number of milliseconds to wait for each
// network I/O operation to complete.
//
// On success, an adapter handle number will be returned in *handle.  This
// handle must be passed to all other functions.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void open_udp(char *server, int port, int timeout, int *handle,
  int *error);

//=============================================================================

// Send a 64-byte message (aka report) to a USB Raw HID device.
//
// *cmd *MUST* be a 64-byte buffer.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void send(int handle, uint8_t *cmd, int *error);

//=============================================================================

// Receive a 64-byte message (aka report) from a USB Raw HID device.
//
// *resp *MUST* be a 64-byte buffer.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void receive(int handle, uint8_t *resp, int *error);

//=============================================================================

// Fetch the adapter version information string
//
// *buf *MUST* be a buffer of at least 64 bytes.
//
// On success, the NUL terminated version information string will be copied to
// *buf.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void get_version(int handle, char *buf, int *error);

//=============================================================================

// Fetch the adapter capability string
//
// *buf *MUST* be a buffer of at least 64 bytes.
//
// On success, the NUL terminated capability string will be copied to *buf.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void get_capability(int handle, char *buf, int *error);

//=============================================================================

// Fetch available A/D converter input channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid A/D input.
// For example, if an adapter has 4 analog inputs (ADC1, ADC2, ADC3, and ADC4),
// *channels will be set to 0, 1, 1, 1, 1, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void adc_channels(int handle, uint8_t *channels, int *error);

//=============================================================================

// Configure an A/D converter input.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// On success, the resolution of the analog input in bits will be returned in
// *resolution.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void adc_configure(int handle, int channel, int *resolution,
  int *error);

//=============================================================================

// Read from an A/D converter input.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// On success, a raw data sample will be returned in *sample.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void adc_read(int handle, int channel, int *sample, int *error);

//=============================================================================

// Fetch available D/A converter output channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid D/A output.
// For example, if an adapter has 4 analog outputs (DAC1, DAC2, DAC3, and DAC4),
// *channels will be set to 0, 1, 1, 1, 1, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void dac_channels(int handle, uint8_t *channels, int *error);

//=============================================================================

// Configure an D/A converter output.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// On success, the resolution of the analog output in bits will be returned in
// *resolution.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void dac_configure(int handle, int channel, int *resolution,
  int *error);

//=============================================================================

// Write to a D/A converter output.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// A raw data sample must be passed in sample.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void dac_write(int handle, int channel, int sample, int *error);

//=============================================================================

// Fetch available GPIO pin channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid GPIO pin.
// For example, if an adapter has 3 GPIO pins (GPIO2, GPIO3, and GPIO4),
// *channels will be set to 0, 0, 1, 1, 1, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void gpio_channels(int handle, uint8_t *channels, int *error);

//=============================================================================

// Configure a GPIO pin.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// Valid direction values are 0 for input and 1 for output.
//
// Valid state values are 0 (off, sinking current) and 1 (on, sourcing current).
// The state value is ignored for an input pin.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void gpio_configure(int handle, int channel, int direction,
  int state, int *error);

//=============================================================================

// Read from an GPIO pin.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// On success, 0 or 1 will be returned in *state.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void gpio_read(int handle, int channel, int *state, int *error);

//=============================================================================

// Write to a GPIO pin.  If the GPIO pin has been configured as an input, this
// operation will be ignored.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// Valid state values are 0 (off, sinking current) and 1 (on, sourcing current).
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void gpio_write(int handle, int channel, int state, int *error);

//=============================================================================

// Configure multiple GPIO pins at once.
//
// *mask, *direction, and *state *MUST* be 128-byte buffers.  Each byte of
// *mask, *direction, and *state corresponds to a single GPIO channel.
// (mask[0], direction[0], and state[0] all correspond to GPIO0, etc.)
//
// A 1 in an element of *mask selects the corresponding GPIO channel to be
// configured.  Invalid GPIO channels are silently ignored.
//
// A 1 in an element of *direction indicates the corresponding GPIO channel
// should be configured as an output.  Unselected, invalid, or input only GPIO
// channels are silently ignored.

// The elements of *state indicate the initial state for each GPIO output
// channel.  Unselected or invalid or GPIO input channels are silently ignored.
//
// Valid state values are 0 (off, sinking current) and 1 (on, sourcing current).
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void gpio_configure_all(int handle, uint8_t *mask,
  uint8_t *direction, uint8_t *state, int *error);

//=============================================================================

// Read from multiple GPIO pins at once.
//
// *mask and *state *MUST* be 128-byte buffers.  Each byte of *mask and *state
// corresponds to a GPIO channel.  (mask[0] and state[0] both correspond to
// GPIO0, etc.)
//
// A 1 in an element of *mask selects the corresponding GPIO channel to be
// read from.  Invalid GPIO channels are silently ignored.
//
// Each element of *state will be set to 0 or 1 to indicate what was read from
// the corresponding GPIO channel.  Unselected or invalid GPIO channels are
// silently ignored and their corresponding elements of *state set to 0.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void gpio_read_all(int handle, uint8_t *mask, uint8_t *state,
  int *error);

//=============================================================================

// Write to multiple GPIO pins at once.
//
// *mask and *state *MUST* be 128-byte buffers.  Each byte of *mask and *state
// corresponds to a GPIO channel.  (mask[0] and state[0] both correspond to
// GPIO0, etc.)
//
// A 1 in an element of *mask selects the corresponding GPIO channel to be
// written to.  Invalid GPIO channels are silently ignored.
//
// The elements of *state indicate what should be written to each GPIO channel.
// Unselected or invalid or input only GPIO channels are silently ignored.
//
// Valid state values are 0 (off, sinking current) and 1 (on, sourcing current).
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void gpio_write_all(int handle, uint8_t *mask, uint8_t *state,
  int *error);

//=============================================================================

// Fetch available I2C bus channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid I2C bus.
// For example, if an adapter has 2 I2C buses (I2C0 and I2C2), *channels will
// be set to 1, 0, 1, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void i2c_channels(int handle, uint8_t *channels, int *error);

//=============================================================================

// Configure an I2C bus.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// The usual values for the frequency parameter are 100000 (Standard Mode),
// 400000 (Fast Mode) and 1000000 (Fast Mode Plus).  Almost all adapters will
// support 100 kHz.  Higher bus frequencies may not be supported.  The bus
// frequency must be limited to that supported by the slowest I2C slave on
// the bus.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void i2c_configure(int handle, int channel, int frequency,
  int *error);

//=============================================================================

// Perform an I2C bus transaction.  This can be a read, a write, or an atomic
// write/read operation.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// Valid values for the addr parameter (slave address) are 0 to 127.
//
// The cmd parameter must be the address of a byte array.  NULL is not
// allowed.
//
// The cmdlen parameter must be set to the number of bytes in the command
// byte array.  Valid values are 0 to 56.  Zero indicates a read-only
// operation.
//
// The resp parameter must be the address of a byte array.  NULL is not
// allowed.
//
// The resplen parameter must be set to the number of bytes in the response
// byte array.  Valid values are 0 to 60.  Zero indicates a write-only
// operation.
//
// The delayus parameter indicates how many microseconds to wait between
// write and read phases of an atomic write/read operation.  Allowed values are
// 0 to 65535 microseconds.  Ignored for read-only or write-only operations.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void i2c_transaction(int handle, int channel, int addr,
  uint8_t *cmd, int cmdlen, uint8_t *resp, int resplen, int delayus,
  int *error);

//=============================================================================

// Fetch available PWM output channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid PWM output.
// For example, if an adapter has 2 PWM outputs (PWM0 and PWM1), *channels will
// be set to 1, 1, 0, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void pwm_channels(int handle, uint8_t *channels, int *error);

//=============================================================================

// Configure a PWM output.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// Allowed values for the frequency parameter are 1 to some hardware defined
// limit.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void pwm_configure(int handle, int channel, int frequency,
  int *error);

//=============================================================================

// Write to a PWM output.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// Allowed values for the duty parameter are 0.0 to 100.0 percent.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void pwm_write(int handle, int channel, float duty, int *error);

//=============================================================================

// Fetch available SPI slave device channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid SPI slave
// device. For example, if an adapter has 2 SPI slave devices (SPI0 and SPI1),
// *channels will be set to 1, 1, 0, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void spi_channels(int handle, uint8_t *channels, int *error);

//=============================================================================

// Configure an SPI slave device.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// Valid SPI clock mode numbers are 0 to 3.
//
// Valid word size values are typically 8, 16, and 32 bits.  0 is also allowed
// as a synonym for 8 bits.  Microcontroller based adapters often have byte
// oriented SPI hardware implementations and may not support any word size
// except 8 bits.
//
// Valid clock frequency values depend on the adapter hardware implementation.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void spi_configure(int handle, int channel, int mode, int wordsize,
  int frequency, int *error);

//=============================================================================

// Perform an SPI bus transaction.  This can be a read, a write, or an atomic
// write/read operation.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// The cmd parameter must be the address of a byte array.  NULL is not
// allowed.
//
// The cmdlen parameter must be set to the number of bytes in the command
// byte array.  Valid values are 0 to 56.  Zero indicates a read-only
// operation.
//
// The resp parameter must be the address of a byte array.  NULL is not
// allowed.
//
// The resplen parameter must be set to the number of bytes in the response
// byte array.  Valid values are 0 to 60.  Zero indicates a write-only
// operation.
//
// The delayus parameter indicates how many microseconds to wait between
// write and read phases of an atomic write/read operation.  Allowed values are
// 0 to 65535 microseconds.  Ignored for read-only or write-only operations.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void spi_transaction(int handle, int channel, int addr,
  uint8_t *cmd, int cmdlen, uint8_t *resp, int resplen, int delayus,
  int *error);
