{ Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.             }
{                                                                             }
{ Redistribution and use in source and binary forms, with or without          }
{ modification, are permitted provided that the following conditions are met: }
{                                                                             }
{ * Redistributions of source code must retain the above copyright notice,    }
{   this list of conditions and the following disclaimer.                     }
{                                                                             }
{ THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" }
{ AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE   }
{ IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE  }
{ ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE   }
{ LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR         }
{ CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF        }
{ SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS    }
{ INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     }
{ CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)     }
{ ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE  }
{ POSSIBILITY OF SUCH DAMAGE.                                                 }

UNIT Click_7Seg;

INTERFACE

  USES
    GPIO,
    PWM,
    SPI,
    SPI_Shift_Register,
    SysUtils;

  CONST
    SEGMENT_A  = $01;
    SEGMENT_B  = $02;
    SEGMENT_C  = $04;
    SEGMENT_D  = $08;
    SEGMENT_E  = $10;
    SEGMENT_F  = $20;
    SEGMENT_G  = $40;
    SEGMENT_DP = $80;

  TYPE
    Error = CLASS(Exception);

    Display = CLASS
      CONSTRUCTOR Create
       (spidev    : SPI.Device;
        pwmpin    : GPIO.PIN;
        rstpin    : GPIO.Pin);

      CONSTRUCTOR Create
       (spidev    : SPI.Device;
        pwmout    : PWM.Output;
        rstpin    : GPIO.Pin;
        bright    : Real = PWM.DUTYCYCLE_MAX);

      PROCEDURE Write
       (data      : Byte;
        blank     : Boolean = False;
        dpleft    : Boolean = False;
        dpright   : Boolean = False;
        bright    : Real = PWM.DUTYCYCLE_MAX);

      PROCEDURE WriteHex
       (data      : Byte;
        blank     : Boolean = False;
        dpleft    : Boolean = False;
        dpright   : Boolean = False;
        bright    : Real = PWM.DUTYCYCLE_MAX);

      PROCEDURE WriteSegments
       (dataleft  : Byte;
        dataright : Byte;
        bright    : Real = PWM.DUTYCYCLE_MAX);
    PRIVATE
      regdev : SPI_Shift_Register.Device;
      pwmpin : GPIO.Pin;
      pwmout : PWM.Output;
      rstpin : GPIO.Pin;
    END;

