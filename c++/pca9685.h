// PCA9685 LED controller services

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

#ifndef _PCA9685_H
#define _PCA9685_H

#include <cstdint>
#include <cstdlib>

#include <gpio.h>
#include <i2c.h>
#include <pwm.h>
#include <servo.h>

namespace PCA9685
{
  const unsigned MaxChannels = 16;

  // PCA9685 device class

  struct DeviceClass
  {
    DeviceClass(Interfaces::I2C bus, unsigned addr, unsigned freq = 50,
      unsigned clock = 0);

    // Read the 4-byte PCA9685 output channel settings block

    void ReadChannel(unsigned channel, uint8_t *regdata);

    // Write the 4-byte PCA9685 output channel settings block

    void WriteChannel(unsigned channel, const uint8_t *regdata);

    // Retrieve the PWM pulse frequency originally passed to the constructor

    unsigned frequency(void);

  private:

    Interfaces::I2C bus;
    unsigned addr;
    unsigned freq;

    // Write a single PCA9685 register -- Only used in the DeviceClass
    // constructor

    void WriteRegister(uint8_t regaddr, uint8_t regdata);
  };

  typedef DeviceClass *Device;

  // PCA9685 GPIO output class

  struct GPIO: public Interfaces::GPIO_Interface
  {
    GPIO(Device dev, unsigned channel, bool state = false);

    virtual bool read(void);

    virtual void write(bool state);

  private:

    Device dev;
    unsigned channel;
  };

  // PCA9685 PWM output class

  struct PWM: public Interfaces::PWM_Interface
  {
    PWM(Device dev, unsigned channel,
      double dutycycle = Interfaces::PWM_Interface::DUTYCYCLE_MIN);

    virtual void write(double dutycycle);

  private:

    Device dev;
    unsigned channel;
  };

  // PCA9685 servo output class

  struct Servo: public Interfaces::Servo_Interface
  {
    Servo(Device dev, unsigned channel,
      double position = Interfaces::Servo_Interface::POSITION_NEUTRAL);

    virtual void write(double position);

  private:

    Device dev;
    unsigned channel;
  };
}

#endif
