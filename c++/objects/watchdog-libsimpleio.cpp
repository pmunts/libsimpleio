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

#include <exception-libsimpleio.h>
#include <watchdog-libsimpleio.h>
#include <libsimpleio/libwatchdog.h>

// Constructor

libsimpleio::Watchdog::Timer_Class::Timer_Class(const char *devname,
  unsigned timeout)
{
  int32_t fd;
  int32_t error;

  // Validate parameters

  if (devname == nullptr)
    THROW_MSG("The devname parameter is NULL");

  // Open the watchdog timer device

  WATCHDOG_open(devname, &fd, &error);
  if (error) THROW_MSG_ERR("WATCHDOG_open() failed", error);

  // Change the watchdog timeout period, if requested

  if (timeout != libsimpleio::Watchdog::DefaultTimeout)
  {
    int32_t newtimeout;

    WATCHDOG_set_timeout(fd, timeout, &newtimeout, &error);
    if (error) THROW_MSG_ERR("WATCHDOG_set_timeout() failed", error);
  }

  this->fd = fd;
}

// Methods

unsigned libsimpleio::Watchdog::Timer_Class::GetTimeout(void)
{
  int32_t timeout;
  int32_t error;

  WATCHDOG_get_timeout(this->fd, &timeout, &error);
  if (error) THROW_MSG_ERR("WATCHDOG_get_timeout() failed", error);

  return timeout;
}

unsigned libsimpleio::Watchdog::Timer_Class::SetTimeout(unsigned timeout)
{
  int32_t newtimeout;
  int32_t error;

  WATCHDOG_set_timeout(this->fd, timeout, &newtimeout, &error);
  if (error) THROW_MSG_ERR("WATCHDOG_set_timeout() failed", error);

  return timeout;
}

void libsimpleio::Watchdog::Timer_Class::Kick(void)
{
  int32_t error;

  WATCHDOG_kick(this->fd, &error);
  if (error) THROW_MSG_ERR("WATCHDOG_kick() failed", error);
}
