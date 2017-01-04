-- Minimal Ada wrapper for the Linux IPv4 TCP stream services
-- implemented in libso

-- Copyright (C)2016-2017, Philip Munts, President, Munts AM Corp.
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

WITH System;

PACKAGE libTCP4 IS
  PRAGMA Link_With("-lsimpleio");

  TYPE IPV4_ADDR IS MOD 2**32;

  TYPE IPV4_PORT IS MOD 2**16;

  INADDR_ANY      : CONSTANT IPV4_ADDR := 16#00000000#;
  INADDR_LOOPBACK : CONSTANT IPV4_ADDR := 16#7F000001#;	-- aka localhost

  -- Resolve host name to 32-bit IPv4 address

  PROCEDURE Resolve
   (hostname : String;
    hostaddr : OUT IPV4_ADDR;
    error    : OUT Integer);
  PRAGMA Import(C, Resolve, "TCP4_resolve");

  -- Connect to an IPv4 TCP server

  PROCEDURE Connect
   (host     : IPV4_ADDR;
    port     : IPV4_PORT;
    fd       : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Connect, "TCP4_connect");

  -- Wait for a connection from an IPv4 TCP client

  PROCEDURE AcceptConnection
   (iface    : IPV4_ADDR;
    port     : IPV4_PORT;
    fd       : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, AcceptConnection, "TCP4_accept");

  -- Start IPv4 TCP server

  PROCEDURE Server
   (iface    : IPV4_ADDR;
    port     : IPV4_PORT;
    fd       : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Server, "TCP4_server");

  -- Close a IPv4 TCP connection

  PROCEDURE Close
   (fd       : Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Close, "LINUX_close");

  -- Send data to IPv4 TCP connection peer

  PROCEDURE Send
   (fd       : Integer;
    buf      : System.Address;
    size     : Integer;
    count    : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Send, "LINUX_write");

  -- Receive data from IPv4 TCP connection peer

  PROCEDURE Receive
   (fd       : Integer;
    buf      : System.Address;
    size     : Integer;
    count    : OUT Integer;
    error    : OUT Integer);
  PRAGMA Import(C, Receive, "LINUX_read");

END libTCP4;
