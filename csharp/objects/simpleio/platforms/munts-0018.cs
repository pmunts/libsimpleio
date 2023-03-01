// MUNTS-0018 Tutoral Board Definitions

// Copyright (C)2021-2023, Philip Munts.
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

using IO.Objects.SimpleIO.Device;
using static IO.Objects.SimpleIO.GPIO.Pin;
using static IO.Objects.SimpleIO.Platforms.RaspberryPi;

namespace IO.Objects.SimpleIO.Platforms
{
    /// <summary>
    /// This class provides <c>Designator</c>s for I/O resources available on the
    /// <a href="http://tech.munts.com/manuals/MUNTS-0018.pdf">MUNTS-0018</a>
    /// Tutorial I/O Board.
    /// </summary>
    /// <remarks>
    /// The following device tree overlay commands must be added to
    /// <c>/boot/config.txt</c>:
    /// <code>
    /// dtoverlay=anyspi,spi0-1,dev="microchip,mcp3204",speed=1000000
    /// dtoverlay=pwm-2chan,pin=12,func=4,pin2=19,func2=2
    /// </code>
    /// </remarks>
    public static class MUNTS_0018
    {
        // On board LED

        /// <summary>
        /// GPIO pin <c>Designator</c> for the on-board LED <c>D1</c>.
        /// </summary>
        public static readonly Designator D1 = GPIO26;

        // On board pushbutton switch

        /// <summary>
        /// GPIO pin <c>Designator</c> for the on-board momentary switch
        /// <c>SW1</c>.
        /// </summary>
        public static readonly Designator SW1 = GPIO6;

        // Grove GPIO Connectors

        /// <summary>
        /// GPIO pin <c>Designator</c> for Digital I/O Grove Connector
        /// <c>J4</c> pin <c>D0</c>.
        /// </summary>
        public static readonly Designator J4D0 = GPIO23;
        /// <summary>
        /// GPIO pin <c>Designator</c> for Digital I/O Grove Connector
        /// <c>J4</c> pin <c>D1</c>.
        /// </summary>
        public static readonly Designator J4D1 = GPIO24;

        /// <summary>
        /// GPIO pin <c>Designator</c> for Digital I/O Grove Connector
        /// <c>J5</c> pin <c>D0</c>.
        /// </summary>
        public static readonly Designator J5D0 = GPIO5;
        /// <summary>
        /// GPIO pin <c>Designator</c> for Digital I/O Grove Connector
        /// <c>J5</c> pin <c>D1</c>.
        /// </summary>
        public static readonly Designator J5D1 = GPIO4;

        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J6</c> pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO pin is normally unusable because <c>GPIO12</c> is
        /// mapped to PWM output <c>PWM0</c>.
        /// </remarks>
        public static readonly Designator J6D0 = GPIO12;
        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J6</c> pin <c>D1</c>.
        /// </summary>
        public static readonly Designator J6D1 = GPIO13;

        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J7</c> pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// This GPIO pin is normally unusable because <c>GPIO19</c> is
        /// mapped to PWM output <c>PWM1</c>.
        /// </remarks>
        public static readonly Designator J7D0 = GPIO19;
        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J7</c> pin <c>D1</c>.
        /// </summary>
        public static readonly Designator J7D1 = GPIO18;

        // Servo headers

        /// <summary>
        /// PWM output <c>Designator</c> for Servo Header <c>J2</c>.
        /// </summary>
        public static readonly Designator J2PWM = PWM0_0;
        /// <summary>
        /// PWM output <c>Designator</c> for Servo Header <c>J3</c>.
        /// </summary>
        public static readonly Designator J3PWM = PWM0_1;

        // DC motor control outputs (PWM and direction)

        /// <summary>
        /// PWM output <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J6</c> pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// <c>J6PWM</c> controls the motor <b>speed</b>.
        /// </remarks>
        public static readonly Designator J6PWM = PWM0_0;
        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J6</c> pin <c>D1</c>.
        /// </summary>
        /// <remarks>
        /// <c>J6DIR</c> controls the motor <b>direction</b>.
        /// </remarks>
        public static readonly Designator J6DIR = J6D1;

