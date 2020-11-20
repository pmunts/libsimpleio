// Remote I/O Protocol Client Services

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

// The Remote I/O Protocol specification is available online at:
//
// http://git.munts.com/libsimpleio/doc/RemoteIOProtocol.pdf

#ifndef _REMOTEIO_CLIENT_H
#define _REMOTEIO_CLIENT_H

#include <cstdint>
#include <set>
#include <string>

#include <message64-interface.h>
#include <remoteio.h>

namespace RemoteIO::Client
{
  typedef std::set<uint8_t> ChannelSet_t;

  // Remote I/O Server device class

  struct Device_Class
  {
    // Default Constructor
    Device_Class(const char *serial = nullptr);

    // Constructor
    Device_Class(Interfaces::Message64::Messenger transport);

    // Execute a Remote I/O operation
    void Transaction(Interfaces::Message64::Message cmd,
      Interfaces::Message64::Message resp);

    std::string Version;
    std::string Capability;

    // Available Remote I/O devices
    ChannelSet_t ADC_Inputs;
    ChannelSet_t DAC_Outputs;
    ChannelSet_t GPIO_Pins;
    ChannelSet_t I2C_Buses;
    ChannelSet_t PWM_Outputs;
    ChannelSet_t SPI_Slaves;
    ChannelSet_t Abstract_Devices;

  private:

    Interfaces::Message64::Messenger msg;
    uint8_t num;

    // Retrieve the Remote I/O server version string
    std::string QueryVersion(void);

    // Retrieve the Remote I/O server capability string
    std::string QueryCapability(void);

    // Retrive the set of channels available for a given resource type
    ChannelSet_t QueryChannels(unsigned query);
  };

  typedef Device_Class *Device;
}

#endif
