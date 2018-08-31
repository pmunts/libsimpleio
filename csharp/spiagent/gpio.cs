// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// GPIO services

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
using System.Collections.Generic;

namespace SPIAgent
{
    /// <summary>
    /// The GPIO (General Purpose Input Output) class implements LPC1114 digital input/output services.
    /// </summary>
    public class GPIO: IO.Interfaces.GPIO.Pin
    {
        /// <summary>
        /// LPC1114 GPIO pin data directions.
        /// </summary>
        public enum DIRECTION
        {
            INPUT,
            OUTPUT,
            SENTINEL
        }

        /// <summary>
        /// LPC1114 GPIO pin configuration modes.
        /// </summary>
        public enum MODE
        {
            INPUT,
            INPUT_PULLDOWN,
            INPUT_PULLUP,
            OUTPUT,
            OUTPUT_OPENDRAIN,
            SENTINEL
        }

        /// <summary>
        /// LPC1114 GPIO pin interrupt modes.
        /// </summary>
        public enum INTERRUPT
        {
            DISABLED,
            FALLING,
            RISING,
            BOTH,
            SENTINEL
        }

        private static HashSet<int> ValidPins = new HashSet<int>();
        private ITransport mytransport;
        private int mypin;
        private SPIAGENT_COMMAND_MSG_t cmd;
        private SPIAGENT_RESPONSE_MSG_t resp;

        /// <summary>
        /// Static constructor that populates the valid pins table.
        /// </summary>
        static GPIO()
        {
            ValidPins.Add(Pins.LPC1114_INT);
            ValidPins.Add(Pins.LPC1114_LED);
            ValidPins.Add(Pins.LPC1114_GPIO0);
            ValidPins.Add(Pins.LPC1114_GPIO1);
            ValidPins.Add(Pins.LPC1114_GPIO2);
            ValidPins.Add(Pins.LPC1114_GPIO3);
            ValidPins.Add(Pins.LPC1114_GPIO4);
            ValidPins.Add(Pins.LPC1114_GPIO5);
            ValidPins.Add(Pins.LPC1114_GPIO6);
            ValidPins.Add(Pins.LPC1114_GPIO7);
        }

        /// <summary>
        /// Constructor that configures a GPIO pin, given pin number, data direction, and initial state.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="pin">LPC1114 GPIO pin number.
        /// LPC1114_GPIO0 through LPC1114_GPIO7 are allowed.</param>
        /// <param name="dir">LPC1114 GPIO pin data direction.</param>
        /// <param name="state">LPC1114 GPIO pin initial state.
        /// For an output pin, sets output state to sourcing (1) or sinking (0).
        /// For an input pin, sets internal pull-up resistor (1) or pull-down resistor (0).</param>
        public GPIO(ITransport spiagent, int pin, DIRECTION dir, bool state)
        {
            // Validate parameters

            if (spiagent == null)
            {
                throw new NullReferenceException("SPI Agent Firmware transport handle is null");
            }

            if (!ValidPins.Contains(pin))
            {
                throw new ArgumentException("GPIO pin number is invalid");
            }

            if (dir >= DIRECTION.SENTINEL)
            {
                throw new ArgumentException("GPIO direction parameter is invalid");
            }

            cmd = new SPIAGENT_COMMAND_MSG_t();
            resp = new SPIAGENT_RESPONSE_MSG_t();

            // Build the command message

            cmd.pin = pin;

            switch (dir)
            {
                case DIRECTION.INPUT:
                    cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_GPIO_INPUT;
                    cmd.data = state ? 1 : 0;
                    break;

                case DIRECTION.OUTPUT:
                    cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_GPIO_OUTPUT;
                    cmd.data = state ? 1 : 0;
                    break;
            }

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
        /// Constructor that configures a GPIO pin, given pin number and mode.
        /// Use this constructor if you need to configure a high-impedance input or an open-drain output.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="pin">LPC1114 GPIO pin number.
        /// LPC1114_GPIO0 through LPC1114_GPIO7 are allowed.</param>
        /// <param name="mode">LPC1114 GPIO pin mode.</param>
        public GPIO(ITransport spiagent, int pin, MODE mode)
        {
            // Validate parameters

            if (spiagent == null)
            {
                throw new NullReferenceException("SPI Agent Firmware transport handle is null");
            }

            if (!ValidPins.Contains(pin))
            {
                throw new ArgumentException("GPIO pin number is invalid");
            }

            if (mode >= MODE.SENTINEL)
            {
                throw new ArgumentException("GPIO mode parameter is invalid");
            }

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_GPIO;
            cmd.pin = pin;
            cmd.data = (int)mode;

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
        /// Configure this GPIO pin's mode.
        /// </summary>
        /// <param name="mode">LPC1114 GPIO pin mode.</param>
        public void ConfigureMode(MODE mode)
        {
            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_GPIO;
            cmd.pin = mypin;
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
        /// Configure this GPIO pin's interrupt mode.
        /// This only makes sense when running on the Raspberry Pi.
        /// </summary>
        /// <param name="intconfig">LPC1114 GPIO pin interrupt mode.</param>
        public void ConfigureInterrupt(INTERRUPT intconfig)
        {
            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_GPIO_INTERRUPT;
            cmd.pin = mypin;
            cmd.data = (int)intconfig;

            // Dispatch the command

            mytransport.Command(cmd, ref resp);

            // Handle errors

            if (resp.error != 0)
            {
                throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
            }
        }

        /// <summary>
        /// This property gets or sets this LPC1114 GPIO pin's state.
        /// </summary>
        public bool state
        {
            get
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_GET_GPIO;
                cmd.pin = mypin;
                cmd.data = 0;

                // Dispatch the command

                mytransport.Command(cmd, ref resp);

                // Handle errors

                if (resp.error != 0)
                {
                    throw new SPIAgent_Exception("SPI Agent Firmware returned error " + ((errno)resp.error).ToString());
                }

                return (resp.data == 1);
            }

            set
            {
                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_PUT_GPIO;
                cmd.pin = mypin;
                cmd.data = value ? 1 : 0;

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
}
