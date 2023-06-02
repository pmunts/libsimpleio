-- MCP2221 Device Query Test using HID.hidapi

-- Copyright (C)2018-2023, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO ; USE Ada.Text_IO;

WITH MCP2221.hidapi;

PROCEDURE test_query_hidapi IS

  dev : MCP2221.Device;

BEGIN
  New_Line;
  Put_Line("MCP2221 Device Query Test");
  New_Line;

  dev := MCP2221.hidapi.Create;

  Put_Line("Revision      => " & dev.Revision);
  Put_Line("Manufacturer  => " & dev.Manufacturer);
  Put_Line("Product       => " & dev.Product);
  Put_Line("Serial Number => " & dev.SerialNumber);
  New_Line;
END test_query_hidapi;
