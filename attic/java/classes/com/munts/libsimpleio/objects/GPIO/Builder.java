// Copyright (C)2018-2026, Philip Munts dba Munts Technologies.
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

package com.munts.libsimpleio.objects.GPIO;

import com.munts.interfaces.GPIO.Pin;
import com.munts.libsimpleio.bindings.libgpio;
import com.munts.libsimpleio.objects.GPIO.PinSubclass;

public class Builder
{
  public int chip;
  public int line;
  public int flags;
  public int events;
  public int state;

  public Builder(int chip, int line)
  {
    this.chip = chip;
    this.line = line;
    this.flags = 0;
    this.events = 0;
    this.state = 0;
  }

  public void SetDirection(com.munts.interfaces.GPIO.Direction direction)
  {
    switch (direction)
    {
      case Input:
        this.flags |= libgpio.LINE_REQUEST_INPUT;
        break;

      case Output:
        this.flags |= libgpio.LINE_REQUEST_OUTPUT;
        break;

      default:
        throw new RuntimeException("ERROR: Invalid direction parameter");
    }
  }

  public void SetDriver(Driver driver)
  {
    switch (driver)
    {
      case PushPull:
        this.flags |= libgpio.LINE_REQUEST_PUSH_PULL;
        break;

      case OpenDrain:
        this.flags |= libgpio.LINE_REQUEST_OPEN_DRAIN;
        break;

      case OpenSource:
        this.flags |= libgpio.LINE_REQUEST_OPEN_SOURCE;
        break;

      default:
        throw new RuntimeException("ERROR: Invalid driver parameter");
    }
  }

  public void SetPolarity(Polarity polarity)
  {
    switch (polarity)
    {
      case ActiveLow:
        this.flags |= libgpio.LINE_REQUEST_ACTIVE_LOW;
        break;

      case ActiveHigh:
        this.flags |= libgpio.LINE_REQUEST_ACTIVE_HIGH;
        break;

      default:
        throw new RuntimeException("ERROR: Invalid polarity parameter");
    }
  }

  public void SetInterrupt(Edge edge)
  {
    switch (edge)
    {
      case None:
        this.events = libgpio.EVENT_REQUEST_NONE;
        break;

      case Rising:
        this.events = libgpio.EVENT_REQUEST_RISING;
        break;

      case Falling:
        this.events = libgpio.EVENT_REQUEST_FALLING;
        break;

      case Both:
        this.events = libgpio.EVENT_REQUEST_BOTH;
        break;

      default:
        throw new RuntimeException("ERROR: Invalid interrupt edge parameter");
    }
  }

  public void SetState(boolean state)
  {
    this.state = state ? 1 : 0;
  }

  public Pin Create()
  {
    return new PinSubclass(this);
  }
}
