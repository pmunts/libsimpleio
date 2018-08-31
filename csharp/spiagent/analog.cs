// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// analog input services

// Copyright (C)2014-2018, Philip Munts, President, Munts AM Corp.
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

using System;

namespace SPIAgent
{
    /// <summary>
    /// The ADC (Analog to Digital Converter) class implements LPC1114 analog input services.
    /// </summary>
    public class ADC : IO.Interfaces.ADC.Sample, IO.Interfaces.ADC.Voltage
    {
        private ITransport mytransport;
        private int mypin;
        private SPIAGENT_COMMAND_MSG_t cmd;
        private SPIAGENT_RESPONSE_MSG_t resp;

        /// <summary>
        /// The analog input range is 0.0 to 3.3 volts.
        /// </summary>
        public const float LPC1114_ADC_SPAN = 3.3F;
        /// <summary>
        /// The analog input resolution is 10 bits.
        /// </summary>
        public const int LPC1114_ADC_BITS = 10;
        /// <summary>
        /// There are 1024 discrete analog input levels.
        /// </summary>
        public const int LPC1114_ADC_STEPS = 1024;
        /// <summary>
        /// The analog input level steps are 3.22 millivolts per step.
        /// </summary>
        public const float LPC1114_ADC_STEPSIZE = 0.00322265625F;

        /// <summary>
        /// LPC1114 analog input object constructor.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="pin">LPC1114 analog input pin number.  LPC1114_AD1 through LPC1114_AD5 are allowed.</param>
        public ADC(ITransport spiagent, int pin)
        {
            // Validate parameters

            if (spiagent == null)
            {
                throw new NullReferenceException("SPI Agent Firmware transport handle is null");
            }

            if (!Pins.IS_ANALOG(pin))
            {
                throw new ArgumentException("ADC pin number is invalid");
            }

            // Build the command message

            cmd = new SPIAGENT_COMMAND_MSG_t();
            resp = new SPIAGENT_RESPONSE_MSG_t();

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_ANALOG_INPUT;
            cmd.pin = pin;
            cmd.data = 0;

            // Dispatch the command

            spiagent.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }

            mytransport = spiagent;
            mypin = pin;
        }

        /// <summary>
        /// This read-only property returns the LPC1114 analog input sample (0 to 1023).
        /// </summary>
        public int sample
        {
            get
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_GET_ANALOG;
                cmd.pin = mypin;
                cmd.data = 0;

                // Dispatch the command

                mytransport.Command(cmd, ref resp);

                // Handle errors

                if (resp.error != 0)
                {
                    throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
                }

                return resp.data;
            }
        }

        /// <summary>
        /// This read-only property returns the LPC1114 A/D converter resolution
        /// int bits.
        /// </summary>
        public int resolution
        {
            get
            {
                return 10;
            }
        }

        /// <summary>
        /// This read-only property returns the LPC1114 analog input voltage (0.0 to 3.3 volts).
        /// </summary>
        public double voltage
        {
            get
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_GET_ANALOG;
                cmd.pin = mypin;
                cmd.data = 0;

                // Dispatch the command

                mytransport.Command(cmd, ref resp);

                // Handle errors

                if (resp.error != 0)
                {
                    throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
                }

                return LPC1114_ADC_STEPSIZE * resp.data;
            }
        }
    }
}
