// Watchdog timer device services using libsimpleio

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

#ifndef _WATCHDOG_LIBSIMPLEIO_H
#define _WATCHDOG_LIBSIMPLEIO_H

#include <watchdog-interface.h>

namespace libsimpleio::Watchdog
{
  static const char * const DefaultDevice = "/dev/watchdog";
  static const unsigned DefaultTimeout = 0;

  struct Timer_Class: public Interfaces::Watchdog::Timer_Interface
  {
    Timer_Class(const char *devname = DefaultDevice,
      unsigned timeout = DefaultTimeout);

    virtual unsigned GetTimeout(void);

    virtual unsigned SetTimeout(unsigned timeout);

    virtual void Kick(void);

  private:

    int fd;
  };
}

#endif
