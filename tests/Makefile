# Makefile for building and running Linux Simple I/O Library unit tests

# Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

CFLAGS		= -Wall -I.. $(DEBUGFLAGS)
LDFLAGS		= -lcheck -lm -lrt -lpthread -lsubunit -lsimpleio

PROGRAMS	= test_parameter_checks

run: $(PROGRAMS)
	@for P in $(PROGRAMS) ; do $(shell pwd)/$$P ; done

test_parameter_checks: test_parameter_checks.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

test_compile:
	-$(MAKE) test_compile_boards >test_compile.log 2>&1
	-grep -i error test_compile.log | cat
	-grep -i warn test_compile.log | grep -v 'did you forget' | cat

test_compile_boards:
	-$(MAKE) test_compile_programs BOARDNAME=
	-$(MAKE) test_compile_programs BOARDNAME=BeagleBone
	-$(MAKE) test_compile_programs BOARDNAME=RaspberryPi
	-$(MAKE) test_compile_programs BOARDNAME=RaspberryPi2

test_compile_programs:
	-$(MAKE) -C ../ada/programs default
	-$(MAKE) -C ../ada/programs clean
	-$(MAKE) -C ../ada/programs/mcp2221 default
	-$(MAKE) -C ../ada/programs/mcp2221 clean
	-$(MAKE) -C ../ada/programs/remoteio default
	-$(MAKE) -C ../ada/programs/remoteio clean
	-$(MAKE) -C ../c++/programs default
	-$(MAKE) -C ../c++/programs clean
	-$(MAKE) -C ../csharp/programs/libremoteio/mono default
	-$(MAKE) -C ../csharp/programs/libremoteio/mono clean
	-$(MAKE) -C ../csharp/programs/libsimpleio/mono default
	-$(MAKE) -C ../csharp/programs/libsimpleio/mono clean
	-$(MAKE) -C ../csharp/programs/libsimpleio-remoteio/mono default
	-$(MAKE) -C ../csharp/programs/libsimpleio-remoteio/mono clean
	-$(MAKE) -C ../java/programs default
	-$(MAKE) -C ../java/programs clean
	-$(MAKE) -C ../pascal/programs default
	-$(MAKE) -C ../pascal/programs clean
	-$(MAKE) -C ../pascal/programs/remoteio default
	-$(MAKE) -C ../pascal/programs/remoteio clean

clean:
	rm -rf $(PROGRAMS) *.log
