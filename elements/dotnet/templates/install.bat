@ECHO OFF

REM Install Visual Studio project templates

REM Copyright (C)2019-2023, Philip Munts dba Munts Technologies.
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

SET DSTDIR=%HOMEDRIVE%%HOMEPATH%\Documents\Visual Studio 2022\Templates\ProjectTemplates

RD /S /Q "%DSTDIR%"\elements_dotnet_csharp_console_libremoteio
RD /S /Q "%DSTDIR%"\elements_dotnet_csharp_console_libsimpleio
RD /S /Q "%DSTDIR%"\elements_dotnet_go_console_libremoteio
RD /S /Q "%DSTDIR%"\elements_dotnet_go_console_libsimpleio
RD /S /Q "%DSTDIR%"\elements_dotnet_java_console_libremoteio
RD /S /Q "%DSTDIR%"\elements_dotnet_java_console_libsimpleio
RD /S /Q "%DSTDIR%"\elements_dotnet_pascal_console_libremoteio
RD /S /Q "%DSTDIR%"\elements_dotnet_pascal_console_libsimpleio
RD /S /Q "%DSTDIR%"\elements_dotnet_swift_console_libremoteio
RD /S /Q "%DSTDIR%"\elements_dotnet_swift_console_libsimpleio

MD "%DSTDIR%"\elements_dotnet_csharp_console_libremoteio
MD "%DSTDIR%"\elements_dotnet_csharp_console_libsimpleio
MD "%DSTDIR%"\elements_dotnet_go_console_libremoteio
MD "%DSTDIR%"\elements_dotnet_go_console_libsimpleio
MD "%DSTDIR%"\elements_dotnet_java_console_libremoteio
MD "%DSTDIR%"\elements_dotnet_java_console_libsimpleio
MD "%DSTDIR%"\elements_dotnet_pascal_console_libremoteio
MD "%DSTDIR%"\elements_dotnet_pascal_console_libsimpleio
MD "%DSTDIR%"\elements_dotnet_swift_console_libremoteio
MD "%DSTDIR%"\elements_dotnet_swift_console_libsimpleio

XCOPY elements_dotnet_csharp_console_libremoteio.d "%DSTDIR%"\elements_dotnet_csharp_console_libremoteio
XCOPY elements_dotnet_csharp_console_libsimpleio.d "%DSTDIR%"\elements_dotnet_csharp_console_libsimpleio
XCOPY elements_dotnet_go_console_libremoteio.d     "%DSTDIR%"\elements_dotnet_go_console_libremoteio
XCOPY elements_dotnet_go_console_libsimpleio.d     "%DSTDIR%"\elements_dotnet_go_console_libsimpleio
XCOPY elements_dotnet_java_console_libremoteio.d   "%DSTDIR%"\elements_dotnet_java_console_libremoteio
XCOPY elements_dotnet_java_console_libsimpleio.d   "%DSTDIR%"\elements_dotnet_java_console_libsimpleio
XCOPY elements_dotnet_pascal_console_libremoteio.d "%DSTDIR%"\elements_dotnet_pascal_console_libremoteio
XCOPY elements_dotnet_pascal_console_libsimpleio.d "%DSTDIR%"\elements_dotnet_pascal_console_libsimpleio
XCOPY elements_dotnet_swift_console_libremoteio.d  "%DSTDIR%"\elements_dotnet_swift_console_libremoteio
XCOPY elements_dotnet_swift_console_libsimpleio.d  "%DSTDIR%"\elements_dotnet_swift_console_libsimpleio
