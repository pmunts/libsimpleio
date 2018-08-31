// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// LEGO® Power Functions Remote Control services

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
    /// The LEGORC class implements LEGO(R) Power Functions Remote Control Services.
    /// </summary>
    public class LEGORC
    {
        /// <summary>
        /// The range of LEGO(R) Power Functions Remote Control channels is 1 to 4.
        /// </summary>
        public const int MIN_CHANNEL = 1;

        /// <summary>
        /// The range of LEGO(R) Power Functions Remote Control channels is 1 to 4.
        /// </summary>
        public const int MAX_CHANNEL = 4;

        /// <summary>
        /// The range of LEGO(R) Power Functions Remote Control speed values is 0 to 255.
        /// Some motor selections impose even smaller speed ranges.
        /// </summary>
        public const int MIN_SPEED = 0;

        /// <summary>
        /// The range of LEGO(R) Power Functions Remote Control speed values is 0 to 255.
        /// Some motor selections impose even smaller speed ranges.
        /// </summary>
        public const int MAX_SPEED = 255;

        /// <summary>
        /// LEGO(R) Power Functions Remote Control moter identifiers.
        /// </summary>
        public enum MOTOR
        {
            ALLSTOP,
            MOTORA,
            MOTORB,
            COMBODIRECT,
            COMBOPWM,
            SENTINEL
        }

        /// <summary>
        /// LEGO(R) Power Functions Remote Control moter direction identifiers.
        /// </summary>
        public enum DIRECTION
        {
            REVERSE,
            FORWARD,
            SENTINEL
        }

        private ITransport mytransport;
        private int mypin;
        private SPIAGENT_COMMAND_MSG_t cmd;
        private SPIAGENT_RESPONSE_MSG_t resp;

        /// <summary>
        /// LEGO(R) Power Functions Remote Control output object constructor.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="pin">LPC1114 GPIO pin number.
        /// LPC1114_GPIO0 through LPC1114_GPIO7 are allowed.</param>
        public LEGORC(ITransport spiagent, int pin)
        {
            // Validate parameters

            if (spiagent == null)
            {
                throw new NullReferenceException("SPI Agent Firmware transport handle is null");
            }

            if (!Pins.IS_GPIO(pin))
            {
                throw new ArgumentException("LEGO(R) RC pin number is invalid");
            }

            cmd = new SPIAGENT_COMMAND_MSG_t();
            resp = new SPIAGENT_RESPONSE_MSG_t();

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT;
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
        /// Issue a LEGO(R) Power Functions Remote Control command.
        /// </summary>
        /// <param name="c">Channel number.</param>
        /// <param name="m">Motor identifier.</param>
        /// <param name="d">Direction identifier.</param>
        /// <param name="s">Speed.</param>
        public void Command(int c, MOTOR m, DIRECTION d, int s)
        {
            // Validate parameters

            if ((c < MIN_CHANNEL) || (c > MAX_CHANNEL))
            {
                throw new ArgumentException("LEGO(R) channel parameter is invalid");
            }

            if (m >= MOTOR.SENTINEL)
            {
                throw new ArgumentException("LEGO(R) motor parameter is invalid");
            }

            if (d >= DIRECTION.SENTINEL)
            {
                throw new ArgumentException("LEGO(R) direction parameter is invalid");
            }

            if ((s < MIN_SPEED) || (s > MAX_SPEED))
            {
                throw new ArgumentException("LEGO(R) speed parameter is invalid");
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_PUT_LEGORC;
            cmd.pin = mypin;
            cmd.data = s | ((int)d << 8) | ((int)m << 16) | (c << 24);

            // Dispatch the command

            mytransport.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }
        }
    }
}
