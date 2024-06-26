// GPIO pin services using libsimpleio

// Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

#ifndef _GPIO_LIBSIMPLEIO_H
#define _GPIO_LIBSIMPLEIO_H

#include <climits>
#include <gpio-interface.h>
#include <libsimpleio/libgpio.h>

namespace libsimpleio::GPIO
{
  typedef struct
  {
    unsigned chip;
    unsigned line;
  } Designator;

  const Designator Unavailable = { UINT_MAX, UINT_MAX };

  struct Pin_Class: public Interfaces::GPIO::Pin_Interface
  {
    Pin_Class(unsigned chip, unsigned line, unsigned direction,
      bool state = false, unsigned driver = GPIO_DRIVER_PUSHPULL,
      unsigned polarity = GPIO_POLARITY_ACTIVEHIGH,
      unsigned edge = GPIO_EDGE_NONE);

    Pin_Class(Designator pin, unsigned direction,
      bool state = false, unsigned driver = GPIO_DRIVER_PUSHPULL,
      unsigned polarity = GPIO_POLARITY_ACTIVEHIGH,
      unsigned edge = GPIO_EDGE_NONE);

    // GPIO methods

    virtual bool read(void);

    virtual void write(const bool state);

  private:

    int fd;
    bool interrupt;
  };
}

#endif
