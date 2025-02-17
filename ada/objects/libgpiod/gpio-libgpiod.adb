-- GPIO pin services using libgpiod

-- Copyright (C)2025, Philip Munts dba Munts Technologies.
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

WITH Ada.Strings.Fixed;
WITH Interfaces.C;

WITH errno;
WITH libgpiod; USE libgpiod;

USE TYPE Interfaces.C.int;

PACKAGE BODY GPIO.libgpiod IS

  -- Mapping arrays

  BiasMap     : CONSTANT ARRAY (GPIO.libgpiod.Bias) OF gpiod_line_bias :=
   (GPIOD_LINE_BIAS_DISABLED,
    GPIOD_LINE_BIAS_PULL_UP,
    GPIOD_LINE_BIAS_PULL_DOWN);

  DirMap      : CONSTANT ARRAY (GPIO.Direction) OF gpiod_line_direction :=
   (GPIOD_LINE_DIRECTION_INPUT,
    GPIOD_LINE_DIRECTION_OUTPUT);

  DriveMap    : CONSTANT ARRAY (GPIO.libgpiod.Drive) OF gpiod_line_drive :=
   (GPIOD_LINE_DRIVE_PUSH_PULL,
    GPIOD_LINE_DRIVE_OPEN_DRAIN,
    GPIOD_LINE_DRIVE_OPEN_SOURCE);

  EdgeMap     : CONSTANT ARRAY (GPIO.libgpiod.Edge) OF gpiod_line_edge :=
   (GPIOD_LINE_EDGE_NONE,
    GPIOD_LINE_EDGE_RISING,
    GPIOD_LINE_EDGE_FALLING,
    GPIOD_LINE_EDGE_BOTH);

  PolarityMap : CONSTANT ARRAY (GPIO.libgpiod.Polarity) OF Boolean := (True, False);

  StateMap1   : CONSTANT ARRAY (Boolean) OF gpiod_line_value :=
   (GPIOD_LINE_VALUE_INACTIVE,
    GPIOD_LINE_VALUE_ACTIVE);

  StateMap2   : CONSTANT ARRAY (GPIOD_LINE_VALUE_INACTIVE .. GPIOD_LINE_VALUE_ACTIVE) OF Boolean := (False, True);

  FUNCTION Trim(s : String) RETURN String IS

  BEGIN
    RETURN Ada.Strings.Fixed.Trim(s, Ada.Strings.Both);
  END Trim;

  -- Check for error return

  PROCEDURE ErrorCheck(func : String; condition : Boolean) IS

  BEGIN
    IF condition THEN
      RAISE Error WITH func & "() failed, " & errno.strerror(errno.Get);
    END IF;
  END ErrorCheck;

  -- Constructor returning GPIO.Pin

  FUNCTION Create
   (desg     : Device.Designator;
    dir      : GPIO.Direction;
    state    : Boolean                := False;
    drive    : GPIO.libgpiod.Drive    := PushPull;
    bias     : GPIO.libgpiod.Bias     := Disabled;
    debounce : Duration               := 0.0;
    edge     : GPIO.libgpiod.Edge     := None;
    polarity : GPIO.libgpiod.Polarity := ActiveHigh) RETURN GPIO.Pin IS

    Self : PinSubclass;

  BEGIN
    Self.Initialize(desg, dir, state, drive, bias, debounce, edge, polarity);
    RETURN NEW PinSubclass'(Self);
  END Create;

  -- Static object initializer

  PROCEDURE Initialize
   (Self     : IN OUT PinSubclass;
    desg     : Device.Designator;
    dir      : GPIO.Direction;
    state    : Boolean                := False;
    drive    : GPIO.libgpiod.Drive    := PushPull;
    bias     : GPIO.libgpiod.Bias     := Disabled;
    debounce : Duration               := 0.0;
    edge     : GPIO.libgpiod.Edge     := None;
    polarity : GPIO.libgpiod.Polarity := ActiveHigh) IS

    devname  : CONSTANT String := "/dev/gpiochip" & Trim(Integer'Image(desg.chip));

    settings : gpiod_line_settings;
    config   : gpiod_line_config;
    offsets  : uint_array(0 .. 0);
    kind     : Kinds;
    ret      : Standard.Interfaces.C.int;
    chip     : gpiod_chip;
    line     : gpiod_line;

  BEGIN
    Self.Destroy;

    -- Open /dev/gpiochipN

    chip := gpiod_chip_open(devname);
    ErrorCheck("gpiod_chip_open", chip = null_chip);

    -- Populate GPIO line settings

    settings := gpiod_line_settings_new;
    ErrorCheck("gpiod_line_settings_new", settings = null_line_settings);

    IF dir = GPIO.Input THEN
      gpiod_line_settings_set_direction(settings, DirMap(dir));
      gpiod_line_settings_set_bias(settings, BiasMap(bias));
      gpiod_line_settings_set_edge_detection(settings, EdgeMap(edge));
      gpiod_line_settings_set_debounce_period_us(settings,
        Standard.Interfaces.C.unsigned_long(debounce*1.0E6));
      kind := input;
    ELSE
      gpiod_line_settings_set_direction(settings, DirMap(dir));
      gpiod_line_settings_set_drive(settings, DriveMap(drive));
      gpiod_line_settings_set_output_value(settings, StateMap1(state));
      kind := output;
    END IF;

    gpiod_line_settings_set_active_low(settings, PolarityMap(polarity));

    config := gpiod_line_config_new;
    ErrorCheck("gpiod_line_config_new", config = null_line_config);

    offsets(0) := Standard.Interfaces.C.unsigned(desg.chan);

    ret := gpiod_line_config_add_line_settings(config, offsets, offsets'Length, settings);
    ErrorCheck("gpiod_line_config_add_line_settings", ret < 0);

    line := gpiod_chip_request_lines(chip, null_request_config, config);
    ErrorCheck("gpiod_chip_request_lines", line = null_line);

    gpiod_chip_close(chip);
    gpiod_line_config_free(config);
    gpiod_line_settings_free(settings);

    Self := PinSubclass'(line, offsets(0), kind);
  END Initialize;

  -- Static object destroyer

  PROCEDURE Destroy(Self : IN OUT PinSubclass) IS

    error : Integer;

  BEGIN
    IF Self = Destroyed THEN
      RETURN;
    END IF;

    gpiod_line_request_release(Self.handle);

    Self := Destroyed;
  END Destroy;

  -- Read GPIO pin state

  FUNCTION Get(Self : IN OUT PinSubclass) RETURN Boolean IS

    state : gpiod_line_value;

  BEGIN
    Self.CheckDestroyed;

    state := gpiod_line_request_get_value(Self.handle, Self.offset);
    ErrorCheck("gpiod_line_request_get_value", state = GPIOD_LINE_VALUE_ERROR);

    RETURN StateMap2(state);
  END Get;

  -- Write GPIO pin state

  PROCEDURE Put(Self : IN OUT PinSubclass; state : Boolean) IS

    ret : Standard.Interfaces.C.int;

  BEGIN
    Self.CheckDestroyed;

    CASE Self.kind IS
      WHEN output =>
        ret := gpiod_line_request_set_value(Self.handle, Self.offset, StateMap1(state));
        ErrorCheck("gpiod_line_request_set_value", ret < 0);

      WHEN OTHERS =>
        RAISE GPIO_Error WITH "Cannot write to a GPIO input pin";
    END CASE;
  END Put;

  -- Retrieve the underlying Linux file descriptor

  FUNCTION fd(Self : PinSubclass) RETURN Integer IS

  BEGIN
    Self.CheckDestroyed;

    RETURN Integer(gpiod_line_request_get_fd(Self.handle));
  END fd;

  -- Check whether GPIO pin has been destroyed

  PROCEDURE CheckDestroyed(Self : PinSubclass) IS

  BEGIN
    IF Self = Destroyed THEN
      RAISE GPIO_Error WITH "GPIO pin has been destroyed";
    END IF;
  END CheckDestroyed;

END GPIO.libgpiod;
