{ PCA8574 I2C GPIO Expander Device Toggle Test }

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

PROGRAM test_remoteio_hid_pca8574_device;

USES
  HID_libsimpleio,
  I2C,
  Message64,
  PCA8574,
  RemoteIO,
  RemoteIO_I2C,
  SysUtils;

VAR
  hidmsg : Message64.Messenger;
  remdev : RemoteIO.Device;
  bus    : I2C.Bus;
  dev    : PCA8574.Device;

BEGIN
  WriteLn;
  WriteLn('PCA8574 I2C GPIO Expander Device Toggle Test');
  WriteLn;

  { Create objects }

  hidmsg := HID_libsimpleio.MessengerSubclass.Create;
  remdev := RemoteIO.Device.Create(hidmsg);
  bus    := RemoteIO_I2C.BusSubclass.Create(remdev, 0);
  dev    := PCA8574.Device.Create(bus, $38);

  { Toggle pins }

  REPEAT
    dev.Write(NOT dev.Read);
  UNTIL False;
END.
