// Raspberry Pi LPC1114 I/O Processor Expansion Board SPI Agent Firmware
// Pulse Width Modulator output services

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
    /// The PWM (Pulse With Modulation) class implements LPC1114 PWM output services.
    /// </summary>
    public class PWM: IO.Interfaces.PWM.Output
    {
        /// <summary>
        /// The number of available PWM output channels.
        /// </summary>
        public const int MIN_CHANNELS = 4;

        /// <summary>
        /// The minimum allowed PWM frequency is 50 Hz.
        /// </summary>
        public const int MIN_FREQUENCY = 50;		// Hertz

        /// <summary>
        /// The maximum allowed PWM frequency is 50,000 Hz.
        /// </summary>
        public const int MAX_FREQUENCY = 50000;		// Hertz

        /// <summary>
        /// The minimum allowed PWM duty cycle is 0.0 percent.
        /// </summary>
        public const double MIN_DUTYCYCLE = 0.0F;	// Percent

        /// <summary>
        /// The maximum allowed PWM duty cycle is 100.0 percent.
        /// </summary>
        public const double MAX_DUTYCYCLE = 100.0F;	// Percent

        private ITransport mytransport;
        private int mypin;
        private SPIAGENT_COMMAND_MSG_t cmd;
        private SPIAGENT_RESPONSE_MSG_t resp;

        /// <summary>
        /// LPC1114 PWM output object constructor.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="pin">LPC1114 PWM output pin number.
        /// Allowed values are LPC1114_PWM1 through LPC1114_PWM4.</param>
        /// <param name="frequency">PWM pulse frequency.
        /// Allowed values are 50 to 50000 Hz.</param>
        public PWM(ITransport spiagent, int pin, int frequency = 100)
        {
            // Validate parameters

            if (spiagent == null)
            {
                throw new NullReferenceException("SPI Agent Firmware transport handle is null");
            }

            if (!Pins.IS_PWM(pin))
            {
                throw new ArgumentException("PWM pin number is invalid");
            }

            if (frequency < MIN_FREQUENCY)
            {
                throw new ArgumentException("PWM pulse frequency is invalid");
            }

            if (frequency > MAX_FREQUENCY)
            {
                throw new ArgumentException("PWM pulse frequency is invalid");
            }

            cmd = new SPIAGENT_COMMAND_MSG_t();
            resp = new SPIAGENT_RESPONSE_MSG_t();

            // Build the command message

            cmd.command = (int)Commands.SPIAGENT_CMD_CONFIGURE_PWM_OUTPUT;
            cmd.pin = pin;
            cmd.data = frequency;

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
        /// This write-only property sets this PWM output's duty cycle.
        /// Allowed values are 0.0 through 100.0 percent (from almost always off to almost always on).
        /// </summary>
        public double dutycycle
        {
            set
            {
                // Validate parameters

                if ((value < MIN_DUTYCYCLE) || (value > MAX_DUTYCYCLE))
                {
                    throw new ArgumentException("Invalid duty cycle value");
                }

                // Build the command message

                cmd.command = (int)Commands.SPIAGENT_CMD_PUT_PWM;
                cmd.pin = mypin;
                cmd.data = (int)Math.Round(655.35F * value);

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

    /// <summary>
    /// The Servo class implements LPC1114 RC servo output services.
    /// </summary>
    public class Servo : PWM, IO.Interfaces.Servo.Output
    {
        private int freq = 50;

        /// <summary>
        /// The minimum servo position is -1.0.
        /// </summary>
        public const double SERVO_MIN_POSITION = -1.0F;

        /// <summary>
        /// The midpoint/neutral/null/zero servo position is 0.0.
        /// </summary>
        public const double SERVO_NEUTRAL_POSITION = 1.0F;

        /// <summary>
        /// The maximum servo position is 1.0.
        /// </summary>
        public const double SERVO_MAX_POSITION = 1.0F;

        /// <summary>
        /// LPC1114 RC servo output object constructor.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="pin">LPC1114 PWM output pin number.
        /// Allowed values are LPC1114_PWM1 through LPC1114_PWM4.</param>
        /// <param name="frequency">PWM pulse frequency.
        /// Allowed values are 50 to 400 Hz.</param>
        public Servo(ITransport spiagent, int pin, int frequency = 50) : base(spiagent, pin, frequency)
        {
            // Check the PWM frequency

            if (frequency > 400)
            {
                throw new ArgumentException("PWM frequency is too high for servos");
            }

            freq = frequency;

            // Move servo to the neutral position

            position = SERVO_NEUTRAL_POSITION;
        }

        /// <summary>
        /// This write-only property sets this servo output's position.
        /// Allowed values are -1.0 through 1.0 (normalized deflection from the null position).
        /// </summary>
        public double position
        {
            set
            {
                // Validate parameters

                if ((value < SERVO_MIN_POSITION) || (value > SERVO_MAX_POSITION))
                {
                    throw new ArgumentException("Invalid servo position value");
                }

                dutycycle = (0.5E-1F * value + 1.5E-1F)*freq;
            }
        }
    }

    /// <summary>
    /// The Motor class implements LPC1114 H-bridge DC motor driver output services.
    /// </summary>
    public class Motor
    {
        /// <summary>
        /// The motor speed minimum value is -1.0 (full reverse).
        /// </summary>
        public const double MOTOR_MIN_SPEED = -1.0F;

        /// <summary>
        /// The motor speed stop value is 0.0.
        /// </summary>
        public const double MOTOR_STOP = 1.0F;

        /// <summary>
        /// The motor speed maximum value is 1.0 (full forward).
        /// </summary>
        public const double MOTOR_MAX_SPEED = 1.0F;

        private PWM pwmpin;
        private GPIO dirpin;

        /// <summary>
        /// LPC1114 H-bridge DC motor driver output object constructor.
        /// </summary>
        /// <param name="spiagent">SPI Agent Firmware transport object.</param>
        /// <param name="pwm_pin">LPC1114 PWM output pin number.
        /// Allowed values are LPC1114_PWM1 through LPC1114_PWM4.</param>
        /// <param name="dir_pin">LPC1114 direction output pin number.
        /// Allowed values are LPC1114_GPIO0 through LPC1114_GPIO7.</param>
        /// <param name="frequency">PWM pulse frequency.
        /// Allowed values are 50 to 50000 Hz.</param>
        public Motor(ITransport spiagent, int pwm_pin, int dir_pin, int frequency = 100)
        {
            // Validate parameters

            if (pwm_pin == dir_pin)
            {
                throw new ArgumentException("PWM and direction pins cannot be the same");
            }

            // Configure pins

            pwmpin = new PWM(spiagent, pwm_pin, frequency);
            dirpin = new GPIO(spiagent, dir_pin, GPIO.MODE.OUTPUT);

            // Stop motor

            speed = MOTOR_STOP;
        }

        /// <summary>
        /// This write-only property sets this motor speed.
        /// Allowed values are -1.0 through 1.0 (normalized speed).
        /// </summary>
        public double speed
        {
            set
            {
                // Validate parameters

                if ((value < MOTOR_MIN_SPEED) || (value > MOTOR_MAX_SPEED))
                {
                    throw new ArgumentException("Invalid motor speed value");
                }

                if (value < 0)
                {
                    dirpin.state = false;
                    pwmpin.dutycycle = -100.0F * value;
                }
                else
                {
                    dirpin.state = true;
                    pwmpin.dutycycle = 100.0F * value;
                }
            }
        }
    }
}
