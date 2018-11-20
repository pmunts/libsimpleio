@ECHO OFF

REM Command script to compile an Ada program without make et al

REM Copyright (C)2018, Philip Munts, President, Munts AM Corp.
REM
REM Redistribution and use in source and binary forms, with or without
REM modification, are permitted provided that the following conditions are met:
REM
REM * Redistributions of source code must retain the above copyright notice,
REM   this list of conditions and the following disclaimer.
REM
REM THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
REM AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
REM IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
REM ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
REM LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
REM CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
REM SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
REM INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
REM CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
REM ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
REM POSSIBILITY OF SUCH DAMAGE.

IF "%1" == "" ECHO.
IF "%1" == "" ECHO Usage: compile.bat ^<filename^>
IF "%1" == "" GOTO:EOF

REM Set some defaults

IF "%LIBSIMPLEIO%" == "" SET LIBSIMPLEIO=%HOMEDRIVE%%HOMEPATH%/libsimpleio
IF "%GNAT%" == "" SET GNAT=C:/PROGRA~1/gnat-gpl-2018
IF "%ARCH%" == "" SET ARCH=win64

REM Set source and object file directories.  Note that it is a Bad Idea to
REM have spaces in any directory paths...

SET SRC=%LIBSIMPLEIO%/ada
SET OBJ=./obj

REM Set compiler flags

SET CFLAGS=-gnat2012
SET CFLAGS=%CFLAGS% -I"%SRC%"/bindings
SET CFLAGS=%CFLAGS% -I"%SRC%"/devices
SET CFLAGS=%CFLAGS% -I"%SRC%"/interfaces
SET CFLAGS=%CFLAGS% -I"%SRC%"/objects
SET CFLAGS=%CFLAGS% -I"%SRC%"/remoteio
SET CFLAGS=%CFLAGS% -I"%SRC%"/remoteio/client

SET LDFLAGS=-L.

REM Get ready to compile...

robocopy  "%LIBSIMPLEIO%/win/%ARCH%" . hidapi.dll /NFL /NDL /NJH /NJS /nc /ns /np

MKDIR "%OBJ%"

REM Compile the program

"%GNAT%/bin/gnatmake" -D "%OBJ%" %1 -cargs %CFLAGS% -largs %LDFLAGS%
