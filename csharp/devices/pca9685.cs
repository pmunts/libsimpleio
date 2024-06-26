// Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

namespace IO.Devices.PCA9685
{
  /// <summary>
  /// Encapsulates the PCA9685 I<sup>2</sup>C PWM Controller.
  /// </summary>
  public class Device
  {
    /// <summary>
    /// Minimum clock frequency.
    /// </summary>
    public const int MIN_CLOCK = 1;

    /// <summary>
    /// Maximum clock frequency.
    /// </summary>
    public const int MAX_CLOCK = 50000000;

    /// <summary>
    /// Select internal 25 MHz clock oscillator.
    /// </summary>
    public const int INTERNAL_CLOCK = 0;

    /// <summary>
    /// Minimum PCA9685 output channel number.
    /// </summary>
    public const int MIN_CHANNEL = 0;

    /// <summary>
    /// Maximum PCA9685 output channel number.
    /// </summary>
    public const int MAX_CHANNEL = 15;

    private enum Registers
    {
      MODE1 = 0,
      MODE2 = 1,
      SUBADR1 = 2,
      SUBADR2 = 3,
      SUBADR3 = 4,
      ALLCALLADR = 5,
      LED0_ON_L = 6,
      LED0_ON_H = 7,
      LED0_OFF_L = 8,
      LED0_OFF_H = 9,
      LED1_ON_L = 10,
      LED1_ON_H = 11,
      LED1_OFF_L = 12,
      LED1_OFF_H = 13,
      LED2_ON_L = 14,
      LED2_ON_H = 15,
      LED2_OFF_L = 16,
      LED2_OFF_H = 17,
      LED3_ON_L = 18,
      LED3_ON_H = 19,
      LED3_OFF_L = 20,
      LED3_OFF_H = 21,
      LED4_ON_L = 22,
      LED4_ON_H = 23,
      LED4_OFF_L = 24,
      LED4_OFF_H = 25,
      LED5_ON_L = 26,
      LED5_ON_H = 27,
      LED5_OFF_L = 28,
      LED5_OFF_H = 29,
      LED6_ON_L = 30,
      LED6_ON_H = 31,
      LED6_OFF_L = 32,
      LED6_OFF_H = 33,
      LED7_ON_L = 34,
      LED7_ON_H = 35,
      LED7_OFF_L = 36,
      LED7_OFF_H = 37,
      LED8_ON_L = 38,
      LED8_ON_H = 39,
      LED8_OFF_L = 40,
      LED8_OFF_H = 41,
      LED9_ON_L = 42,
      LED9_ON_H = 43,
      LED9_OFF_L = 44,
      LED9_OFF_H = 45,
      LED10_ON_L = 46,
      LED10_ON_H = 47,
      LED10_OFF_L = 48,
      LED10_OFF_H = 49,
      LED11_ON_L = 50,
      LED11_ON_H = 51,
      LED11_OFF_L = 52,
      LED11_OFF_H = 53,
      LED12_ON_L = 54,
      LED12_ON_H = 55,
      LED12_OFF_L = 56,
      LED12_OFF_H = 57,
      LED13_ON_L = 58,
      LED13_ON_H = 59,
      LED13_OFF_L = 60,
      LED13_OFF_H = 61,
      LED14_ON_L = 62,
      LED14_ON_H = 63,
      LED14_OFF_L = 64,
      LED14_OFF_H = 65,
      LED15_ON_L = 66,
      LED15_ON_H = 67,
      LED15_OFF_L = 68,
      LED15_OFF_H = 69,
      ALL_LED_ON_L = 250,
      ALL_LED_ON_H = 251,
      ALL_LED_OFF_L = 252,
      ALL_LED_OFF_H = 253,
      PRE_SCALE = 254,
      TESTMODE = 255
    }

    private readonly IO.Interfaces.I2C.Device dev;
    private readonly int freq;
    private byte[] cmd;
    private byte[] resp;

    /// <summary>
    /// Constructor for a single PCA9685 device.
    /// </summary>
    /// <param name="bus">I<sup>2</sup>C bus controller object.</param>
    /// <param name="addr">I<sup>2</sup>C slave address.</param>
    /// <param name="freq">PWM pulse frequency.  Default is 50 Hz.</param>
    /// <param name="clock">PCA9685 clock source.
    /// Use <c>INTERNAL_CLOCK</c>c> to select the internal 25 MHz clock generator.
    /// </param>
    public Device(IO.Interfaces.I2C.Bus bus, int addr, int freq = 50,
      int clock = INTERNAL_CLOCK)
    {
      // Validate parameters

      if (freq < 1)
        throw new System.Exception("Invalid PWM pulse frequency");

      if ((clock != INTERNAL_CLOCK) && ((clock < MIN_CLOCK) || (clock > MAX_CLOCK)))
        throw new System.Exception("Invalid clock frequency");

      dev = new IO.Interfaces.I2C.Device(bus, addr);
      this.freq = freq;
      cmd = new byte[5];
      resp = new byte[4];

      if (clock == INTERNAL_CLOCK)
      {
        // Use internal 25 MHz clock
        WriteRegister((byte)Registers.MODE1, 0x30); // Set SLEEP
        WriteRegister((byte)Registers.PRE_SCALE, (byte)(25000000 / 4096 / freq - 1));
        WriteRegister((byte)Registers.MODE1, 0x20); // Clear SLEEP
      }
      else
      {
        // Use external clock
        WriteRegister((byte)Registers.MODE1, 0x70); // Set SLEEP
        WriteRegister((byte)Registers.PRE_SCALE, (byte)(clock / 4096 / freq - 1));
        WriteRegister((byte)Registers.MODE1, 0x60); // Clear SLEEP
      }

      WriteRegister((byte)Registers.MODE2, 0x0C);
    }

    private void ReadRegister(byte addr, ref byte data)
    {
      cmd[0] = addr;
      dev.Transaction(cmd, 1, resp, 1);
      data = resp[0];
    }

    private void WriteRegister(byte addr, byte data)
    {
      cmd[0] = addr;
      cmd[1] = data;
      dev.Write(cmd, 2);
    }

    /// <summary>
    /// Read PCA9685 output channel data.
    /// </summary>
    /// <param name="channel">Output channel number.</param>
    /// <param name="data">Output channel data (4 bytes).</param>
    public void ReadChannel(byte channel, ref byte[] data)
    {
      if (channel > MAX_CHANNEL)
        throw new System.Exception("Invalid channel number");

      cmd[0] = System.Convert.ToByte((int)Registers.LED0_ON_L + channel * 4);
      dev.Transaction(cmd, 1, resp, 4);

      data[0] = resp[0];
      data[1] = resp[1];
      data[2] = resp[2];
      data[3] = resp[3];
    }

    /// <summary>
    /// Write PCA9685 output channel data.
    /// </summary>
    /// <param name="channel">Output channel number.</param>
    /// <param name="data">Output channel data.</param>
    public void WriteChannel(byte channel, byte[] data)
    {
      if (channel > MAX_CHANNEL)
        throw new System.Exception("Invalid channel number");

      cmd[0] = System.Convert.ToByte((int)Registers.LED0_ON_L + channel * 4);
      cmd[1] = data[0];
      cmd[2] = data[1];
      cmd[3] = data[2];
      cmd[4] = data[3];

      dev.Write(cmd, 5);
    }

    /// <summary>
    /// Read-only property returning the configured PWM pulse frequency.
    /// </summary>
    public int Frequency
    {
      get
      {
        return this.freq;
      }
    }
  }
}