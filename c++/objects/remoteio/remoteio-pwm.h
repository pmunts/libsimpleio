// Remote I/O Protocol PWM output services

// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

#ifndef _REMOTEIO_PWM_H
#define _REMOTEIO_PWM_H

#include <pwm-interface.h>
#include <remoteio-client.h>

namespace RemoteIO::PWM
{
  struct Output_Class: public Interfaces::PWM::Output_Interface
  {
    // PWM output constructor

    Output_Class(RemoteIO::Client::Device dev, unsigned num, unsigned freq,
      double duty = Interfaces::PWM::DUTYCYCLE_MIN);

    // PWM output methods

    virtual void write(const double dutycycle);

    // Query the configured PWM output pulse frequency

    virtual unsigned frequency(void);

  private:

    RemoteIO::Client::Device dev;
    unsigned num;
    unsigned freq;
    unsigned period;
  };
}

#endif
