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

namespace IO.Objects.LPC1114IOP.GPIO
{
  /// <summary>
  /// LPC1114 I/O Processor GPIO pin identifiers.
  /// </summary>
  public enum pin_id_t
  {
    /// <summary>
    /// LPC1114 pin PIO0_7
    /// </summary>
    LED = 7,
    /// <summary>
    /// LPC1114 pin PIO1_1
    /// </summary>
    /// <summary>
    /// LPC1114 pin PIO1_0
    /// </summary>
    GPIO0 = 12,
    /// <summary>
    /// LPC1114 pin PIO1_1
    /// </summary>
    GPIO1 = 13,
    /// <summary>
    /// LPC1114 pin PIO1_2
    /// </summary>
    GPIO2 = 14,
    /// <summary>
    /// LPC1114 pin PIO1_3
    /// </summary>
    GPIO3 = 15,
    /// <summary>
    /// LPC1114 pin PIO1_4
    /// </summary>
    GPIO4 = 16,
    /// <summary>
    /// LPC1114 pin PIO1_5
    /// </summary>
    GPIO5 = 17,
    /// <summary>
    /// LPC1114 pin PIO1_8
    /// </summary>
    GPIO6 = 20,
    /// <summary>
    /// LPC1114 pin PIO1_9
    /// </summary>
    GPIO7 = 21
  }

  /// <summary>
  /// GPIO pin configuration mode constants.
  /// </summary>
  public enum mode_t
  {
    /// <summary>
    /// Normal high impedance input.
    /// </summary>
    GPIO_MODE_INPUT,
    /// <summary>
    /// Input with pulldown resistor.
    /// </summary>
    GPIO_MODE_INPUT_PULLDOWN,
    /// <summary>
    /// Input with pullup resistor.
    /// </summary>
    GPIO_MODE_INPUT_PULLUP,
    /// <summary>
    /// Normal push-pull output.
    /// </summary>
    GPIO_MODE_OUTPUT,
    /// <summary>
    /// Output with open drain.
    /// </summary>
    GPIO_MODE_OUTPUT_OPENDRAIN
  }

  /// <summary>
  /// GPIO pin interrupt edge configuration constants.
  /// </summary>
  public enum edge_t
  {
    /// <summary>
    /// Interrupt mode disabled.
    /// </summary>
    GPIO_INTERRUPT_DISABLED,
    /// <summary>
    /// Interrupt on falling edge.
    /// </summary>
    GPIO_INTERRUPT_FALLING,
    /// <summary>
    /// Interrupt on rising edge.
    /// </summary>
    GPIO_INTERRUPT_RISING,
    /// <summary>
    /// Interrupt both both falling and rising edges.
    /// </summary>
    GPIO_INTERRUPT_BOTH
  }

  /// <summary>
  /// Encapsulates LPC1114 I/O Processor GPIO pins.
  /// </summary>
  public class Pin : IO.Interfaces.GPIO.Pin
  {
    private uint number;
    private bool IsInput;

    /// <summary>
    /// Constructor for an LPC1114 I/O Processor GPIO pin object.
    /// </summary>
    /// <param name="pin">Pin number.</param>
    /// <param name="dir">Data direction.</param>
    /// <param name="state">Initial output state.  Ignored for input pins.
    /// </param>
    public Pin(pin_id_t pin, IO.Interfaces.GPIO.Direction dir, bool state = false)
    {
      int error;

      spiagent_gpio_configure((uint) pin, (uint) dir,
        (uint) (state ? 1 : 0), out error);

      if (error != 0)
        throw new System.Exception("spiagent_gpio_configure() failed, error=" +
          error.ToString());

      this.number = (uint) pin;
      this.IsInput = (dir == IO.Interfaces.GPIO.Direction.Input);
    }

    /// <summary>
    /// Constructor for an LPC1114 I/O Processor GPIO pin object.
    /// </summary>
    /// <param name="pin">Pin number.</param>
    /// <param name="mode">Configuration mode.</param>
    /// <param name="edge">Interrupt edge.</param>
    /// <param name="state">Initial output state.  Ignored for input pins.
    /// </param>
    public Pin(pin_id_t pin, mode_t mode,
      edge_t edge = edge_t.GPIO_INTERRUPT_DISABLED, bool state = false)
    {
      int error;

      spiagent_gpio_configure_mode((uint) pin, (uint) mode, out error);

      if (error != 0)
        throw new System.Exception("spiagent_gpio_configure() failed, error=" +
          error.ToString());

      if (mode < mode_t.GPIO_MODE_OUTPUT)
      {
        spiagent_gpio_configure_interrupt((uint) pin, (uint) edge, out error);

        if (error != 0)
          throw new System.Exception("spiagent_gpio_interrupt() failed, error=" +
            error.ToString());

        this.IsInput = true;
      }
      else
      {
        spiagent_gpio_put((uint) pin, (uint) (state ? 1 : 0), out error);

        if (error != 0)
          throw new System.Exception("spiagent_gpio_put() failed, error=" +
            error.ToString());

        this.IsInput = false;
      }

      this.number = (uint) pin;
    }

    /// <summary>
    /// Read/Write GPIO state property.
    /// </summary>
    public bool state
    {
      get
      {
        uint state;
        int error;

        spiagent_gpio_get(this.number, out state, out error);

        if (error != 0)
          throw new System.Exception("spiagent_gpio_get() failed, error=" +
            error.ToString());

        return state > 0;
      }

      set
      {
        if (this.IsInput)
          throw new System.Exception("Cannot write to an input pin.");

        int error;

        spiagent_gpio_put(this.number, (uint) (state ? 1 : 0), out error);

        if (error != 0)
          throw new System.Exception("spiagent_gpio_put() failed, error=" +
            error.ToString());
      }
    }
  }
}