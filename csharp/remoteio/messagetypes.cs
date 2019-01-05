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

namespace IO.Remote
{
    /// <summary>
    /// Remote I/O protocol message types
    /// </summary>
    public enum MessageTypes
    {
        /// <summary>
        /// Loopback request
        /// </summary>
        LOOPBACK_REQUEST,
        /// <summary>
        /// Loopback response
        /// </summary>
        LOOPBACK_RESPONSE,
        /// <summary>
        /// Version string request
        /// </summary>
        VERSION_REQUEST,
        /// <summary>
        /// Version string response
        /// </summary>
        VERSION_RESPONSE,
        /// <summary>
        /// Capability string request
        /// </summary>
        CAPABILITY_REQUEST,
        /// <summary>
        /// Capability string response
        /// </summary>
        CAPABILITY_RESPONSE,
        /// <summary>
        /// GPIO pins available request
        /// </summary>
        GPIO_PRESENT_REQUEST,
        /// <summary>
        /// GPIO pins available response
        /// </summary>
        GPIO_PRESENT_RESPONSE,
        /// <summary>
        /// GPIO pins configure request
        /// </summary>
        GPIO_CONFIGURE_REQUEST,
        /// <summary>
        /// GPIO pins configure response
        /// </summary>
        GPIO_CONFIGURE_RESPONSE,
        /// <summary>
        /// GPIO pins read request
        /// </summary>
        GPIO_READ_REQUEST,
        /// <summary>
        /// GPIO pins read response
        /// </summary>
        GPIO_READ_RESPONSE,
        /// <summary>
        /// GPIO pins write request
        /// </summary>
        GPIO_WRITE_REQUEST,
        /// <summary>
        /// GPIO pins write response
        /// </summary>
        GPIO_WRITE_RESPONSE,
        /// <summary>
        /// I<sup>2</sup>C buses available request
        /// </summary>
        I2C_PRESENT_REQUEST,
        /// <summary>
        /// I<sup>2</sup>C buses available response
        /// </summary>
        I2C_PRESENT_RESPONSE,
        /// <summary>
        /// I<sup>2</sup>C bus configure request
        /// </summary>
        I2C_CONFIGURE_REQUEST,
        /// <summary>
        /// I<sup>2</sup>C bus configure response
        /// </summary>
        I2C_CONFIGURE_RESPONSE,
        /// <summary>
        /// I<sup>2</sup>C bus transaction request
        /// </summary>
        I2C_TRANSACTION_REQUEST,
        /// <summary>
        /// I<sup>2</sup>C bus transaction response
        /// </summary>
        I2C_TRANSACTION_RESPONSE,
        /// <summary>
        ///  SPI slave devices available request
        /// </summary>
        SPI_PRESENT_REQUEST,
        /// <summary>
        /// SPI slave devices available response
        /// </summary>
        SPI_PRESENT_RESPONSE,
        /// <summary>
        /// SPI slave device configure request
        /// </summary>
        SPI_CONFIGURE_REQUEST,
        /// <summary>
        ///  SPI slave device configure response
        /// </summary>
        SPI_CONFIGURE_RESPONSE,
        /// <summary>
        ///  SPI bus transaction request
        /// </summary>
        SPI_TRANSACTION_REQUEST,
        /// <summary>
        ///  SPI bus transaction response
        /// </summary>
        SPI_TRANSACTION_RESPONSE,
        /// <summary>
        /// ADC inputs available request
        /// </summary>
        ADC_PRESENT_REQUEST,
        /// <summary>
        /// ADC inputs available response
        /// </summary>
        ADC_PRESENT_RESPONSE,
        /// <summary>
        /// ADC input configure request
        /// </summary>
        ADC_CONFIGURE_REQUEST,
        /// <summary>
        /// ADC input configure response
        /// </summary>
        ADC_CONFIGURE_RESPONSE,
        /// <summary>
        /// ADC input read request
        /// </summary>
        ADC_READ_REQUEST,
        /// <summary>
        /// ADC input read response
        /// </summary>
        ADC_READ_RESPONSE,
        /// <summary>
        /// DAC outputs available request
        /// </summary>
        DAC_PRESENT_REQUEST,
        /// <summary>
        /// DAC outputs available response
        /// </summary>
        DAC_PRESENT_RESPONSE,
        /// <summary>
        /// DAC input configure request
        /// </summary>
        DAC_CONFIGURE_REQUEST,
        /// <summary>
        /// DAC input configure response
        /// </summary>
        DAC_CONFIGURE_RESPONSE,
        /// <summary>
        /// DAC output write request
        /// </summary>
        DAC_WRITE_REQUEST,
        /// <summary>
        /// DAC output write response
        /// </summary>
        DAC_WRITE_RESPONSE,
        /// <summary>
        /// PWM outputs available request
        /// </summary>
        PWM_PRESENT_REQUEST,
        /// <summary>
        /// PWM outputs available response
        /// </summary>
        PWM_PRESENT_RESPONSE,
        /// <summary>
        /// PWM input configure request
        /// </summary>
        PWM_CONFIGURE_REQUEST,
        /// <summary>
        /// PWM input configure response
        /// </summary>
        PWM_CONFIGURE_RESPONSE,
        /// <summary>
        /// PWM output write request
        /// </summary>
        PWM_WRITE_REQUEST,
        /// <summary>
        /// PWM output write response
        /// </summary>
        PWM_WRITE_RESPONSE,
    }
}
