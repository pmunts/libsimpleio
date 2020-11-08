// GPIO pins using libgpio

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

package GPIO_libsimpleio

import "fmt"
import "syscall"

import "munts.com/libsimpleio/Designator"
import "munts.com/interfaces/GPIO"

//*****************************************************************************

// Private binding to libgpio

const c_LINE_REQUEST_INPUT       = 0x0001
const c_LINE_REQUEST_OUTPUT      = 0x0002
const c_LINE_REQUEST_ACTIVE_HIGH = 0x0000
const c_LINE_REQUEST_ACTIVE_LOW  = 0x0004
const c_LINE_REQUEST_PUSH_PULL   = 0x0000
const c_LINE_REQUEST_OPEN_DRAIN  = 0x0008
const c_LINE_REQUEST_OPEN_SOURCE = 0x0010

const c_EVENT_REQUEST_NONE       = 0x0000
const c_EVENT_REQUEST_RISING     = 0x0001
const c_EVENT_REQUEST_FALLING    = 0x0002
const c_EVENT_REQUEST_BOTH       = 0x0003

//extern GPIO_line_open
func c_GPIO_line_open(chip int32, line int32, flags int32, events int32,
  state int32, fd *int32, error *int32)

//extern GPIO_line_close
func c_GPIO_line_close(fd int32, error *int32)

//extern GPIO_line_read
func c_GPIO_line_read(fd int32, state *int32, error *int32)

//extern GPIO_line_write
func c_GPIO_line_write(fd int32, state int32, error *int32)

//extern GPIO_line_event
func c_GPIO_line_event(fd int32, state *int32, error *int32)

//*****************************************************************************

// GPIO output pin driver settings

type OutputDriver int32

const (
  PushPull OutputDriver = iota
  OpenDrain
  OpenSource
)

// GPIO input pin interrupt edge settings

type InputEdge int32

const (
  None InputEdge = iota
  Rising
  Falling
  Both
)

// GPIO pin polarity settings

type Polarity int32

const (
  ActiveLow Polarity = iota
  ActiveHigh
)

// GPIO pin kinds

type kinds int

const (
  destroyed kinds = iota
  input
  output
  interrupt
)

// GPIO pin struct

type Pin struct {
  kind kinds
  fd int32
}

//*****************************************************************************

// Method to destroy a GPIO pin struct

func (self *Pin) Destroy() error {
  if self.kind == destroyed {
    self.fd = -1
    return nil
  }

  var error int32

  c_GPIO_line_close(self.fd, &error)

  self.kind = destroyed
  self.fd = 0

  if (error != 0) {
    return fmt.Errorf("GPIO_line_close() failed, %s",
      syscall.Errno(error).Error())
  }

  return nil
}

//*****************************************************************************

// Method to initialize a GPIO pin struct

func (self *Pin) Initialize(desg Designator.Designator, dir GPIO.Direction,
  state bool, driver OutputDriver, edge InputEdge, polarity Polarity) error {

  var cflags int32 = 0
  var cevents int32 = 0
  var cstate int32 = 0

  // Initialize the GPIO pin struct

  self.Destroy()

  // Calculate configuration flags

  switch dir {
    case GPIO.Input:
      cflags |= c_LINE_REQUEST_INPUT
    case GPIO.Output:
      cflags |= c_LINE_REQUEST_OUTPUT
  }

  switch driver {
    case PushPull:
      cflags |= c_LINE_REQUEST_PUSH_PULL
    case OpenDrain:
      cflags |= c_LINE_REQUEST_OPEN_DRAIN
    case OpenSource:
      cflags |= c_LINE_REQUEST_OPEN_SOURCE
  }

  switch polarity {
    case ActiveHigh:
      cflags |= c_LINE_REQUEST_ACTIVE_HIGH
    case ActiveLow:
      cflags |= c_LINE_REQUEST_ACTIVE_LOW
  }

  switch edge {
    case None:
      cevents |= c_EVENT_REQUEST_NONE
    case Rising:
      cevents |= c_EVENT_REQUEST_RISING
    case Falling:
      cevents |= c_EVENT_REQUEST_FALLING
    case Both:
      cevents |= c_EVENT_REQUEST_BOTH
  }

  switch state {
    case false:
      cstate = 0
    case true:
      cstate = 1
  }

  if dir == GPIO.Output {
    self.kind = output
  } else if edge == None {
    self.kind = input
  } else {
    self.kind = interrupt
  }

  // Configure the GPIO pin

  var error int32

  c_GPIO_line_open(desg.Chip, desg.Channel, cflags, cevents, cstate, &self.fd,
    &error)

  if (error != 0) {
    self.Destroy()
    return fmt.Errorf("GPIO_line_open() failed, %s",
      syscall.Errno(error).Error())
  }

  return nil
}

