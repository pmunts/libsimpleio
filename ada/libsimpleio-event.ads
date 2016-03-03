-- Ada wrapper for the Linux epoll services implemented in
-- libsimpleio.so

-- $Id$

-- Copyright (C)2016, Philip Munts, President, Munts AM Corp.
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

PACKAGE libsimpleio.EVENT IS
  PRAGMA Link_With("-lsimpleio");

  EPOLLIN      : CONSTANT := 16#00000001#;
  EPOLLPRI     : CONSTANT := 16#00000002#;
  EPOLLOUT     : CONSTANT := 16#00000004#;
  EPOLLRDNORM  : CONSTANT := 16#00000040#;
  EPOLLRDBAND  : CONSTANT := 16#00000080#;
  EPOLLWRNORM  : CONSTANT := 16#00000100#;
  EPOLLWRBAND  : CONSTANT := 16#00000200#;
  EPOLLMSG     : CONSTANT := 16#00000400#;
  EPOLLERR     : CONSTANT := 16#00000008#;
  EPOLLHUP     : CONSTANT := 16#00000010#;
  EPOLLRDHUP   : CONSTANT := 16#00002000#;
  EPOLLWAKEUP  : CONSTANT := 16#20000000#;
  EPOLLONESHOT : CONSTANT := 16#40000000#;
  EPOLLET      : CONSTANT := 16#80000000#;

  PROCEDURE Open
   (error     : Integer);
  PRAGMA Import(C, Open, "EVENT_open");

  PROCEDURE Close
   (error     : OUT Integer);
  PRAGMA Import(C, Close, "EVENT_close");

  PROCEDURE Register
   (fd        : Integer;
    events    : Integer;
    error     : OUT Integer);
  PRAGMA Import(C, Register, "EVENT_register_fd");

  PROCEDURE Unregister
   (fd        : Integer;
    error     : OUT Integer);
  PRAGMA Import(C, Unregister, "EVENT_unregister_fd");

  PROCEDURE Wait
   (fd        : OUT Integer;
    event     : OUT Integer;
    timeoutms : Integer;
    error     : Integer);
  PRAGMA Import(C, Wait, "EVENT_wait");

END libsimpleio.EVENT;
