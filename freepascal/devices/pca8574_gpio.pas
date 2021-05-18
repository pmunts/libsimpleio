{ MAX7328/MAX7329/PCA8574/PCA9670/PCA9672/PCA9674/PCF8574 GPIO Pin Services }

{ Copyright (C)2018, Philip Munts, President, Munts AM Corp.                  }
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

UNIT PCA8574_GPIO;

INTERFACE

  USES
    GPIO,
    PCA8574;

  TYPE
    PinNumber = 0 .. 7;

    PinSubclass = CLASS(TInterfacedObject, GPIO.Pin)
      CONSTRUCTOR Create
       (dev   : PCA8574.Device;
        pin   : PinNumber;
        dir   : GPIO.Direction;
        state : Boolean = False);

      FUNCTION Read : Boolean;

      PROCEDURE Write(state : Boolean);

      PROPERTY state : Boolean READ Read WRITE Write;
    PRIVATE
      mydev  : PCA8574.Device;
      mydir  : GPIO.Direction;
      mymask : Byte;
    END;

IMPLEMENTATION

  CONSTRUCTOR PinSubclass.Create
   (dev   : PCA8574.Device;
    pin   : PinNumber;
    dir   : GPIO.Direction;
    state : Boolean = False);

  BEGIN
    Self.mydev  := dev;
    Self.mydir  := dir;
    Self.mymask := 1 SHL pin;
    Self.Write(state);
  END;

  { GPIO read method }

  FUNCTION PinSubclass.Read : Boolean;

  VAR
    b : Byte;

  BEGIN
    IF Self.mydir = GPIO.Input THEN
      b := Self.mydev.Read
    ELSE
      b := Self.mydev.Latch;

    IF (b AND Self.mymask) <> 0 THEN
      Read := True
    ELSE
      Read := False;
  END;

  { GPIO write method }

  PROCEDURE PinSubclass.Write(state : Boolean);

  BEGIN
    IF self.mydir = GPIO.Input THEN
      RAISE GPIO.Error.Create('ERROR: Cannot write to input pin');

    IF state THEN
      Self.mydev.Write(Self.mydev.Latch OR Self.mymask)
    ELSE
      Self.mydev.Write(Self.mydev.Latch AND NOT Self.mymask);
  END;

END.
