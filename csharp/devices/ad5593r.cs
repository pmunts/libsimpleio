// AD5593R Analog/Digital I/O Device Services

// Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

namespace IO.Devices.AD5593R
{
    /// <summary>
    /// AD5593R I/O Pin Modes.
    /// </summary>
    public enum PinMode
    {
        /// <summary>
        /// Analog input.
        /// </summary>
        ADC_Input,
        /// <summary>
        /// Analog output.
        /// </summary>
        DAC_Output,
        /// <summary>
        /// GPIO input.
        /// </summary>
        GPIO_Input,
        /// <summary>
        /// GPIO output.
        /// </summary>
        GPIO_Output,
        /// <summary>
        /// GPIO open drain output.
        /// </summary>
        GPIO_Output_OpenDrain,
    }

    /// <summary>
    /// ADC5593R ADC and DAC reference settings.
    /// </summary>
    public enum ReferenceMode
    {
        /// <summary>
        /// The reference voltage is 2.5V using the internal reference.
        /// </summary>
        Internalx1,
        /// <summary>
        /// The reference voltage is 5.0V using the internal reference.
        /// </summary>
        Internalx2,
        /// <summary>
        /// The reference voltage is 1.0*Vref, using an external reference.
        /// </summary>
        Externalx1,
        /// <summary>
        /// The reference voltage is 2.0*Vref, using an external reference.
        /// </summary>
        Externalx2,
    }

    /// <summary>
    /// Enscapsulates the AD5593R I<sup>2</sup>C Analog/Digital I/O device.
    /// </summary>
    public class Device
    {
        // Pointer byte modes (high nibble)

        private const byte MODE_CONFIGURATION = 0x00;
        private const byte MODE_DAC_WRITE = 0x10;
        private const byte MODE_ADC_READBACK = 0x40;
        private const byte MODE_DAC_READBACK = 0x50;
        private const byte MODE_GPIO_READBACK = 0x60;
        private const byte MODE_REG_READBACK = 0x70;

        // Pointer byte register addresses (low nibble)

        private const byte REG_NOP = 0x00;
        private const byte REG_ADC_SEQ = 0x02;
        private const byte REG_CONTROL = 0x03;
        private const byte REG_ADC_PIN_CONFIG = 0x04;
        private const byte REG_DAC_PIN_CONFIG = 0x05;
        private const byte REG_PULLDOWN_CONFIG = 0x06;
        private const byte REG_LDAC_MODE = 0x07;
        private const byte REG_GPIO_WRITE_CONFIG = 0x08;
        private const byte REG_GPIO_WRITE_DATA = 0x09;
        private const byte REG_GPIO_READ_CONFIG = 0x0A;
        private const byte REG_POWERDOWN = 0x0B;
        private const byte REG_OPENDRAIN_CONFIG = 0x0C;
        private const byte REG_TRISTATE_CONFIG = 0x0D;
        private const byte REG_SOFTWARE_RESET = 0x0F;

        // Define some register mask constants

        private const uint MASK_ADC_RANGE = 0x0020;
        private const uint MASK_DAC_RANGE = 0x0010;
        private const uint MASK_EN_REF = 0x0200;

        // Preallocated I2C bus transaction buffers

        private byte[] inbuf = { 0, 0 };
        private byte[] outbuf = { 0, 0, 0 };

        private bool Internal(ReferenceMode x)
        {
            return (x >= ReferenceMode.Internalx1) && (x <= ReferenceMode.Internalx2);
        }
        private bool External(ReferenceMode x)
        {
            return (x >= ReferenceMode.Externalx1) && (x <= ReferenceMode.Externalx2);
        }

        // Read 16-bit value from a register
        private uint ReadRegister(byte mode, byte reg = 0)
        {
            outbuf[0] = (byte)(mode | reg);

            dev.Transaction(outbuf, 1, inbuf, 2);
            return (uint)((inbuf[0] << 8) | inbuf[1]);
        }

        // Write 16-bit value to a register
        private void WriteRegister(byte mode, byte reg, uint data)
        {
            outbuf[0] = (byte)(mode | reg);
            outbuf[1] = (byte)(data >> 8);
            outbuf[2] = (byte)data;

            dev.Write(outbuf, 3);
        }

