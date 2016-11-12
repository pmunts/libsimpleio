// Analog to Digital Converter (analog input) abstract interface module

// Copyright (C)2016, Philip Munts, President, Munts AM Corp.
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

#ifndef _ADC_INTERFACE_H
#define _ADC_INTERFACE_H

#include <stdint.h>

// Since the LabView LINX Remote I/O protocol doesn't allow multiple
// analog subsystems with differing resolutions or reference voltages,
// all analog input samples are normalized to 32-bit samples
// (left justified in the upper bits of the 32-bit sample parameter)
// with a 4.294967V reference (i.e. 1 nanovolt per step).

class ADC_Interface
{
  public:
    virtual void read(uint32_t *sample, int32_t *error) = 0;
};

typedef ADC_Interface *ADC_Interface_Ptr;

extern void adc_add_channel(uint8_t channel_number, ADC_Interface_Ptr analog_input);

extern void adc_init(void);

#endif
