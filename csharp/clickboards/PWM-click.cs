namespace IO.Devices.ClickBoards.PWM
{
    /// <summary>
    /// Encapsulates the Mikroelektronika PWM Click Board
    /// <a href="https://www.mikroe.com/pwm-click">MIKROE-1898</a>.
    /// </summary>
    public class Board
    {
        /// <summary>
        /// Default I<sup>2</sup>C slave address.
        /// </summary>
        public const byte DefaultAddress = 0x40;

        private readonly IO.Devices.PCA9685.Device mydev;

        /// <summary>
        /// Constructor for a single PWM click board.
        /// </summary>
        /// <remarks>
        /// You can use this constructor if the I<sup>2</sup>C bus will not be
        /// shared with any other slave devices.
        /// </remarks>
        /// <param name="socknum">mikroBUS socket number.</param>
        /// <param name="freq">PWM pulse frequency in Hz.</param>
        /// <param name="addr">PCA9685 I<sup>2</sup>C slave address.</param>
        public Board(int socknum, int freq, int addr = DefaultAddress)
        {
            IO.Objects.libsimpleio.mikroBUS.Socket S =
                new IO.Objects.libsimpleio.mikroBUS.Socket(socknum);

            mydev =
                new IO.Devices.PCA9685.Device(new IO.Objects.libsimpleio.I2C.Bus(S.I2C),
                addr, freq);
        }

        /// <summary>
        /// Constructor for a single PWM click board.
        /// </summary>
        /// <remarks>
        /// You must use this constructor if the I<sup>2</sup>C bus will be
        /// shared with any other slave devices.
        /// </remarks>
        /// <param name="bus">I<sup>2</sup>C bus object.</param>
        /// <param name="freq">PWM pulse frequency in Hz.</param>
        /// <param name="addr">PCA9685 I<sup>2</sup>C slave address.</param>
        public Board(IO.Interfaces.I2C.Bus bus, int freq, int addr = DefaultAddress)
        {
            mydev = new IO.Devices.PCA9685.Device(bus, addr, freq);
        }

        /// <summary>
        /// Returns the underlying PCA9685 device object for this PWM Click Board.
        /// </summary>
        public IO.Devices.PCA9685.Device dev
        {
            get
            {
                return mydev;
            }
        }

        /// <summary>
        /// Factory function for creating PCA9685 GPIO output pins.
        /// </summary>
        /// <param name="channel">PCA9685 output channel number.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO output pin object.</returns>
        public IO.Interfaces.GPIO.Pin GPIO(int channel, bool state = false)
        {
            return new IO.Devices.PCA9685.GPIO.Pin(mydev, channel, state);
        }

        /// <summary>
        /// Factory function for creating PCA9685 PWM outputs.
        /// </summary>
        /// <param name="channel">PCA9685 output channel number.</param>
        /// <param name="dutycycle">Initial PWM output dutycycle.</param>
        /// <returns>PWM output object.</returns>
        public IO.Interfaces.PWM.Output PWM(int channel,
            double dutycycle = IO.Interfaces.PWM.DutyCycles.Minimum)
        {
            return new IO.Devices.PCA9685.PWM.Output(mydev, channel, dutycycle);
        }

        /// <summary>
        /// Factory function for creating PCA9685 servo outputs.
        /// </summary>
        /// <param name="channel">PCA9685 output channel number.</param>
        /// <param name="position">Initial servo position.></param>
        /// <returns>Servo output object.</returns>
        public IO.Interfaces.Servo.Output Servo(int channel,
            double position = IO.Interfaces.Servo.Positions.Neutral)
        {
            return new IO.Objects.Servo.PWM.Output(PWM(channel),
                mydev.Frequency, position);
        }
    }
}
