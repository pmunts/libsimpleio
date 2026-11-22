-- Raspberry Pi LPC1114 I/O Processor Interrupt Test

-- Copyright (C)2013-2026, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH errno;                USE errno;
WITH LPC1114IOP.GPIO;      USE LPC1114IOP.GPIO;
WITH LPC1114IOP.Interrupt; USE LPC1114IOP.Interrupt;
WITH LPC1114IOP.Pins;      USE LPC1114IOP.Pins;
WITH LPC1114IOP.Transport;

PROCEDURE test_lpc1114iop_int IS

  input_pin : LPC1114IOP.GPIO.GPIOPinClass;
  intr_pin  : Integer;
  error     : Integer;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi LPC1114 I/O Processor Interrupt Test");
  New_Line;

  -- Initialize the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Open("ioctl://localhost");

  -- Configure an LPC1114 pin as input with pull-up, with interrupt enabled

  input_pin.Initialize(LPC1114_GPIO0, GPIO_MODE_INPUT, GPIO_INTERRUPT_FALLING);

  -- Enable interrupt monitoring on Raspberry Pi INT (GPIO4)

  interrupt_enable(error);

  IF error /= 0 THEN
    RAISE LPC1114IOP.Error WITH
      "interrupt_enable() failed, error:" & error'Image;
  END IF;

  Put_Line("Press CONTROL-C to quit");
  New_Line;

  LOOP
    interrupt_wait(1000, intr_pin, error);

    CASE error IS
      WHEN EOK => -- poll() event received or timed out
        IF intr_pin /= 0 THEN
          Put_Line("Received interrupt on GPIO pin" & intr_pin'Image);
        END IF;

      WHEN EINTR => -- poll() interrupted by signal
        EXIT;

      WHEN OTHERS => -- poll() failed
        RAISE LPC1114IOP.Error WITH
          "interrupt_wait() failed, error:" & error'Image;
    END CASE;
  END LOOP;

  New_Line;
  Put_Line("Terminating.");
  New_Line;

  -- Return the LPC1114 pin to default configuration

  input_pin.ConfigureMode(GPIO_MODE_INPUT_PULLUP);
  input_pin.ConfigureInterrupt(GPIO_INTERRUPT_DISABLED);

  -- Disable interrupt monitoring on Raspberry Pi INT (GPIO4)

  interrupt_disable(error);

  IF error /= 0 THEN
    RAISE LPC1114IOP.Error WITH
      "interrupt_disable() failed, error:" & error'Image;
  END IF;

  -- Close the SPI Agent Firmware transport library

  LPC1114IOP.Transport.Close;
END test_lpc1114iop_int;
