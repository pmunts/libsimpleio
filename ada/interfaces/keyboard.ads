-- Abstract interface for ASCII keyboards and keypads

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

PACKAGE Keyboard IS

  -- Define an exception for keyboard input errors

  Error : Exception;

  DefaultTimeout : CONSTANT Duration := 1.0;

  -- Define an abstract interface for keyboard input devices

  TYPE InputInterface IS INTERFACE;

  -- Define an access type compatible with any subclass implementing
  -- Keyboard.InputInterface

  TYPE Input IS ACCESS ALL Keyboard.InputInterface'Class;

  -- Method to fetch the next character from the input buffer.
  -- If the timeout expires, return ASCII.NUL.

  FUNCTION Get(Self    : InputInterface;
               timeout : Duration := DefaultTimeout) RETURN Character IS ABSTRACT;

  -- Method to clear the keyboard input buffer.

  PROCEDURE Clear(Self : InputInterface) IS ABSTRACT;

END Keyboard;
