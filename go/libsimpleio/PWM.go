// PWM outputs using libpwm

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

package PWM_libsimpleio

import "fmt"
import "syscall"

import "munts.com/libsimpleio/Designator"
import "munts.com/interfaces/PWM"

//*****************************************************************************

// Private binding to libgpio

//extern PWM_configure
func c_PWM_configure(chip int32, channel int32, period int32, ontime int32,
  polarity int32, error *int32)

//extern PWM_open
func c_PWM_open(chip int32, channel int32, fd *int32, error *int32)

//extern PWM_close
func c_PWM_close(fd int32, error *int32)

//extern PWM_write
func c_PWM_write(fd int32, ontime int32, error *int32)

//*****************************************************************************

// PWM output polarity settings

type Polarity int32

const (
  ActiveLow Polarity = iota
  ActiveHigh
)

// PWM output struct

type Output struct {
  period int32
  fd int32
}

//*****************************************************************************

// Private method to calculate the PWM output pulse width (in nanoseconds) for
// a give PWM output duty cycle

func (self *Output) ontime(duty PWM.DutyCycle) int32 {
  return int32(duty/PWM.MaximumDutyCycle*PWM.DutyCycle(self.period) + 0.5)
}

//*****************************************************************************

// Method to destroy a PWM output struct

func (self *Output) Destroy() error {
  if self.period == 0 {
    self.fd = -1
    return nil
  }

  var errnum int32

  c_PWM_close(self.fd, &errnum)

  self.period = 0
  self.fd = -1

  if (errnum != 0) {
    return fmt.Errorf("PWM_close() failed, %s",
      syscall.Errno(errnum).Error())
  }

  return nil
}

//*****************************************************************************

// Method to initialize a PWM output struct

func (self *Output) Initialize(desg Designator.Designator, freq PWM.Frequency,
  duty PWM.DutyCycle, polarity Polarity) error {

  // Validate parameters

  if freq < 1 {
    return fmt.Errorf("Frequency parameter is out of range")
  }

  if duty < PWM.MinimumDutyCycle {
    return fmt.Errorf("Duty cycle parameter is out of range")
  }

  if duty > PWM.MaximumDutyCycle {
    return fmt.Errorf("Duty cycle parameter is out of range")
  }

  // Initialize the PWM output struct

  self.Destroy()

  // Calculate the PWM output pulse period in nanoseconds

  self.period = int32(1E9/freq)

  // Configure the PWM output

  var errnum int32

  c_PWM_configure(desg.Chip, desg.Channel, int32(self.period),
    self.ontime(duty), int32(polarity), &errnum)

  if (errnum != 0) {
    self.Destroy()
    return fmt.Errorf("PWM_configure() failed, %s",
      syscall.Errno(errnum).Error())
  }

  // Open the PWM output

  c_PWM_open(desg.Chip, desg.Channel, &self.fd, &errnum)

  if (errnum != 0) {
    self.Destroy()
    return fmt.Errorf("PWM_open() failed, %s",
      syscall.Errno(errnum).Error())
  }

  return nil
}

//*****************************************************************************

// Create a PWM output struct instance

func New(desg Designator.Designator, freq PWM.Frequency, duty PWM.DutyCycle,
  polarity Polarity) (self *Output, err error) {

  // Validate parameters

  if freq < 1 {
    return nil, fmt.Errorf("Frequency parameter is out of range")
  }

  if duty < PWM.MinimumDutyCycle {
    return nil, fmt.Errorf("Duty cycle parameter is out of range")
  }

  if duty > PWM.MaximumDutyCycle {
    return nil, fmt.Errorf("Duty cycle parameter is out of range")
  }

  // Allocate memory for a PWM output struct

  self = new(Output)

  // Initialize the new PWM output struct

  err = self.Initialize(desg, freq, duty, polarity)

  if (err == nil) {
    return self, nil
  } else {
    return nil, err
  }
}

//*****************************************************************************

// Method to write to a PWM output

func (self *Output) Put(duty PWM.DutyCycle) error {
  if (self.period == 0) {
    return fmt.Errorf("PWM output has been destroyed")
  }

  // Validate parameters

  if duty < PWM.MinimumDutyCycle {
    return fmt.Errorf("Duty cycle parameter is out of range")
  }

  if duty > PWM.MaximumDutyCycle {
    return fmt.Errorf("Duty cycle parameter is out of range")
  }

  // Write to the PWM output

  var errnum int32

  c_PWM_write(self.fd, self.ontime(duty), &errnum)

  if errnum != 0 {
    return fmt.Errorf("PWM_write() failed, %s",
      syscall.Errno(errnum).Error())
  }

  return nil
}

//*****************************************************************************

// Method to fetch the PWM output pulse period

func (self *Output) GetPeriod() (ns PWM.Nanoseconds, err error) {
  if (self.period == 0) {
    return 0, fmt.Errorf("PWM output has been destroyed")
  }

  return PWM.Nanoseconds(self.period), nil
}
