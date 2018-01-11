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

#include <cerrno>
#include <fcntl.h>
#include <cstdlib>
#include <watchdog-libsimpleio.h>
#include <libwatchdog.h>

// Constructor

Watchdog_libsimpleio::Watchdog_libsimpleio(const char *devname, unsigned timeout)
{
  int32_t fd;
  int32_t error;

  // Validate parameters

  if (devname == NULL) throw EINVAL;

  // Open the watchdog timer device

  WATCHDOG_open(devname, &fd, &error);
  if (error) throw(error);

  // Change the watchdog timeout period, if requested

  if (timeout != Watchdog_libsimpleio::DefaultTimeout)
  {
    int32_t newtimeout;

    WATCHDOG_set_timeout(fd, timeout, &newtimeout, &error);
    if (error) throw(error);
  }

  this->fd = fd;
}

// Methods

unsigned Watchdog_libsimpleio::GetTimeout(void)
{
  int32_t timeout;
  int32_t error;

  WATCHDOG_get_timeout(this->fd, &timeout, &error);
  if (error) throw(error);

  return timeout;
}

unsigned Watchdog_libsimpleio::SetTimeout(unsigned timeout)
{
  int32_t newtimeout;
  int32_t error;

  WATCHDOG_set_timeout(this->fd, timeout, &newtimeout, &error);
  if (error) throw(error);

  return timeout;
}

void Watchdog_libsimpleio::Kick(void)
{
  int32_t error;

  WATCHDOG_kick(this->fd, &error);
  if (error) throw(error);
}