        // I2C device handle

        private readonly IO.Interfaces.I2C.Device dev;

        // Shadow some AD5593R registers

        private uint reg_control = 0x0100;
        private uint reg_powerdown = 0x02FF;
        private uint reg_pin_config_adc = 0x00;
        private uint reg_pin_config_dac = 0x00;
        private uint reg_pin_config_gpio_read = 0x00;
        private uint reg_pin_config_gpio_write = 0x00;
        private uint reg_pin_config_pulldown = 0xFF;
        private uint reg_pin_config_opendrain = 0x00;
        private uint reg_pin_config_tristate = 0x00;
        private uint reg_gpio_write_data = 0x00;

        /// <summary>
        /// Minimum I/O channel number.
        /// </summary>
        public const int MinChannel = 0;

        /// <summary>
        /// Maximum I/O channel number.
        /// </summary>
        public const int MaxChannel = 7;

        /// <summary>
        /// ADC resolution in bits.
        /// </summary>
        public const int ADC_Resolution = 12;

        /// <summary>
        /// DAC resolution in bits.
        /// </summary>
        public const int DAC_Resolution = 12;

        /// <summary>
        /// Constructor for a single AD5593R device.
        /// </summary>
        /// <param name="bus">I<sup>2</sup>C bus controller object.</param>
        /// <param name="addr">I<sup>2</sup>C slave address.</param>
        public Device(IO.Interfaces.I2C.Bus bus, int addr)
        {
            // Create an I2C device object

            dev = new IO.Interfaces.I2C.Device(bus, addr);

            // Configure the ADC5593R.

            WriteRegister(MODE_CONFIGURATION, REG_CONTROL, reg_control);
            WriteRegister(MODE_CONFIGURATION, REG_POWERDOWN, reg_powerdown);
            WriteRegister(MODE_CONFIGURATION, REG_LDAC_MODE, 0x0000);
            WriteRegister(MODE_CONFIGURATION, REG_ADC_PIN_CONFIG, reg_pin_config_adc);
            WriteRegister(MODE_CONFIGURATION, REG_DAC_PIN_CONFIG, reg_pin_config_dac);
            WriteRegister(MODE_CONFIGURATION, REG_GPIO_READ_CONFIG, reg_pin_config_gpio_read);
            WriteRegister(MODE_CONFIGURATION, REG_GPIO_WRITE_CONFIG, reg_pin_config_gpio_write);
            WriteRegister(MODE_CONFIGURATION, REG_PULLDOWN_CONFIG, reg_pin_config_pulldown);
            WriteRegister(MODE_CONFIGURATION, REG_OPENDRAIN_CONFIG, reg_pin_config_opendrain);
            WriteRegister(MODE_CONFIGURATION, REG_TRISTATE_CONFIG, reg_pin_config_tristate);
            WriteRegister(MODE_CONFIGURATION, REG_GPIO_WRITE_DATA, reg_gpio_write_data);
        }

        /// <summary>
        /// Write-only property for setting the AD5593R ADC reference mode.
        /// </summary>
        public ReferenceMode ADC_Reference
        {
            set
            {
                switch (value)
                {
                    case ReferenceMode.Internalx1:
                        reg_control &= ~MASK_ADC_RANGE;
                        reg_powerdown |= MASK_EN_REF;
                        break;

                    case ReferenceMode.Internalx2:
                        reg_control |= MASK_ADC_RANGE;
                        reg_powerdown |= MASK_EN_REF;
                        break;

                    case ReferenceMode.Externalx1:
                        reg_control &= ~MASK_ADC_RANGE;
                        reg_powerdown &= ~MASK_EN_REF;
                        break;

                    case ReferenceMode.Externalx2:
                        reg_control |= MASK_ADC_RANGE;
                        reg_powerdown &= ~MASK_EN_REF;
                        break;
                }

                WriteRegister(MODE_CONFIGURATION, REG_CONTROL, reg_control);
                WriteRegister(MODE_CONFIGURATION, REG_POWERDOWN, reg_powerdown);
            }
        }