IMPLEMENTATION

  CONST
    { The segments of the Mikroelektronika Seven Segment Display }
    { Click Board are wired in an odd fashion.  The following    }
    { permutation table transforms from standard seven segment   }
    { layout to that of the Click Board.                         }

    PermuteSegments : ARRAY [0 .. 255] OF Byte =
     ($00, $04, $02, $06, $08, $0C, $0A, $0E,
      $10, $14, $12, $16, $18, $1C, $1A, $1E,
      $20, $24, $22, $26, $28, $2C, $2A, $2E,
      $30, $34, $32, $36, $38, $3C, $3A, $3E,
      $40, $44, $42, $46, $48, $4C, $4A, $4E,
      $50, $54, $52, $56, $58, $5C, $5A, $5E,
      $60, $64, $62, $66, $68, $6C, $6A, $6E,
      $70, $74, $72, $76, $78, $7C, $7A, $7E,
      $80, $84, $82, $86, $88, $8C, $8A, $8E,
      $90, $94, $92, $96, $98, $9C, $9A, $9E,
      $A0, $A4, $A2, $A6, $A8, $AC, $AA, $AE,
      $B0, $B4, $B2, $B6, $B8, $BC, $BA, $BE,
      $C0, $C4, $C2, $C6, $C8, $CC, $CA, $CE,
      $D0, $D4, $D2, $D6, $D8, $DC, $DA, $DE,
      $E0, $E4, $E2, $E6, $E8, $EC, $EA, $EE,
      $F0, $F4, $F2, $F6, $F8, $FC, $FA, $FE,
      $01, $05, $03, $07, $09, $0D, $0B, $0F,
      $11, $15, $13, $17, $19, $1D, $1B, $1F,
      $21, $25, $23, $27, $29, $2D, $2B, $2F,
      $31, $35, $33, $37, $39, $3D, $3B, $3F,
      $41, $45, $43, $47, $49, $4D, $4B, $4F,
      $51, $55, $53, $57, $59, $5D, $5B, $5F,
      $61, $65, $63, $67, $69, $6D, $6B, $6F,
      $71, $75, $73, $77, $79, $7D, $7B, $7F,
      $81, $85, $83, $87, $89, $8D, $8B, $8F,
      $91, $95, $93, $97, $99, $9D, $9B, $9F,
      $A1, $A5, $A3, $A7, $A9, $AD, $AB, $AF,
      $B1, $B5, $B3, $B7, $B9, $BD, $BB, $BF,
      $C1, $C5, $C3, $C7, $C9, $CD, $CB, $CF,
      $D1, $D5, $D3, $D7, $D9, $DD, $DB, $DF,
      $E1, $E5, $E3, $E7, $E9, $ED, $EB, $EF,
      $F1, $F5, $F3, $F7, $F9, $FD, $FB, $FF);

    { The following glyph pattern values came from:       }
    { https://en.wikipedia.org/wiki/Seven-segment_display }

    GlyphTable : ARRAY [0 .. 15] OF Byte =
     ($3F, $06, $5B, $4F, $66, $6D, $7D, $07,
      $7F, $6F, $77, $7C, $39, $5E, $79, $71);

  CONSTRUCTOR Display.Create
   (spidev    : SPI.Device;
    pwmpin    : GPIO.PIN;
    rstpin    : GPIO.Pin);

  BEGIN
    Self.regdev := SPI_Shift_Register.Device.Create(spidev, 2);
    Self.pwmpin := pwmpin;
    Self.rstpin := rstpin;
    Self.pwmout := NIL;

    Self.WriteSegments(0, 0);
    Self.pwmpin.state := True;
    Self.rstpin.state := True;
  END;

  CONSTRUCTOR Display.Create
   (spidev    : SPI.Device;
    pwmout    : PWM.Output;
    rstpin    : GPIO.Pin;
    bright    : Real = PWM.DUTYCYCLE_MAX);

  BEGIN
    Self.regdev := SPI_Shift_Register.Device.Create(spidev, 2);
    Self.pwmpin := NIL;
    Self.pwmout := pwmout;
    Self.rstpin := rstpin;

    Self.WriteSegments(0, 0);
    Self.pwmout.dutycycle := bright;
    Self.rstpin.state := True;
  END;

  PROCEDURE Display.Write
   (data      : Byte;
    blank     : Boolean = False;
    dpleft    : Boolean = False;
    dpright   : Boolean = False;
    bright    : Real = PWM.DUTYCYCLE_MAX);

  VAR
    dataleft : Byte;
    dataright : Byte;

  BEGIN
    { Validate parameters }

    IF data > 99 THEN
      RAISE Error.Create('ERROR: Invalid data parameter');

    IF (bright < PWM.DUTYCYCLE_MIN) OR (bright > PWM.DUTYCYCLE_MAX) THEN
      RAISE Error.Create('ERROR: Invalid brightness parameter');

    { Calculate display patterns }

    IF (data DIV 10 = 0) AND blank THEN
      dataleft := $00
    ELSE
      dataleft  := GlyphTable[data DIV 10];

    dataright := GlyphTable[data MOD 10];

    IF dpleft THEN
      dataleft := dataleft OR SEGMENT_DP;

    IF dpright THEN
      dataright := dataright OR SEGMENT_DP;

    { Update the display }

    Self.WriteSegments(dataleft, dataright, bright);

    IF Self.pwmout <> NIL THEN
      Self.pwmout.dutycycle := bright;
  END;

  PROCEDURE Display.WriteHex
   (data      : Byte;
    blank     : Boolean = False;
    dpleft    : Boolean = False;
    dpright   : Boolean = False;
    bright    : Real = PWM.DUTYCYCLE_MAX);

  VAR
    dataleft : Byte;
    dataright : Byte;

  BEGIN
    { Validate parameters }

    IF (bright < PWM.DUTYCYCLE_MIN) OR (bright > PWM.DUTYCYCLE_MAX) THEN
      RAISE Error.Create('ERROR: Invalid brightness parameter');

    { Calculate display patterns }

    IF (data DIV 16 = 0) AND blank THEN
      dataleft := $00
    ELSE
      dataleft  := GlyphTable[data DIV 16];

    dataright := GlyphTable[data MOD 16];

    IF dpleft THEN
      dataleft := dataleft OR SEGMENT_DP;

    IF dpright THEN
      dataright := dataright OR SEGMENT_DP;

    { Update the display }

    Self.WriteSegments(dataleft, dataright, bright);

    IF Self.pwmout <> NIL THEN
      Self.pwmout.dutycycle := bright;
  END;

  PROCEDURE Display.WriteSegments
   (dataleft  : Byte;
    dataright : Byte;
    bright    : Real = PWM.DUTYCYCLE_MAX);

  VAR
    outbuf : ARRAY [0 .. 1] OF Byte;

  BEGIN
    { Validate parameters }

    IF (bright < PWM.DUTYCYCLE_MIN) OR (bright > PWM.DUTYCYCLE_MAX) THEN
      RAISE Error.Create('ERROR: Invalid brightness parameter');

    outbuf[0] := PermuteSegments[dataright];
    outbuf[1] := PermuteSegments[dataleft];

    Self.regdev.Write(outbuf);

    IF Self.pwmout <> NIL THEN
      Self.pwmout.dutycycle := bright;
  END;

END.
