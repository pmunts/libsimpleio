{ Remote I/O Client Constructor using libusb }

{ Copyright (C)2020-2023, Philip Munts dba Munts Technologies.                }
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

{ Allowed values for the timeout parameter:                               }
{                                                                         }
{  0 => Receive operation blocks forever, until a report is received      }
{ >0 => Receive operation blocks for the indicated number of milliseconds }

UNIT RemoteIO_Client_libusb;

INTERFACE

  USES
    HID_Munts,
    HID_libusb,
    RemoteIO_Client;

  FUNCTION Create(vid : Cardinal = HID_Munts.VID;
    pid : Cardinal = HID_Munts.PID; serial : String = '';
    timeout : Cardinal = 1000; iface : Cardinal = 0; epin : Byte = $81;
    epout : Byte = $01) : RemoteIO_Client.Device;

IMPLEMENTATION

  FUNCTION Create(vid : Cardinal; pid : Cardinal; serial : String;
    timeout : Cardinal; iface : Cardinal; epin : Byte;
    epout : Byte) : RemoteIO_Client.Device;

  BEGIN
    Create := RemoteIO_Client.Device.Create(
      HID_libusb.MessengerSubclass.Create(vid, pid, serial, timeout, iface,
        epin, epout));
  END;

END.
