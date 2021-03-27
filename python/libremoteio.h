//                API Specification for libremoteio.dll

//=============================================================================

// Open Raw HID Adapter.
//
// Valid Vendor ID and Product ID values are 0 to 65536.
// Munts Technology Raw HID devices are 16D0:0AFA.
// 
// The serial number string "" matches any board.
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

void open(int vid, int pid, char *serial, int timeout, int *error);

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

void adc_configure(int handle, int channel, int *resolution, int *error);

//=============================================================================

// Read from an A/D converter analog input.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// On success, a raw data sample will be returned in *sample.
//
// Zero on success, or an errno value on failure will be returned in *error.

void adc_read(int handle, int channel, int *sample, int *error);

//=============================================================================

// Fetch available A/D converter analog input channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid A/D input.
// For example, if an adapter has 4 analog inputs (AIN1, AIN2, AIN3, and AIN4),
// *channels will be set to 0, 1, 1, 1, 1, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

void adc_channels(int handle, uint8_t *channels, int *error);

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

void gpio_configure(int handle, int channel, int direction, int state,
  int *error);

//=============================================================================

// Read from an GPIO pin.
//
// Valid channel numbers are 0 to 127.  Any given adapter will only support a
// small subset of these values.
//
// On success, 0 or 1 will be returned in *state.
//
// Zero on success, or an errno value on failure will be returned in *error.

void gpio_read(int handle, int channel, int *sample, int *error);

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

void gpio_write(int handle, int channel, int state, int *error);

//=============================================================================

// Fetch available GPIO pin channels.
//
// The actual parameter for *channels *MUST* be 128 bytes.  A 1 will be
// returned in each element of channels corresponding to a valid GPIO pin.
// For example, if an adapter has 3 GPIO pins (GPIO2, GPIO3, and GPIO4),
// *channels will be set to 0, 0, 1, 1, 1, 0, 0...
//
// Zero on success, or an errno value on failure will be returned in *error.

void gpio_channels(int handle, uint8_t *channels, int *error);
