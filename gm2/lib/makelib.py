#!/usr/bin/python3

# Helper script to find and compile implementation modules

# Copyright (C)2018-2025, Philip Munts dba Munts Technologies.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS'
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

import glob
import os
import os.path
import sys
import tempfile

# Extract command line arguments

GM2 = sys.argv[1]
AR = sys.argv[2]
GM2_CFLAGS = sys.argv[3]

LIBFILE = sys.argv[4]
OBJDIR = tempfile.mkdtemp(prefix = LIBFILE + '.')

# Create the object file directory

#os.system('mkdir -p ' + OBJDIR)

# Create the module library archive

os.system(AR + ' rcs ' + LIBFILE)

# Search for implementation modules to compile

for ITEM in GM2_CFLAGS.split():
  if ITEM.startswith('-I'):
    DIR = ITEM[2:]
    for SRCFILE in glob.iglob(DIR + '/*.mod'):
      OBJFILE = OBJDIR + '/' + os.path.basename(SRCFILE)[:-4] + '.o'
      print("Compiling library module " + SRCFILE)
      CMD = GM2 + ' ' + GM2_CFLAGS + ' -c -o' + OBJFILE + ' ' + SRCFILE
      os.system(CMD)
      CMD = AR + ' rcs ' + LIBFILE + ' ' + OBJFILE
      os.system(CMD)

# Remove the object files

os.system('rm -rf ' + OBJDIR)