        /// <summary>
        /// PWM output <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J7</c> pin <c>D0</c>.
        /// </summary>
        /// <remarks>
        /// <c>J7PWM</c> controls the motor <b>speed</b>.
        /// </remarks>
        public static readonly Designator J7PWM = PWM0_1;
        /// <summary>
        /// GPIO pin <c>Designator</c> for DC Motor Driver Grove Connector
        /// <c>J7</c> pin <c>D1</c>.
        /// </summary>
        /// <remarks>
        /// <c>J7DIR</c> controls the motor <b>direction</b>.
        /// </remarks>
        public static readonly Designator J7DIR = J7D1;

        // I2C buses

        /// <summary>
        /// I<sup>2</sup>C bus <c>Designator</c> for <c>/dev/i2c3</c>
        /// on Digital I/O Grove Connector <c>J5</c>.
        /// </summary>
        /// <remarks>
        /// This optional I<sup>2</sup>C bus is only available on a Raspberry
        /// Pi 4, and only if the following is added to <c>/boot/config.txt</c>:
        /// <code>
        /// dtoverlay=i2c3
        /// </code>
        /// You may also need to install I<sup>2</sup>C bus 4.7K or 10K pull-up
        /// resistors on the MUNTS-0018 Tutorial I/O Board, at positions
        /// <c>R5</c> and <c>R6</c>.
        /// </remarks>
        public static readonly Designator J5I2C = I2C3;
        /// <summary>
        /// I<sup>2</sup>C bus <c>Designator</c> for <c>/dev/i2c-1</c>
        /// on I<sup>2</sup>C Grove Connector <c>J9</c>.
        /// </summary>
        public static readonly Designator J9I2C = I2C1;

        // Analog inputs (on board MCP3204)

        /// <summary>
        /// Analog input <c>Designator</c> for Analog Input Grove Connector
        /// <c>J10</c> pin <c>A0</c> (MCP3204 input <c>CH2</c>.
        /// </summary>
        public static readonly Designator J10A0 = new Designator(0, 2);
        /// <summary>
        /// Analog input <c>Designator</c> for Analog Input Grove Connector
        /// <c>J10</c> pin <c>A1</c> (MCP3204 input <c>CH3</c>.
        /// </summary>
        public static readonly Designator J10A1 = new Designator(0, 3);

        /// <summary>
        /// Analog input <c>Designator</c> for Analog Input Grove Connector
        /// <c>J11</c> pin <c>A0</c> (MCP3204 input <c>CH0</c>.
        /// </summary>
        public static readonly Designator J11A0 = new Designator(0, 0);
        /// <summary>
        /// Analog input <c>Designator</c> for Analog Input Grove Connector
        /// <c>J11</c> pin <c>A1</c> (MCP3204 input <c>CH1</c>.
        /// </summary>
        public static readonly Designator J11A1 = new Designator(0, 1);

        /// <summary>
        /// Analog input factory for the on-board analog inputs at <c>J10</c>
        /// and <c>J11</c>.
        /// </summary>
        /// <param name="desg">Device designator for one of the on-board
        /// analog inputs (<c>J10A0</c>, <c>J10A1</c>, <c>J11A0</c>, or
        /// <c>J11A1</c>).</param>
        /// <returns>Analog input object.</returns>
        public static IO.Interfaces.ADC.Voltage AnalogInputFactory(Designator desg)
        {
            return new IO.Interfaces.ADC.Input(new IO.Objects.SimpleIO.ADC.Sample(desg, 12), 3.3);
        }

        /// <summary>
        /// GPIO pin object factory for the on-board button switch at <c>SW1</c>.
        /// </summary>
        /// <param name="edge">Interrupt edge setting.</param>
        /// <returns>GPIO input pin object.</returns>
        public static IO.Interfaces.GPIO.Pin ButtonInputFactory(IO.Objects.SimpleIO.GPIO.Pin.Edge edge = IO.Objects.SimpleIO.GPIO.Pin.Edge.None)
        {
            return new IO.Objects.SimpleIO.GPIO.Pin(SW1, IO.Interfaces.GPIO.Direction.Input, false, IO.Objects.SimpleIO.GPIO.Pin.Driver.PushPull, edge);
        }

