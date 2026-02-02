{ Servo output services using PWM services                                    }

{ Copyright (C)2019-2026, Philip Munts dba Munts Technologies.                }
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

UNIT Servo_PWM;

INTERFACE

  USES
    PWM,
    Servo;

  TYPE
    OutputSubclass = CLASS(TInterfacedObject, Servo.Output)
      CONSTRUCTOR Create
       (pwmout    : PWM.Output;
        frequency : Cardinal;
        position  : Double   = Servo.POSITION_NEUTRAL;
        minwidth  : Double   = 1.0E-3;
        maxwidth  : Double   = 2.0E-3);

      PROCEDURE Write(position : Double);

      PROPERTY position : Double WRITE Write;

    PRIVATE
      pwmout   : PWM.Output;
      period   : Double;  { seconds }
      swing    : Double;  { seconds }
      midpoint : Double;  { seconds }
    END;

IMPLEMENTATION

  { Servo_libsimpleio.OutputSubclass constructor }

  CONSTRUCTOR OutputSubclass.Create
   (pwmout    : PWM.Output;
    frequency : Cardinal;
    position  : Double;
    minwidth  : Double;
    maxwidth  : Double);

  BEGIN
    Self.pwmout   := pwmout;
    Self.period   := 1.0/frequency;
    Self.swing    := (maxwidth - minwidth)/2.0;
    Self.midpoint := minwidth + swing;
    Self.position := position;
  END;

  {  Servo_libsimpleio.OutputSubclass write method }

  PROCEDURE OutputSubclass.Write(position : Double);

  VAR
    ontime : Double;  { seconds }

  BEGIN
    ontime := Self.midpoint + Self.swing*position;
    Self.pwmout.dutycycle := ontime/Self.period*100.0;
  END;

END.
