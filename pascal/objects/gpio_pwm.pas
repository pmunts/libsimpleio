{ GPIO output services using PWM services                                     }

{ Copyright (C)2021, Philip Munts, President, Munts AM Corp.                  }
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

{ Use cases for this unit include on/off things like an LED or a solenoid     }
{ valve driven from a PWM output.                                             }

{ WARNING: Depending on the PWM hardware implementation, the off duty cycle   }
{ may be slightly greater than 0 % and/or the on duty cycle may be slightly   }
{ less than 100 %.                                                            }

UNIT GPIO_PWM;

INTERFACE

  USES
    GPIO,
    PWM;

  TYPE
    PinSubclass = CLASS(TInterfacedObject, GPIO.Pin)
      CONSTRUCTOR Create
       (pwmoutput    : PWM.Output;
        initialstate : Boolean = False;
        dutycycleon  : Real = PWM.DUTYCYCLE_MAX);

      FUNCTION Read : Boolean;

      PROCEDURE Write(state : Boolean);

      PROPERTY state : Boolean READ Read WRITE Write;
    PRIVATE
      myoutput : PWM.Output;
      myduty   : Real;
      mystate  : Boolean;
    END;

IMPLEMENTATION

  { GPIO pin constructor }

  CONSTRUCTOR PinSubclass.Create
   (pwmoutput    : PWM.Output;
    initialstate : Boolean = False;
    dutycycleon  : Real = PWM.DUTYCYCLE_MAX);

  BEGIN
    Self.myoutput := pwmoutput;
    Self.myduty   := dutycycleon;
    Self.state    := initialstate;
  END;

  { Read GPIO state }

  FUNCTION PinSubclass.Read : Boolean;

  BEGIN
    Read := Self.mystate;
  END;

  { Write GPIO state }

  PROCEDURE PinSubclass.Write(state : Boolean);

  BEGIN
    IF state THEN
      Self.myoutput.dutycycle := Self.myduty
    ELSE
      Self.myoutput.dutycycle := PWM.DUTYCYCLE_MIN;

    Self.mystate := state;
  END;

END.