        /// <summary>
        /// Write-only property for setting the AD5593R DAC reference mode.
        /// </summary>
        public ReferenceMode DAC_Reference
        {
            set
            {
                switch (value)
                {
                    case ReferenceMode.Internalx1:
                        reg_control &= ~MASK_DAC_RANGE;
                        reg_powerdown |= MASK_EN_REF;
                        break;

                    case ReferenceMode.Internalx2:
                        reg_control |= MASK_DAC_RANGE;
                        reg_powerdown |= MASK_EN_REF;
                        break;

                    case ReferenceMode.Externalx1:
                        reg_control &= ~MASK_DAC_RANGE;
                        reg_powerdown &= ~MASK_EN_REF;
                        break;

                    case ReferenceMode.Externalx2:
                        reg_control |= MASK_DAC_RANGE;
                        reg_powerdown &= ~MASK_EN_REF;
                        break;
                }

                WriteRegister(MODE_CONFIGURATION, REG_CONTROL, reg_control);
                WriteRegister(MODE_CONFIGURATION, REG_POWERDOWN, reg_powerdown);
            }
        }

        /// <summary>
        /// Configure a single ADC5593R I/O pin.
        /// </summary>
        /// <param name="channel">ADC5593R I/O channel number (0 to 7).</param>
        /// <param name="mode">ADC5593R I/O pin mode.</param>
        public void ConfigureChannel(int channel, PinMode mode)
        {
            // Validate parameters

            if ((channel < MinChannel) || (channel > MaxChannel))
                throw new System.Exception("Invalid channel number.");

            uint mask = (uint)(1 << channel);

            switch (mode)
            {
                case PinMode.ADC_Input:
                    reg_pin_config_adc |= mask;
                    reg_pin_config_dac &= ~mask;
                    reg_pin_config_gpio_read &= ~mask;
                    reg_pin_config_gpio_write &= ~mask;
                    reg_pin_config_pulldown &= ~mask;
                    reg_pin_config_opendrain &= ~mask;
                    reg_pin_config_tristate &= ~mask;
                    reg_powerdown &= ~mask;
                    break;

                case PinMode.DAC_Output:
                    reg_pin_config_adc &= ~mask;
                    reg_pin_config_dac |= mask;
                    reg_pin_config_gpio_read &= ~mask;
                    reg_pin_config_gpio_write &= ~mask;
                    reg_pin_config_pulldown &= ~mask;
                    reg_pin_config_opendrain &= ~mask;
                    reg_pin_config_tristate &= ~mask;
                    reg_powerdown &= ~mask;
                    break;

                case PinMode.GPIO_Input:
                    reg_pin_config_adc &= ~mask;
                    reg_pin_config_dac &= ~mask;
                    reg_pin_config_gpio_read |= mask;
                    reg_pin_config_gpio_write &= ~mask;
                    reg_pin_config_pulldown &= ~mask;
                    reg_pin_config_opendrain &= ~mask;
                    reg_pin_config_tristate &= ~mask;
                    reg_powerdown &= ~mask;
                    break;

                case PinMode.GPIO_Output:
                    reg_pin_config_adc &= ~mask;
                    reg_pin_config_dac &= ~mask;
                    reg_pin_config_gpio_read &= ~mask;
                    reg_pin_config_gpio_write |= mask;
                    reg_pin_config_pulldown &= ~mask;
                    reg_pin_config_opendrain &= ~mask;
                    reg_pin_config_tristate &= ~mask;
                    reg_powerdown &= ~mask;
                    break;

                case PinMode.GPIO_Output_OpenDrain:
                    reg_pin_config_adc &= ~mask;
                    reg_pin_config_dac &= ~mask;
                    reg_pin_config_gpio_read &= ~mask;
                    reg_pin_config_gpio_write |= mask;
                    reg_pin_config_pulldown &= ~mask;
                    reg_pin_config_opendrain |= mask;
                    reg_pin_config_tristate &= ~mask;
                    reg_powerdown &= ~mask;
                    break;
            }

            WriteRegister(MODE_CONFIGURATION, REG_ADC_PIN_CONFIG, reg_pin_config_adc);
            WriteRegister(MODE_CONFIGURATION, REG_DAC_PIN_CONFIG, reg_pin_config_dac);
            WriteRegister(MODE_CONFIGURATION, REG_GPIO_READ_CONFIG, reg_pin_config_gpio_read);
            WriteRegister(MODE_CONFIGURATION, REG_GPIO_WRITE_CONFIG, reg_pin_config_gpio_write);
            WriteRegister(MODE_CONFIGURATION, REG_PULLDOWN_CONFIG, reg_pin_config_pulldown);
            WriteRegister(MODE_CONFIGURATION, REG_OPENDRAIN_CONFIG, reg_pin_config_opendrain);
            WriteRegister(MODE_CONFIGURATION, REG_TRISTATE_CONFIG, reg_pin_config_tristate);
            WriteRegister(MODE_CONFIGURATION, REG_POWERDOWN, reg_powerdown);
        }

