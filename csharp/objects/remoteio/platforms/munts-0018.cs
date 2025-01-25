// MUNTS-0018 Raspberry Pi Tutorial I/O Board I/O resource definitions

// Copyright (C)2021-2025, Philip Munts dba Munts Technologies.
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

using static IO.Objects.RemoteIO.Platforms.RaspberryPi;

namespace IO.Objects.RemoteIO.Platforms
{
    /// <summary>
    /// I/O resources (channel numbers) available from a
    /// <a href="http://tech.munts.com/manuals/MUNTS-0018.pdf">
    /// MUNTS-0018 Tutorial I/O Board</a> Remote I/O Protocol Server.
    /// </summary>
    public static class MUNTS_0018
    {
        /// <summary>
        /// GPIO channel number for the on-board LED <c>D1</c>.
        /// </summary>
        /// <remarks>
        /// <c>LED1</c> cannot be configured as an input.
        /// </remarks>
        public const int LED1 = GPIO26;

        /// <summary>
        /// GPIO channel number for the on-board momentary switch <c>SW1</c>.
        /// </summary>
        /// <remarks>
        /// <c>SW1</c> cannot be configured as an output.
        /// </remarks>
        public const int SW1 = GPIO6;

        /// <summary>
        /// Servo Header <c>J2</c> position output.
        /// </summary>
        /// <remarks>
        /// PWM output <c>J2PWM</c> controls the servo position.
        /// </remarks>
        public const int J2PWM = PWM0;

        /// <summary>
        ///  Servo Header <c>J3</c> position output.
        /// </summary>
        /// <remarks>
        /// PWM output <c>J3PWM</c> controls the servo position.
        /// <br/>
        /// <br/>
        /// <c>J3</c> cannot be used for servo control if the Remote I/O
        /// Protocol Server program is running on an Orange Pi Zero 2W.
        /// </remarks>
        public const int J3PWM = PWM3;

        /// <summary>
        /// GPIO channel number for Grove Digital I/O Connector <c>J4</c> pin
        /// <c>D0</c>.
        /// </summary>
        public const int J4D0 = GPIO23;

        /// <summary>
        /// GPIO channel number for Grove Digital I/O Connector <c>J4</c> pin
        /// <c>D1</c>.
        /// </summary>
        public const int J4D1 = GPIO24;

        /// <summary>
        /// GPIO channel number for Grove Digital I/O Connector <c>J5</c> pin
        /// <c>D0</c>.
        /// </summary>
        public const int J5D0 = GPIO5;

        /// <summary>
        /// GPIO channel number for Grove Digital I/O Connector <c>J5</c> pin
        /// <c>D1</c>.
        /// </summary>
        public const int J5D1 = GPIO4;

        /// <summary>
        /// GPIO channel number for Grove DC Motor Driver Connector <c>J6</c>
        /// pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// <c>J6D0</c> normally cannot be configured because <c>GPIO12</c>
        /// is mapped to <c>PWM0</c>.
        /// </remarks>
        public const int J6D0 = GPIO12;

        /// <summary>
        /// GPIO channel number for Grove DC Motor Driver Connector <c>J6</c>
        /// pin <c>D1</c>.
        /// </summary>
        public const int J6D1 = GPIO13;

        /// <summary>
        /// Grove DC Motor Driver Connector <c>J6</c> speed output.
        /// </summary>
        /// <remarks>
        /// PWM output pin <c>J6PWM</c> controls the motor <b>speed</b>.
        /// </remarks>
        public const int J6PWM = PWM0;

        /// <summary>
        /// Grove DC Motor Driver Connector <c>J6</c> direction output.
        /// </summary>
        /// <remarks>
        /// GPIO output pin <c>J6DIR</c> controls the motor <b>direction</b>.
        /// </remarks>
        public const int J6DIR = GPIO13;

        /// <summary>
        /// GPIO channel number for Grove DC Motor Driver Connector <c>J7</c>
        /// pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// <c>J7D0</c> normally cannot be configured because <c>GPIO19</c>
        /// is mapped to <c>PWM1</c>.
        /// </remarks>
        public const int J7D0 = GPIO19;

        /// <summary>
        /// GPIO channel number for Grove DC Motor Driver Connector <c>J7</c>
        /// pin <c>D1</c>.
        /// </summary>
        public const int J7D1 = GPIO18;

