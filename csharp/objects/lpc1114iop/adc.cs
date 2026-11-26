// Copyright (C)2026, Philip Munts dba Munts Technologies.
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

using static IO.Bindings.libspiagent;

namespace IO.Objects.LPC1114IOP.ADC
{
  /// <summary>
  /// LPC1114 I/O Processor ADC input pin identifiers.
  /// </summary>
  public enum pin_id_t
  {
    /// <summary>
    /// GPIO0 <i>aka</i> LPC1114 pin PIO1_0
    /// </summary>
    ADC1 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO0,
    /// <summary>
    /// GPIO1 <i>aka</i> LPC1114 pin PIO1_1
    /// </summary>
    ADC2 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO1,
    /// <summary>
    /// GPIO2 <i>aka</i> LPC1114 pin PIO1_2
    /// </summary>
    ADC3 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO2,
    /// <summary>
    /// GPIO3 <i>aka</i> LPC1114 pin PIO1_3
    /// </summary>
    ADC4 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO3,
    /// <summary>
    /// GPIO4 <i>aka</i> LPC1114 pin PIO1_4
    /// </summary>
    ADC5 = IO.Objects.LPC1114IOP.GPIO.pin_id_t.GPIO4,
  }

  /// <summary>
  /// This class encapsulates LPC1114 I/O Processor ADC inputs.
  /// </summary>
  public class Input : IO.Interfaces.ADC.Voltage
  {
    private uint mypin;

    /// <summary>
    /// ADC input object constructor.
    /// </summary>
    /// <param name="pin">ADC input pin number.</param>
    /// <remarks>
    /// The resolution of the LPC1114 single chip microcontroller A/D converter
    /// is 10 bits, yielding measurements with at best 3 significant decimal
    /// digits.  Its reference voltage and input span are the LPC1114 power
    /// supply voltage, nominally 3.3V.  Absolute accuracy will therefore
    /// depend upon the accuracy of the power supply (under load!) that feeds
    /// the LPC1114.
    /// </remarks>
    public Input(pin_id_t pin)
    {
      int error;

      spiagent_analog_configure((uint) pin, out error);

      if (error != 0)
        throw new System.Exception("spiagent_analog_configure() failed, error=" +
          error.ToString());

      this.mypin = (uint) pin;
    }

    /// <summary>
    /// Read-Only ADC input voltage (0.0 to 3.3V nominal) property.
    /// </summary>
    ///     /// <remarks>
    /// The resolution of the LPC1114 single chip microcontroller A/D converter
    /// is 10 bits, yielding measurements with at best 3 significant decimal
    /// digits.  Its reference voltage and input span are the LPC1114 power
    /// supply voltage, nominally 3.3V.  Absolute accuracy will therefore
    /// depend upon the accuracy of the power supply (under load!) that feeds
    /// the LPC1114.
    /// </remarks>
    public double voltage
    {
      get
      {
        float volts;
        int error;

        spiagent_analog_get(this.mypin, out volts, out error);

        if (error != 0)
          throw new System.Exception("spiagent_analog_get() failed, error=" +
            error.ToString());

        return volts;
      }
    }
  }
}
