// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// timer services

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
    /// The Timer class implements LPC1114 32-bit hardware timer services.
    /// </summary>
    public class Timer
    {
        /// <summary>
        /// The LPC1114 system clock frequency is 48 MHz.
        /// </summary>
        public const uint PCLK_FREQUENCY = 48000000;

        /// <summary>
        /// LPC1114 32-bit timer identifiers.
        /// </summary>
        public enum ID
        {
            CT32B0,
            CT32B1,
            SENTINEL
        }

        /// <summary>
        /// LPC1114 32-bit timer modes.
        /// </summary>
        public enum MODE
        {
            DISABLED,
            RESET,
            PCLK,
            CAP0_RISING,
            CAP0_FALLING,
            CAP0_BOTH,
            SENTINEL
        }

        /// <summary>
        /// LPC1114 32-bit timer capture modes.
        /// </summary>
        public enum CAPTURE_EDGE
        {
            DISABLED,
            CAP0_RISING,
            CAP0_FALLING,
            CAP0_BOTH,
            SENTINEL
        }

        /// <summary>
        /// LPC1114 32-bit timer match registers.
        /// </summary>
        public enum MATCH_REGISTER
        {
            MATCH0,
            MATCH1,
            MATCH2,
            MATCH3,
            SENTINEL
        }

        /// <summary>
        /// LPC1114 32-bit timer match output actions.
        /// </summary>
        public enum MATCH_OUTPUT
        {
            DISABLED,
            CLEAR,
            SET,
            TOGGLE,
            SENTINEL
        }

        /// <summary>
        /// LPC1114 32-bit timer capture and match features.
        /// </summary>
        [Flags]
        public enum FEATURES
        {
            INTERRUPT = 0x10,
            RESET = 0x20,
            STOP = 0x40
        }

        private ITransport mytransport;
        private ID mytimer;
        private SPIAGENT_COMMAND_MSG_t cmd;
        private SPIAGENT_RESPONSE_MSG_t resp;

        /// <summary>
        /// LPC1114 32-bit timer object constructor.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="timer">Timer identifier.</param>
        /// <param name="mode">Timer mode.  Default is MODE.DISABLED.</param>
        /// <param name="prescaler">Timer prescaler.  Default is 1.</param>
        public Timer(ITransport spiagent, ID timer, MODE mode = MODE.DISABLED, uint prescaler = 1)
        {
            // Validate parameters

            if (spiagent == null)
            {
                throw new NullReferenceException("SPI Agent Firmware transport handle is null");
            }

            if (timer >= ID.SENTINEL)
            {
                throw new ArgumentException("Timer ID parameter is invalid");
            }

            if (mode >= MODE.SENTINEL)
            {
                throw new ArgumentException("Timer mode parameter is invalid");
            }

            if (prescaler == 0)
            {
                throw new ArgumentException("Timer prescaler parameter is invalid");
            }

            cmd = new SPIAGENT_COMMAND_MSG_t();
            resp = new SPIAGENT_RESPONSE_MSG_t();

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_INIT_TIMER;
            cmd.pin = (int)timer;
            cmd.data = 0;

            // Dispatch the command

            spiagent.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_TIMER_PRESCALER;
            cmd.pin = (int)timer;
            cmd.data = (int)prescaler;

            // Dispatch the command

            spiagent.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_TIMER_MODE;
            cmd.pin = (int)timer;
            cmd.data = (int)mode;

            // Dispatch the command

            spiagent.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }

            mytransport = spiagent;
            mytimer = timer;
        }

        /// <summary>
        /// Configure LPC1114 hardware timer mode.
        /// </summary>
        /// <param name="mode">Timer mode</param>
        public void ConfigureMode(MODE mode)
        {
            // Validate parameters

            if (mode >= MODE.SENTINEL)
            {
                throw new ArgumentException("Timer mode parameter is invalid");
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_TIMER_MODE;
            cmd.pin = (int)mytimer;
            cmd.data = (int)mode;

            // Dispatch the command

            mytransport.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }
        }

        /// <summary>
        /// Configure LPC1114 32-bit timer prescaler.
        /// </summary>
        /// <param name="prescaler">Prescaler value.</param>
        public void ConfigurePrescaler(uint prescaler)
        {
            // Validate parameters

            if (prescaler == 0)
            {
                throw new ArgumentException("Timer prescaler parameter is invalid");
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_TIMER_PRESCALER;
            cmd.pin = (int)mytimer;
            cmd.data = (int)prescaler;

            // Dispatch the command

            mytransport.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }
        }

        /// <summary>
        /// Configure LPC1114 32-bit hardware timer capture mode.
        /// </summary>
        /// <param name="edge">CAP0 input edge.</param>
        /// <param name="features">Capture features.</param>
        public void ConfigureCapture(CAPTURE_EDGE edge, FEATURES features = 0)
        {
            // Validate parameters

            if (edge >= CAPTURE_EDGE.SENTINEL)
            {
                throw new ArgumentException("Timer capture edge parameter is invalid");
            }

            if (((int)features & (~(int)FEATURES.INTERRUPT)) != 0)
            {
                throw new ArgumentException("Timer capture features parameter is invalid");
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_TIMER_CAPTURE;
            cmd.pin = (int)mytimer;
            cmd.data = (int)edge | (int)features;

            // Dispatch the command

            mytransport.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }
        }

        /// <summary>
        /// Configure LPC1114 match register.
        /// </summary>
        /// <param name="match">Match register identifier.</param>
        /// <param name="value">Match value.</param>
        /// <param name="action">Match output action.</param>
        /// <param name="features">Match features.</param>
        public void ConfigureMatch(MATCH_REGISTER match, uint value, MATCH_OUTPUT action, FEATURES features)
        {
            // Validate parameters

            if (match >= MATCH_REGISTER.SENTINEL)
            {
                throw new ArgumentException("Timer match register parameter is invalid");
            }

            if (action >= MATCH_OUTPUT.SENTINEL)
            {
                throw new ArgumentException("Timer match output action parameter is invalid");
            }

            if (((int)features & ~((int)FEATURES.INTERRUPT | (int)FEATURES.RESET | (int)FEATURES.STOP)) != 0)
            {
                throw new ArgumentException("Timer match features parameter is invalid");
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0 + (int)match;
            cmd.pin = (int)mytimer;
            cmd.data = (int)action | (int)features;

            // Dispatch the command

            mytransport.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_TIMER_MATCH0_VALUE + (int)match;
            cmd.pin = (int)mytimer;
            cmd.data = (int)value;

            // Dispatch the command

            mytransport.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }
        }

        /// <summary>
        /// This read-only property returns the LPC1114 32-bit timer counter register.
        /// </summary>
        public uint counter
        {
            get
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_GET_TIMER_VALUE;
                cmd.pin = (int)mytimer;
                cmd.data = 0;

                // Dispatch the command

                mytransport.Command(cmd, ref resp);

                // Handle errors

                if (resp.error != 0)
                {
                    throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
                }

                return (uint)resp.data;
            }
        }

        /// <summary>
        /// This read-only property returns the LPC1114 32-bit timer capture register.
        /// </summary>
        public uint capture
        {
            get
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_GET_TIMER_CAPTURE;
                cmd.pin = (int)mytimer;
                cmd.data = 0;

                // Dispatch the command

                mytransport.Command(cmd, ref resp);

                // Handle errors

                if (resp.error != 0)
                {
                    throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
                }

                return (uint)resp.data;
            }
        }

        /// <summary>
        /// This read-only property returns the most recent LPC1114 32-bit timer capture delta value.
        /// </summary>
        public uint capture_delta
        {
            get
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_GET_TIMER_CAPTURE_DELTA;
                cmd.pin = (int)mytimer;
                cmd.data = 0;

                // Dispatch the command

                mytransport.Command(cmd, ref resp);

                // Handle errors

                if (resp.error != 0)
                {
                    throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
                }

                return (uint)resp.data;
            }
        }
    }
}
