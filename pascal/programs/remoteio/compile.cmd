@ECHO OFF

REM Command script to compile a Remote I/O Protocol Free Pascal application
REM program for Windows without make et al.

REM Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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
IF "%1" == "" ECHO Usage: compile ^<program name^>
IF "%1" == "" GOTO:EOF

REM Set some defaults

IF "%FPC%"         == "" SET FPC=fpc
IF "%LIBSIMPLEIO%" == "" SET LIBSIMPLEIO=%HOMEDRIVE%%HOMEPATH%\libsimpleio
IF "%ARCH%"        == "" SET ARCH=win64
IF "%OBJ%"         == "" SET OBJ=obj

REM Set compiler flags

SET FPCFLAGS=-Mobjfpc -CX -Sh -Xs -XX -g -gl -FE. -FU%OBJ%
SET FPCFLAGS=%FPCFLAGS% -Fu"%LIBSIMPLEIO%"\pascal\bindings
SET FPCFLAGS=%FPCFLAGS% -Fu"%LIBSIMPLEIO%"\pascal\devices
SET FPCFLAGS=%FPCFLAGS% -Fu"%LIBSIMPLEIO%"\pascal\interfaces
SET FPCFLAGS=%FPCFLAGS% -Fu"%LIBSIMPLEIO%"\pascal\objects
SET FPCFLAGS=%FPCFLAGS% -Fu"%LIBSIMPLEIO%"\pascal\objects\remoteio
SET FPCFLAGS=%FPCFLAGS% -Fl"%LIBSIMPLEIO%"\win\%ARCH%

REM Get ready to compile...

MKDIR %OBJ%

REM Compile the program

%FPC% %FPCFLAGS% "%1"