//*****************************************************************************

// Create a GPIO pin struct instance

func New(desg Designator.Designator, dir GPIO.Direction, state bool,
  driver OutputDriver, edge InputEdge, polarity Polarity) (self *Pin, err error) {

  // Allocate memory for a GPIO pin struct

  self = new(Pin)

  // Initialize the new GPIO pin struct

  err = self.Initialize(desg, dir, state, driver, edge, polarity)

  if (err == nil) {
    return self, nil
  } else {
    return nil, err
  }
}

func NewInput(desg Designator.Designator) (self *Pin, err error) {

  // Allocate memory for a GPIO pin struct

  self = new(Pin)

  // Initialize the new GPIO pin struct

  err = self.Initialize(desg, GPIO.Input, false, PushPull, None, ActiveHigh)

  if (err == nil) {
    return self, nil
  } else {
    return nil, err
  }
}

func NewInterrupt(desg Designator.Designator, edge InputEdge) (self *Pin, err error) {

  // Allocate memory for a GPIO pin struct

  self = new(Pin)

  // Initialize the new GPIO pin struct

  err = self.Initialize(desg, GPIO.Input, false, PushPull, edge, ActiveHigh)

  if (err == nil) {
    return self, nil
  } else {
    return nil, err
  }
}

func NewOutput(desg Designator.Designator, state bool) (self *Pin, err error) {

  // Allocate memory for a GPIO pin struct

  self = new(Pin)

  // Initialize the new GPIO pin struct

  err = self.Initialize(desg, GPIO.Output, state, PushPull, None, ActiveHigh)

  if (err == nil) {
    return self, nil
  } else {
    return nil, err
  }
}

//*****************************************************************************

// Method to read from a GPIO pin

func (self *Pin) Get() (state bool, err error) {
  var cstate int32
  var error int32

  switch self.kind {
    case destroyed:
      return false, fmt.Errorf("GPIO pin has been destroyed")
    case input:
      c_GPIO_line_read(self.fd, &cstate, &error)
    case output:
      c_GPIO_line_read(self.fd, &cstate, &error)
    case interrupt:
      c_GPIO_line_event(self.fd, &cstate, &error)
  }

  if error != 0 {
    return false, fmt.Errorf("GPIO_line_read() failed, %s",
      syscall.Errno(error).Error())
  }

  switch cstate {
    case 0:
      state = false
    case 1:
      state = true
  }

  return state, nil
}

//*****************************************************************************

// Method to write to a GPIO pin

func (self *Pin) Put(state bool) error {
  var cstate int32
  var error int32

  switch state {
    case true:
      cstate = 1
    case false:
      cstate = 0
  }

  switch self.kind {
    case destroyed:
      return fmt.Errorf("GPIO pin has been destroyed")
    case input:
      return fmt.Errorf("Cannot write to GPIO input")
    case output:
      c_GPIO_line_write(self.fd, cstate, &error)
    case interrupt:
      return fmt.Errorf("Cannot write to GPIO input")
  }

  if error != 0 {
    return fmt.Errorf("GPIO_line_read() failed, %s",
      syscall.Errno(error).Error())
  }

  return nil
}
