{ Servo output services using PWM services                                    }

{ Copyright (C)2019-2023, Philip Munts dba Munts Technologies.                }
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
        frequency : Cardinal = 50;
        position  : Real = Servo.POSITION_NEUTRAL);

      PROCEDURE Write(position : Real);

      PROPERTY position : Real WRITE Write;

    PRIVATE
      pwmout : PWM.Output;
      period : Cardinal;    { nanoseconds }
    END;

IMPLEMENTATION

  { Servo_libsimpleio.OutputSubclass constructor }

  CONSTRUCTOR OutputSubclass.Create
   (pwmout    : PWM.Output;
    frequency : Cardinal;
    position  : Real);

  BEGIN
    Self.pwmout   := pwmout;
    Self.period   := 1000000000 DIV frequency;
    Self.position := position;
  END;

  {  Servo_libsimpleio.OutputSubclass write method }

  PROCEDURE OutputSubclass.Write(position : Real);

  VAR
    ontime : Cardinal;  { nanoseconds }

  BEGIN
    ontime := Round(1500000.0 + 500000.0*position);
    Self.pwmout.dutycycle := Real(ontime)/Real(Self.period)*100.0;
  END;

END.
