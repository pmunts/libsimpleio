-- Minimal Ada wrapper for Linux Industrial I/O services in libsimpleio.so

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

PACKAGE libIIO IS
  PRAGMA Link_With("-lsimpleio");

  O_RDONLY : CONSTANT Integer := 0;
  O_WRONLY : CONSTANT Integer := 1;
  O_RDWR   : CONSTANT Integer := 2;

  PROCEDURE GetName
   (chip     : Integer;
    name     : OUT String;
    size     : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, GetName, "IIO_get_name");

  PROCEDURE GetReference
   (chip     : Integer;
    vref     : OUT Long_Float;
    error    : OUT Integer);
  PRAGMA Import(C, GetReference, "IIO_get_vref");

  PROCEDURE Open
   (chip     : Integer;
    channel  : Integer;
    property : String;
    suffix   : String;
    mode     : Integer;
    fd       : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Open, "IIO_open");

  PROCEDURE GetDouble
   (fd       : Integer;
    item     : OUT Long_Float;
    error    : OUT Integer);
  PRAGMA Import(C, GetDouble, "IIO_get_double");

  PROCEDURE GetInt
   (fd       : Integer;
    item     : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, GetInt, "IIO_get_int");

  PROCEDURE PutInt
   (fd       : Integer;
    item     : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, PutInt, "IIO_put_int");

  PROCEDURE Close
   (fd       : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Close, "IIO_close");
END libIIO;
