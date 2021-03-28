//                API Specification for libremoteio.dll

//=============================================================================

// Open Raw HID Adapter.
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

extern "C" void open(int vid, int pid, char *serial, int timeout, int *handle,
  int *error);

//=============================================================================

// Configure an A/D converter analog input.
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

// Read from an A/D converter analog input.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// On success, a raw data sample will be returned in *sample.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void adc_read(int handle, int channel, int *sample, int *error);

//=============================================================================

// Fetch available A/D converter analog input channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid A/D input.
// For example, if an adapter has 4 analog inputs (AIN1, AIN2, AIN3, and AIN4),
// *channels will be set to 0, 1, 1, 1, 1, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void adc_channels(int handle, uint8_t *channels, int *error);

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

extern "C" void gpio_read(int handle, int channel, int *sample, int *error);

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
// read/write operation.
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
// write and read phases of an atomic write/read operation.  Ignored for
// read-only or write-only operations.
//
// Zero on success, or an errno value on failure will be returned in *error.

extern "C" void i2c_transaction(int handle, int channel, int addr,
  uint8_t *cmd, int cmdlen, uint8_t *resp, int resplen, int delayus,
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
