#!/bin/sh

# Get rid of all the junk Visual Studio leaves behind

# Copyright (C)2014-2018, Philip Munts, President, Munts AM Corp.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

ls ./*.*proj ./*.sln 2>/dev/null | egrep -q '^.*\.(.*proj|sln)$'
if [ $? -eq 1 -a ! -f csharp.mk ]; then
  exit 0
fi

echo "Removing Visual Studio flotsam from `pwd`"

/usr/bin/find . -name DOTNETMF_FS_EMULATION	-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name bin			-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name obj			-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name OnBoardFlash.dat		-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*.apk' -a -not -path './prebuilt/*' -exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*.csproj.user'		-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*.exe.config'		-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*.suo'			-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*.userprefs'		-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*.vs'			-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*.vshost.exe'		-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*.vshost.exe.manifest'	-exec rm -rf {} ";" >/dev/null 2>&1
/usr/bin/find . -name '*TemporaryKey.pfx'	-exec rm -rf {} ";" >/dev/null 2>&1
