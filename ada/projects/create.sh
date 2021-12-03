#!/bin/sh

# Script for creating an Ada program project

# Copyright (C)2021, Philip Munts, President, Munts AM Corp.
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

# Validate parameters

if [ "${1}" = "-allcaps" ]; then
  # Render Ada keywords in all capital letters.  Most people won't want
  # this, but I prefer it.
  ALLCAPS=yes
  shift 1
fi

if [ $# -lt 1 -o $# -gt 2 ]; then
  echo ''
  echo 'Ada Application Program Project Builder'
  echo ''
  echo 'Usage: <name> [libsimpleio|remoteio|mcp2221|ftdi_mpsse]'
  echo ''
  exit 1
fi

LIBSIMPLEIO=${LIBSIMPLEIO:-/usr/local/share/libsimpleio}
NAME=${1}
KIND=${2:-libsimpleio}
DSTDIR=./${NAME}

# Populate the project skeleton

mkdir -p					${DSTDIR}/.vscode
cp ${LIBSIMPLEIO}/ada/projects/Makefile		${DSTDIR}
cp ${LIBSIMPLEIO}/ada/projects/libsimpleio.gpr	${DSTDIR}/default.gpr
cp ${LIBSIMPLEIO}/ada/code/tasks.json		${DSTDIR}/.vscode

cat <<EOD >					${DSTDIR}/${NAME}.adb
procedure @@NAME@@ is

begin
   null;
end @@NAME@@;
EOD

# Expand @@NAME@@ and @@KIND@@ in the project files

sed -i "s/@@NAME@@/${NAME}/g"			${DSTDIR}/*
sed -i "s/@@KIND@@/${KIND}/g"			${DSTDIR}/*

# Make Ada keywords all caps -- *I* like this even if you don't!

if [ "$ALLCAPS" = "yes" ]; then
  sed -i 's/^procedure/PROCEDURE/g'		${DSTDIR}/${NAME}.adb
  sed -i 's/ is$/ IS/g'				${DSTDIR}/${NAME}.adb
  sed -i 's/^begin/BEGIN/g'			${DSTDIR}/${NAME}.adb
  sed -i 's/^   null/  NULL/g'			${DSTDIR}/${NAME}.adb
  sed -i 's/^end/END/g'				${DSTDIR}/${NAME}.adb
fi