        /// <summary>
        /// Read from an ADC channel.
        /// </summary>
        /// <param name="channel">ADC channel number (0 to 8).</param>
        /// <returns>ADC input sample data (0 to 4095).</returns>
        public int Read_ADC(int channel)
        {
            // Validate parameters

            if ((channel < MinChannel) || (channel > 8))
                throw new System.Exception("Invalid channel number.");

            WriteRegister(MODE_CONFIGURATION, REG_ADC_SEQ, (uint)(1 << channel));
            return (int)(ReadRegister(MODE_ADC_READBACK, 0) & 0x0FFF);
        }

        /// <summary>
        /// Write to a DAC channel.
        /// </summary>
        /// <param name="channel">DAC channel number (0 to 7).</param>
        /// <param name="data">DAC output sample data (0 to 4095).</param>
        public void Write_DAC(int channel, int data)
        {
            // Validate parameters

            if ((channel < MinChannel) || (channel > MaxChannel))
                throw new System.Exception("Invalid channel number.");

            if ((data < 0) || (data > 4095))
                throw new System.Exception("Invalid DAC data value.");

            WriteRegister(MODE_DAC_WRITE, (byte)channel, (uint)data);
        }

        /// <summary>
        /// GPIO output register state.  Any I/O pin that is not configured
        /// as a GPIO output will be written as zero.
        /// </summary>
        public byte GPIO_Outputs
        {
            get
            {
                return (byte)reg_gpio_write_data;
            }

            set
            {
                reg_gpio_write_data = value & reg_pin_config_gpio_write;
                WriteRegister(MODE_CONFIGURATION, REG_GPIO_WRITE_DATA,
                    reg_gpio_write_data);
            }
        }

        /// <summary>
        /// GPIO input register state.  Any I/O pin that is not configured
        /// as a GPIO input will read as zero.
        /// </summary>
        public byte GPIO_Inputs
        {
            get
            {
                return (byte)(ReadRegister(MODE_GPIO_READBACK) &
                    reg_pin_config_gpio_read);
            }
        }

        /// <summary>
        /// Create an AD5593R ADC input object.
        /// </summary>
        /// <param name="channel">AD5593R ADC channel number (0 to 8).</param>
        /// <returns>ADC input object.</returns>
        public IO.Interfaces.ADC.Sample ADC_Create(int channel)
        {
            return new IO.Devices.AD5593R.ADC.Sample(this, channel);
        }

        /// <summary>
        /// Create an AD5593R DAC output object.
        /// </summary>
        /// <param name="channel">AD5593R DAC channel number (0 to 7).</param>
        /// <param name="sample">Initial DAC output sample.</param>
        /// <returns>DAC output object.</returns>
        public IO.Interfaces.DAC.Sample DAC_Create(int channel, int sample = 0)
        {
            return new IO.Devices.AD5593R.DAC.Sample(this, channel, sample);
        }

        /// <summary>
        /// Create an AD5593R GPIO pin object.
        /// </summary>
        /// <param name="channel">AD5593R GPIO channel number (0 to 7).</param>
        /// <param name="dir">GPIO pin data direction.</param>
        /// <param name="state">Initial GPIO output state.</param>
        /// <returns>GPIO pin object.</returns>
        public IO.Interfaces.GPIO.Pin GPIO_Create(int channel,
            IO.Interfaces.GPIO.Direction dir, bool state = false)
        {
            return new IO.Devices.AD5593R.GPIO.Pin(this, channel, dir, state);
        }
    }
}
