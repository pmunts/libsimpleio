-- Generic package for I/O interfaces

-- Copyright (C)2017-2019, Philip Munts, President, Munts AM Corp.
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

GENERIC

  TYPE Property IS PRIVATE;

PACKAGE IO_Interfaces IS

  -- Define an abstract input only interface

  TYPE InputInterface IS INTERFACE;

  -- Define a method for reading from an input

  FUNCTION Get(Self : IN OUT InputInterface) RETURN Property IS ABSTRACT;

  ----------------------------------------------------------------------------

  -- Define an abstract input/output interface

  TYPE InputOutputInterface IS INTERFACE;

  -- Define a method for reading from an input

  FUNCTION Get(Self : IN OUT InputOutputInterface) RETURN Property IS ABSTRACT;

  -- Define a method for writing to an output

  PROCEDURE Put(Self : IN OUT InputOutputInterface; value : Property) IS ABSTRACT;

  ----------------------------------------------------------------------------

  -- Define an abstract output only interface

  TYPE OutputInterface IS INTERFACE;

  -- Define a method for writing to an output

  PROCEDURE Put(Self : IN OUT OutputInterface; value : Property) IS ABSTRACT;

END IO_Interfaces;
