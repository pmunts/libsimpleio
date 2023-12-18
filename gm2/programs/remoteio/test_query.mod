(* Remote I/O Protocol Device Information Query Test *)

(* Copyright (C)2023, Philip Munts dba Munts Technologies.                     *)
(*                                                                             *)
(* Redistribution and use in source and binary forms, with or without          *)
(* modification, are permitted provided that the following conditions are met: *)
(*                                                                             *)
(* * Redistributions of source code must retain the above copyright notice,    *)
(*   this list of conditions and the following disclaimer.                     *)
(*                                                                             *)
(* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" *)
(* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   *)
(* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  *)
(* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   *)
(* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         *)
(* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        *)
(* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    *)
(* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     *)
(* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     *)
(* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  *)
(* POSSIBILITY OF SUCH DAMAGE.                                                 *)

MODULE test_query;

  IMPORT
    Channel,
    ErrorHandling,
    libremoteio;

  FROM STextIO IMPORT WriteString, WriteLn;

  VAR
    handle     : INTEGER;
    error      : INTEGER;
    version    : ARRAY [1 .. 64] OF CHAR;
    capability : ARRAY [1 .. 64] OF CHAR;
    channels   : Channel.Channels;

BEGIN
  WriteLn;
  WriteString("Remote I/O Protocol Device Information Query Test");
  WriteLn;
  WriteLn;

  libremoteio.open_hid(016D0H, 00AFAH, "", libremoteio.TIMEOUT_DEFAULT, handle, error);
  ErrorHandling.CheckError(error, "open_hid() failed");

  libremoteio.get_version(handle, version, error);
  ErrorHandling.CheckError(error, "get_version() failed");

  libremoteio.get_capability(handle, capability, error);
  ErrorHandling.CheckError(error, "get_capability() failed");

  WriteString("Description:  ");
  WriteString(version);
  WriteLn;

  WriteString("Capabilities: ");
  WriteString(capability);
  WriteLn;

  libremoteio.adc_channels(handle, channels, error);
  ErrorHandling.CheckError(error, "adc_channels() failed");
  Channel.WriteChannels("ADC inputs:  ", channels);

  libremoteio.dac_channels(handle, channels, error);
  ErrorHandling.CheckError(error, "dac_channels() failed");
  Channel.WriteChannels("DAC outputs: ", channels);

  libremoteio.gpio_channels(handle, channels, error);
  ErrorHandling.CheckError(error, "gpio_channels() failed");
  Channel.WriteChannels("GPIO pins:   ", channels);

  libremoteio.i2c_channels(handle, channels, error);
  ErrorHandling.CheckError(error, "i2c_channels() failed");
  Channel.WriteChannels("I2C buses:   ", channels);

  libremoteio.pwm_channels(handle, channels, error);
  ErrorHandling.CheckError(error, "pwm_channels() failed");
  Channel.WriteChannels("PWM outputs: ", channels);

  libremoteio.spi_channels(handle, channels, error);
  ErrorHandling.CheckError(error, "spi_channels() failed");
  Channel.WriteChannels("SPI devices: ", channels);
  WriteLn;
END test_query.