        /// <summary>
        /// Grove DC Motor Driver Connector <c>J7</c> speed output.
        /// </summary>
        /// <remarks>
        /// PWM output pin <c>J7PWM</c> controls the motor <b>speed</b>.
        /// <br/>
        /// <br/>
        /// <c>J7</c> cannot be used for DC motor control if the Remote I/O
        /// Protocol Server program is running on an Orange Pi Zero 2W.
        /// </remarks>
        public const int J7PWM = PWM3;

        /// <summary>
        /// Grove DC Motor Driver Connector <c>J7</c> direction output.
        /// </summary>
        /// <remarks>
        /// GPIO output pin <c>J7DIR</c> controls the motor <b>direction</b>.
        /// <br/>
        /// <br/>
        /// <c>J7</c> cannot be used for DC motor control if the Remote I/O
        /// Protocol Server program is running on an Orange Pi Zero 2W.
        /// </remarks>
        public const int J7DIR = GPIO18;

        /// <summary>
        /// I<sup>2</sup>C bus channel number for Grove I<sup>2</sup>C Connector <c>J9</c>.
        /// </summary>
        public const int J9I2C = I2C1;

        /// <summary>
        /// Analog input channel number for Grove Analog Input Connector
        /// <c>J10</c> pin <c>A0</c> (MCP3204 input <c>CH2</c>).
        /// </summary>
        public const int J10A0 = 2;

        /// <summary>
        /// Analog input channel number for Grove Analog Input Connector
        /// <c>J10</c> pin <c>A1</c> (MCP3204 input <c>CH3</c>).
        /// </summary>
        public const int J10A1 = 3;

        /// <summary>
        /// Analog input channel number for Grove Analog Input Connector
        /// <c>J11</c> pin <c>A0</c> (MCP3204 input <c>CH0</c>).
        /// </summary>
        public const int J11A0 = 0;

        /// <summary>
        /// Analog input channel number for Grove Analog Input Connector
        /// <c>J11</c> pin <c>A1</c> (MCP3204 input <c>CH1</c>).
        /// </summary>
        public const int J11A1 = 1;

        // Create lists of valid designators, to be used for error checking
        // in the factory functions below.

        private static readonly System.Collections.Generic.List<int> ValidAnalogInputs =
            new System.Collections.Generic.List<int>(new[] { J10A0, J10A1, J11A0, J11A1 });

        private static readonly System.Collections.Generic.List<int> ValidGPIOPins =
            new System.Collections.Generic.List<int>(new[] { J4D0, J4D1, J5D0, J5D1, J6D0, J6D1, J7D0, J7D1 });

        private static readonly System.Collections.Generic.List<int> ValidMotorSpeedOutputs =
            new System.Collections.Generic.List<int>(new[] { J6PWM, J7PWM });

        private static readonly System.Collections.Generic.List<int> ValidMotorDirectionOutputs =
            new System.Collections.Generic.List<int>(new[] { J6DIR, J7DIR });

        private static readonly System.Collections.Generic.List<int> ValidServoOutputs =
            new System.Collections.Generic.List<int>(new[] { J2PWM, J3PWM });

        private static readonly IO.Objects.RemoteIO.Device remdev = new IO.Objects.RemoteIO.Device();

        /// <summary>
        /// Property returning a handle to the Remote I/O Server.
        /// </summary>
        public static IO.Objects.RemoteIO.Device server
        {
            get { return remdev; }
        }

        /// <summary>
        /// Analog input object factory for the on-board analog inputs at
        /// connectors <c>J10</c> and <c>J11</c>.
        /// </summary>
        /// <param name="desg">Device designator for one of the on-board
        /// analog inputs (<c>J10A0</c>, <c>J10A1</c>, <c>J11A0</c>, or
        /// <c>J11A1</c>).</param>
        /// <returns>Analog input object.</returns>
        public static IO.Interfaces.ADC.Voltage AnalogInputFactory(int desg)
        {
            // Validate analog input designator

            if (!ValidAnalogInputs.Contains(desg))
            {
                throw new System.ArgumentException("Invalid analog input designator.");
            }

            // Return analog input instance

            return new IO.Interfaces.ADC.Input(remdev.ADC_Create(desg), 3.3);
        }

