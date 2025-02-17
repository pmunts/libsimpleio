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

-- String actual parameters *MUST* be NUL terminated, e.g. "FOO" & ASCII.NUL

WITH Interfaces.C.Strings;

PACKAGE libgpiod IS
  PRAGMA Link_With("-lgpiod");

  Error : EXCEPTION;

  -- Define an opaque C pointer type

  TYPE opaque IS NEW Interfaces.C.Strings.chars_ptr;

  null_opaque : CONSTANT opaque := opaque(Interfaces.C.Strings.Null_Ptr);

  -- libgpiod opaque structure pointer types

  TYPE gpiod_chip           IS NEW opaque;
  TYPE gpiod_line           IS NEW opaque;
  TYPE gpiod_line_config    IS NEW opaque;
  TYPE gpiod_line_settings  IS NEW opaque;
  TYPE gpiod_request_config IS NEW opaque;

  null_chip           : CONSTANT gpiod_chip           := gpiod_chip(null_opaque);
  null_line           : CONSTANT gpiod_line           := gpiod_line(null_opaque);
  null_line_config    : CONSTANT gpiod_line_config    := gpiod_line_config(null_opaque);
  null_line_settings  : CONSTANT gpiod_line_settings  := gpiod_line_settings(null_opaque);
  null_request_config : CONSTANT gpiod_request_config := gpiod_request_config(null_opaque);

  TYPE uint_array IS ARRAY (Natural RANGE <>) OF Interfaces.C.unsigned;

  -- GPIO state

  TYPE gpiod_line_value IS
   (GPIOD_LINE_VALUE_ERROR,
    GPIOD_LINE_VALUE_INACTIVE,
    GPIOD_LINE_VALUE_ACTIVE) WITH Convention => C;

  FOR gpiod_line_value USE
   (GPIOD_LINE_VALUE_ERROR    => -1,
    GPIOD_LINE_VALUE_INACTIVE => 0,
    GPIOD_LINE_VALUE_ACTIVE   => 1);

  -- GPIO direction

  TYPE gpiod_line_direction IS
   (GPIOD_LINE_DIRECTION_INPUT,
    GPIOD_LINE_DIRECTION_OUTPUT) WITH Convention => C;

  FOR gpiod_line_direction USE
   (GPIOD_LINE_DIRECTION_INPUT  => 2,
    GPIOD_LINE_DIRECTION_OUTPUT => 3);

  -- GPIO input edge

  TYPE gpiod_line_edge IS
   (GPIOD_LINE_EDGE_NONE,
    GPIOD_LINE_EDGE_RISING,
    GPIOD_LINE_EDGE_FALLING,
    GPIOD_LINE_EDGE_BOTH) WITH Convention => C;

  FOR gpiod_line_edge USE
   (GPIOD_LINE_EDGE_NONE    => 1,
    GPIOD_LINE_EDGE_RISING  => 2,
    GPIOD_LINE_EDGE_FALLING => 3,
    GPIOD_LINE_EDGE_BOTH    => 4);

  -- GPIO input bias

  TYPE gpiod_line_bias IS
   (GPIOD_LINE_BIAS_UNKNOWN,
    GPIOD_LINE_BIAS_DISABLED,
    GPIOD_LINE_BIAS_PULL_UP,
    GPIOD_LINE_BIAS_PULL_DOWN) WITH Convention => C;

  FOR gpiod_line_bias USE
   (GPIOD_LINE_BIAS_UNKNOWN   => 2,
    GPIOD_LINE_BIAS_DISABLED  => 3,
    GPIOD_LINE_BIAS_PULL_UP   => 4,
    GPIOD_LINE_BIAS_PULL_DOWN => 5);

  -- GPIO output drive

  TYPE gpiod_line_drive IS
   (GPIOD_LINE_DRIVE_PUSH_PULL,
    GPIOD_LINE_DRIVE_OPEN_DRAIN,
    GPIOD_LINE_DRIVE_OPEN_SOURCE) WITH Convention => C;

  FOR gpiod_line_drive USE
   (GPIOD_LINE_DRIVE_PUSH_PULL   => 1,
    GPIOD_LINE_DRIVE_OPEN_DRAIN  => 2,
    GPIOD_LINE_DRIVE_OPEN_SOURCE => 3);

------------------------------------------------------------------------------
-- GPIO chip operations
------------------------------------------------------------------------------

  FUNCTION gpiod_chip_open(path : String) RETURN gpiod_chip
    WITH Import => True, Convention => C;

  FUNCTION gpiod_chip_request_lines
   (chip     : gpiod_chip;
    req_cfg  : gpiod_request_config;
    line_cfg : gpiod_line_config) RETURN gpiod_line
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_chip_close(chip : gpiod_chip)
    WITH Import => True, Convention => C;

------------------------------------------------------------------------------
-- GPIO line settings operations
------------------------------------------------------------------------------

  FUNCTION gpiod_line_settings_new RETURN gpiod_line_settings
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_settings_set_bias
   (settings     : gpiod_line_settings;
    input_bias   : gpiod_line_bias)
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_settings_set_direction
   (settings     : gpiod_line_settings;
    direction    : gpiod_line_direction)
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_settings_set_drive
   (settings     : gpiod_line_settings;
    output_drive : gpiod_line_drive)
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_settings_set_edge_detection
   (settings     : gpiod_line_settings;
    input_edge   : gpiod_line_edge)
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_settings_set_active_low
   (settings     : gpiod_line_settings;
    active_low   : Boolean)
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_settings_set_debounce_period_us
   (settings     : gpiod_line_settings;
    period       : Interfaces.C.unsigned_long)
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_settings_set_output_value
   (settings     : gpiod_line_settings;
    value        : gpiod_line_value)
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_settings_free(settings : gpiod_line_settings)
    WITH Import => True, Convention => C;

------------------------------------------------------------------------------
-- GPIO line config operations
------------------------------------------------------------------------------

  FUNCTION gpiod_line_config_new RETURN gpiod_line_config
    WITH Import => True, Convention => C;

  FUNCTION gpiod_line_config_add_line_settings
   (config       : gpiod_line_config;
    offsets      : uint_array;
    num_offsets  : Interfaces.C.size_t;
    settings     : gpiod_line_settings) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_config_free(config : gpiod_line_config)
    WITH Import => True, Convention => C;

------------------------------------------------------------------------------
-- GPIO line operations
------------------------------------------------------------------------------

  FUNCTION gpiod_line_request_get_value
   (line     : gpiod_line;
    offset   : Interfaces.C.unsigned) RETURN gpiod_line_value
    WITH Import => True, Convention => C;

  FUNCTION gpiod_line_request_set_value
   (line     : gpiod_line;
    offset   : Interfaces.C.unsigned;
    value    : gpiod_line_value) RETURN Interfaces.C.int
    WITH Import => True, Convention => C;

  FUNCTION gpiod_line_request_get_fd
   (line     : gpiod_line) RETURN Interfaces.C.Int
    WITH Import => True, Convention => C;

  PROCEDURE gpiod_line_request_release
   (line     : gpiod_line)
    WITH Import => True, Convention => C;

END libgpiod;