        /// <summary>
        /// GPIO pin factory for the on-board LED at <c>D1</c>.
        /// </summary>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO output pin object.</returns>
        public static IO.Interfaces.GPIO.Pin LEDOutputFactory(bool state = false)
        {
            return new IO.Objects.SimpleIO.GPIO.Pin(D1, IO.Interfaces.GPIO.Direction.Output, state);
        }

        /// <summary>
        /// GPIO pin factory for GPIO pins at <c>J4</c> to <c>J6</c>.
        /// </summary>
        /// <param name="desg">Device designator for one of the on-board GPIO
        /// pins (<c>J4D0</c> to <c>J7D1</c>.</param>
        /// <param name="dir">Data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <param name="driver">Output driver setting.</param>
        /// <param name="edge">Interrupt edge setting.</param>
        /// <param name="polarity">Polarity setting.</param>
        /// <returns>GPIO pin object.</returns>
        public static IO.Interfaces.GPIO.Pin GPIOPinFactory(Designator desg,
            IO.Interfaces.GPIO.Direction dir, bool state = false,
            Driver driver = Driver.PushPull, Edge edge = Edge.None,
            Polarity polarity = Polarity.ActiveHigh)
        {
            return new IO.Objects.SimpleIO.GPIO.Pin(desg, dir, state, driver, edge, polarity);
        }

        /// <summary>
        /// I<sup>2</sup>C bus object factory for the on-board I<sup>2</sup>C
        /// buses at <c>J5</c> and <c>J9</c>.
        /// </summary>
        /// <param name="desg">Device designator for one of the on-board
        /// I<sup>2</sup>C buses (<c>J5I2C</c> or <c>J9I2C</c>).</param>
        /// <returns>I<sup>2</sup>C bus object.</returns>
        public static IO.Interfaces.I2C.Bus I2CBusFactory(Designator desg)
        {
            return new IO.Objects.SimpleIO.I2C.Bus(desg);
        }

        /// <summary>
        /// Motor output object factory for the on-board motor outputs
        /// at <c>J6</c> and <c>J7</c>.
        /// </summary>
        /// <param name="speed">Device designator for the motor speed PWM
        /// output (<c>J6PWM</c> or <c>J7PWM</c>).</param>
        /// <param name="direction">Device designator for the motor direction
        /// GPIO output (<c>J6DIR</c> or <c>J7DIR</c>).</param>
        /// <param name="frequency">PWM pulse frequency.</param>
        /// <param name="velocity">Initial motor velocity.</param>
        /// <returns>Motor output object.</returns>
        public static IO.Interfaces.Motor.Output MotorOutputFactory(Designator speed,
            Designator direction, int frequency, double velocity = 0.0)
        {
            IO.Interfaces.PWM.Output S = new IO.Objects.SimpleIO.PWM.Output(speed, frequency);
            IO.Interfaces.GPIO.Pin D = new IO.Objects.SimpleIO.GPIO.Pin(direction, IO.Interfaces.GPIO.Direction.Output);

            return new IO.Objects.Motor.PWM.Output(D, S, velocity);
        }

        /// <summary>
        /// Servo output object factory for the on-board servo outputs
        /// at <c>J2</c> and <c>J3</c>.
        /// </summary>
        /// <param name="desg">Device designator for one of the on-board
        /// PWM outputs (<c>J2PWM</c> or <c>J3PWM</c>).</param>
        /// <param name="frequency">PWM pulse frequency.  Ordinary analog
        /// servos operate best at 50 Hz.</param>
        /// <returns>Servo output object.</returns>
        public static IO.Interfaces.Servo.Output ServoOutputFactory(Designator desg, int frequency = 50)
        {
            return new IO.Objects.SimpleIO.Servo.Output(desg, frequency);
        }
    }
}