        /// <summary>
        /// GPIO pin object factory for the on-board button switch at <c>SW1</c>.
        /// </summary>
        /// <returns>GPIO input pin object.</returns>
        public static IO.Interfaces.GPIO.Pin ButtonInputFactory()
        {
            // Return GPIO pin instance

            return remdev.GPIO_Create(SW1, IO.Interfaces.GPIO.Direction.Input);
        }

        /// <summary>
        /// GPIO pin object factory for the on-board LED at <c>D1</c>.
        /// </summary>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO output pin object.</returns>
        public static IO.Interfaces.GPIO.Pin LEDOutputFactory(bool state = false)
        {
            // Return GPIO pin instance

            return remdev.GPIO_Create(LED1, IO.Interfaces.GPIO.Direction.Output, state);
        }

        /// <summary>
        /// GPIO pin object factory for GPIO pins at connectors <c>J4</c> to
        /// <c>J7</c>.
        /// </summary>
        /// <param name="desg">Device designator for one of the on-board GPIO
        /// pins (<c>J4D0</c> to <c>J7D1</c>.</param>
        /// <param name="dir">Data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO pin object.</returns>
        public static IO.Interfaces.GPIO.Pin GPIOPinFactory(int desg,
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            // Validate the GPIO pin designator

            if (!ValidGPIOPins.Contains(desg))
            {
                throw new System.ArgumentException("Invalid GPIO pin designator.");
            }

            // Return GPIO pin instance

            return remdev.GPIO_Create(LED1, dir, state);
        }

        /// <summary>
        /// I<sup>2</sup>C bus object factory for the on-board I<sup>2</sup>C
        /// bus at connector <c>J9</c>.
        /// </summary>
        /// <returns>I<sup>2</sup>C bus object.</returns>
        public static IO.Interfaces.I2C.Bus I2CBusFactory()
        {
            return remdev.I2C_Create(J9I2C);
        }

        /// <summary>
        /// Motor output object factory for the on-board motor outputs
        /// at connectors <c>J6</c> and <c>J7</c>.
        /// </summary>
        /// <param name="speed">Device designator for the motor speed PWM
        /// output (<c>J6PWM</c> or <c>J7PWM</c>).</param>
        /// <param name="direction">Device designator for the motor direction
        /// GPIO output (<c>J6DIR</c> or <c>J7DIR</c>).</param>
        /// <param name="frequency">PWM pulse frequency.</param>
        /// <param name="velocity">Initial motor velocity.</param>
        /// <returns>Motor output object.</returns>
        public static IO.Interfaces.Motor.Output MotorOutputFactory(int speed,
            int direction, int frequency, double velocity = 0.0)
        {
            // Validate the PWM output designator

            if (!ValidMotorSpeedOutputs.Contains(speed))
            {
                throw new System.ArgumentException("Invalid PWM output designator.");
            }

            // Validate the GPIO output designator

            if (!ValidMotorDirectionOutputs.Contains(direction))
            {
                throw new System.ArgumentException("Invalid GPIO output designator.");
            }

            IO.Interfaces.PWM.Output S = remdev.PWM_Create(speed, frequency);

            IO.Interfaces.GPIO.Pin D = remdev.GPIO_Create(direction,
                IO.Interfaces.GPIO.Direction.Output);

            return new IO.Objects.Motor.PWM.Output(D, S, velocity);
        }

        /// <summary>
        /// Servo output object factory for the on-board servo outputs
        /// at headers <c>J2</c> and <c>J3</c>.
        /// </summary>
        /// <param name="desg">Device designator for one of the on-board
        /// PWM outputs (<c>J2PWM</c> or <c>J3PWM</c>).</param>
        /// <param name="frequency">PWM pulse frequency.  Ordinary analog
        /// servos operate best at 50 Hz.</param>
        /// <param name="position">Initial servo position.</param>
        /// <returns>Servo output object.</returns>
        public static IO.Interfaces.Servo.Output ServoOutputFactory(int desg,
            int frequency = 50, double position = IO.Interfaces.Servo.Positions.Neutral)
        {
            // Validate the servo output designator

            if (!ValidServoOutputs.Contains(desg))
            {
                throw new System.ArgumentException("Invalid servo output designator.");
            }

            // Return servo output instance

            return new IO.Objects.Servo.PWM.Output(remdev.PWM_Create(desg, frequency), frequency, position);
        }
    }
}
