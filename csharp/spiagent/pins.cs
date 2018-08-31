// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// GPIO pin definitions

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

using lpc11xx;

namespace SPIAgent
{

    /// <summary>
    /// These are the LPC1114 I/O pins available for use on the Raspberry Pi LPC1114 I/O Processor Expansion Board.
    /// </summary>
    public static class Pins
    {
        // GPIO pins on the Raspberry Pi P1 expansion header

        /// <summary>
        /// Interrupt output to Raspberry Pi
        /// </summary>
        public const int LPC1114_INT = (int)lpc11xx.Pins.PIO0_3;

        // The LED on the expansion board

        /// <summary>
        /// On board LED
        /// </summary>
        public const int LPC1114_LED = (int)lpc11xx.Pins.PIO0_7;

        // GPIO pins on the expansion board terminal block

        /// <summary>
        /// GPIO0 aka LPC1114 PIO1_0
        /// </summary>
        public const int LPC1114_GPIO0 = (int)lpc11xx.Pins.PIO1_0;
        /// <summary>
        /// GPIO1 aka LPC1114 PIO1_1
        /// </summary>
        public const int LPC1114_GPIO1 = (int)lpc11xx.Pins.PIO1_1;
        /// <summary>
        /// GPIO2 aka LPC1114 PIO1_2
        /// </summary>
        public const int LPC1114_GPIO2 = (int)lpc11xx.Pins.PIO1_2;
        /// <summary>
        /// GPIO3 aka LPC1114 PIO1_3
        /// </summary>
        public const int LPC1114_GPIO3 = (int)lpc11xx.Pins.PIO1_3;
        /// <summary>
        /// GPIO4 aka LPC1114 PIO1_4
        /// </summary>
        public const int LPC1114_GPIO4 = (int)lpc11xx.Pins.PIO1_4;
        /// <summary>
        /// GPIO5 aka LPC1114 PIO1_5
        /// </summary>
        public const int LPC1114_GPIO5 = (int)lpc11xx.Pins.PIO1_5;
        /// <summary>
        /// GPIO6 aka LPC1114 PIO1_8
        /// </summary>
        public const int LPC1114_GPIO6 = (int)lpc11xx.Pins.PIO1_8;
        /// <summary>
        /// GPIO7 aka LPC1114 PIO1_9
        /// </summary>
        public const int LPC1114_GPIO7 = (int)lpc11xx.Pins.PIO1_9;

        // Aliases for analog inputs

        /// <summary>
        /// Analog input 1 aka GPIO0
        /// </summary>
        public const int LPC1114_AD1 = LPC1114_GPIO0;
        /// <summary>
        /// Analog input 2 aka GPIO1
        /// </summary>
        public const int LPC1114_AD2 = LPC1114_GPIO1;
        /// <summary>
        /// Analog input 3 aka GPIO2
        /// </summary>
        public const int LPC1114_AD3 = LPC1114_GPIO2;
        /// <summary>
        /// Analog input 4 aka GPIO3
        /// </summary>
        public const int LPC1114_AD4 = LPC1114_GPIO3;
        /// <summary>
        /// Analog input 5 aka GPIO4
        /// </summary>
        public const int LPC1114_AD5 = LPC1114_GPIO4;

        // Aliases for PWM outputs

        /// <summary>
        /// PWM output 1 aka GPIO1
        /// </summary>
        public const int LPC1114_PWM1 = LPC1114_GPIO1;
        /// <summary>
        /// PWM output 2 aka GPIO2
        /// </summary>
        public const int LPC1114_PWM2 = LPC1114_GPIO2;
        /// <summary>
        /// PWM output 3 aka GPIO3
        /// </summary>
        public const int LPC1114_PWM3 = LPC1114_GPIO3;
        /// <summary>
        /// PWM output 4 aka GPIO7
        /// </summary>
        public const int LPC1114_PWM4 = LPC1114_GPIO7;

        // Aliases for timer/counter pins

        /// <summary>
        /// CT32B1 capture input 0 aka GPIO0
        /// </summary>
        public const int LPC1114_CT32B1_CAP0 = LPC1114_GPIO0;
        /// <summary>
        /// CT32B1 match output 0 aka GPIO1
        /// </summary>
        public const int LPC1114_CT32B1_MAT0 = LPC1114_GPIO1;
        /// <summary>
        /// CT32B1 match output 1 aka GPIO2
        /// </summary>
        public const int LPC1114_CT32B1_MAT1 = LPC1114_GPIO2;
        /// <summary>
        /// CT32B1 match output 2 aka GPIO3
        /// </summary>
        public const int LPC1114_CT32B1_MAT2 = LPC1114_GPIO3;
        /// <summary>
        /// CT32B1 match output 3 aka GPIO4
        /// </summary>
        public const int LPC1114_CT32B1_MAT3 = LPC1114_GPIO4;
        /// <summary>
        /// CT32B0 capture input 0 aka GPIO5
        /// </summary>
        public const int LPC1114_CT32B0_CAP0 = LPC1114_GPIO5;

        // Pin validation functions

        /// <summary>
        /// Validate GPIO pin
        /// </summary>
        /// <param name="pin">LPC1114 GPIO Pin Number</param>
        /// <returns><c>True</c> if the specified pin can be used as a GPIO pin</returns>
        public static bool IS_GPIO(int pin)
        {
            return ((pin >= LPC1114_GPIO0) && (pin <= LPC1114_GPIO5)) || ((pin >= LPC1114_GPIO6) && (pin <= LPC1114_GPIO7));
        }

        /// <summary>
        /// Validate analog input pin
        /// </summary>
        /// <param name="pin">LPC1114 GPIO Pin Number</param>
        /// <returns><c>True</c> if the specified pin can be used as an analog input</returns>
        public static bool IS_ANALOG(int pin)
        {
            return (pin >= LPC1114_AD1) && (pin <= LPC1114_AD5);
        }

        /// <summary>
        /// Validate PWM output pin
        /// </summary>
        /// <param name="pin">LPC1114 GPIO Pin Number</param>
        /// <returns><c>True</c> if the specified pin can be used as a PWM output</returns>
        public static bool IS_PWM(int pin)
        {
            return ((pin >= LPC1114_PWM1) && (pin <= LPC1114_PWM3)) || (pin == LPC1114_PWM4);
        }
    }
}
