// Raw HID device services using libhidapi

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

#ifndef _HID_HIDAPI_H
#define _HID_HIDAPI_H

#include <message64-interface.h>

namespace hidapi::HID
{
  // Messenger class definition

  struct Messenger_Class: public Interfaces::Message64::Messenger_Interface
  {
    // Allowed values for the timeout parameter:
    // 
    // -1 => Receive operation blocks forever, until a report is received
    //  0 => Receive operation never blocks at all
    // >0 => Receive operation blocks for the indicated number of milliseconds

    Messenger_Class(uint16_t VID, uint16_t PID, const char *serial = "",
      int timeoutms = 1000);

    virtual void Send(Interfaces::Message64::Message cmd);

    virtual void Receive(Interfaces::Message64::Message resp);

    virtual void Transaction(Interfaces::Message64::Message cmd,
      Interfaces::Message64::Message resp);

  private:

    void *handle;
    int timeout;
  };
}

#endif
