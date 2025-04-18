; Copyright (C)2024, Philip Munts dba Munts Technologies.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; * Redistributions of source code must retain the above copyright notice,
;   this list of conditions and the following disclaimer.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.

[Setup]
AppName=Remote Input Ouput Protocol LED Test
AppVersion=1.0
AppPublisher=Munts Technologies
AppPublisherURL=http://tech.munts.com
DefaultDirName={autopf64}\Remote_Input_Output_Protocol_Clients\test_led
DirExistsWarning=no
Compression=lzma2
SolidCompression=yes
InfoBeforeFile=installer.txt
OutputBaseFileName=test_led-setup
outputDir=.
UninstallFilesDir={app}/uninstall

[Files]
Source: "bin\Release\net9.0-windows\*.exe"                ; DestDir: "{app}"
Source: "bin\Release\net9.0-windows\*.dll"                ; DestDir: "{app}"
Source: "bin\Release\net9.0-windows\*.runtimeconfig.json" ; DestDir: "{app}"

[Icons]
Name: "{commonprograms}\Remote Input Output Protocol LED Test"; Filename: "{app}\test_led.exe"; WorkingDir: "{app}"
