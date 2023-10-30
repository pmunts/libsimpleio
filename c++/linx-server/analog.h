// LabView Linx Remote I/O Protocol Analog I/O abstract interface module

// Copyright (C)2016-2023, Philip Munts dba Munts Technologies.
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

#ifndef _ANALOG_INTERFACE_H
#define _ANALOG_INTERFACE_H

#include <stdint.h>

// Since the LabView LINX Remote I/O Protocol doesn't allow multiple
// analog subsystems with differing resolutions or reference voltages,
// all analog values are normalized to unsigned 32-bit with a 4.294967V
// span (i.e. 1 nanovolt per step).

class ADC_Interface
{
  public:
    virtual void read(uint32_t *nanovolts, int32_t *error) = 0;
};

class DAC_Interface
{
  public:
    virtual void write(uint32_t *nanovolts, int32_t *error) = 0;
};

typedef ADC_Interface *ADC_Interface_Ptr;

typedef DAC_Interface *DAC_Interface_Ptr;

extern void adc_add_channel(uint8_t number, ADC_Interface_Ptr object);

extern void dac_add_channel(uint8_t number, DAC_Interface_Ptr object);

extern void analog_init(void);

#endif
