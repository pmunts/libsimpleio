(* Copyright (C)2018, Philip Munts, President, Munts AM Corp.                  *)
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

MODULE test_hidraw_info;

IMPORT
  libhidraw,
  hid_munts,
  hid_libsimpleio;

FROM ErrorHandling IMPORT CheckError;
FROM FIO IMPORT FlushOutErr;
FROM NumberIO IMPORT WriteHex;
FROM STextIO IMPORT WriteString, WriteLn;

VAR
  dev     : hid_libsimpleio.Device;
  name    : ARRAY [1 .. 256] OF CHAR;
  bus     : CARDINAL;
  vendor  : CARDINAL;
  product : CARDINAL;
  error   : CARDINAL;

BEGIN
  WriteLn;
  WriteString("Raw HID Info Test");
  WriteLn;
  WriteLn;
  FlushOutErr;

  hid_munts.Open(hid_libsimpleio.ANYSERIAL, hid_libsimpleio.FOREVER, dev, error);
  CheckError(error, "hid_munts.Open() failed");

  libhidraw.HIDRAW_get_name(hid_libsimpleio.fd(dev), name, HIGH(name),
    error);
  CheckError(error, "libhidraw.HIDRAW_get_name() failed");

  WriteString("Device Name: ");
  WriteString(name);
  WriteLn;
  FlushOutErr;

  libhidraw.HIDRAW_get_info(hid_libsimpleio.fd(dev), bus, vendor, product,
    error);
  CheckError(error, "libhidraw.HIDRAW_get_info() failed");

  WriteString("Bus type:    ");
  WriteHex(bus, 4);
  WriteLn;

  WriteString("Vendor ID:   ");
  WriteHex(vendor, 4);
  WriteLn;

  WriteString("Product ID:  ");
  WriteHex(product, 4);
  WriteLn;
  WriteLn;
  FlushOutErr;

  hid_libsimpleio.Close(dev, error);
  CheckError(error, "hid_libsimpelio.Close() failed");
END test_hidraw_info.
