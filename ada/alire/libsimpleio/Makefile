# Build an Alire crate to contain the Ada libsimpleio binding

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

LIBSIMPLEIO	?= /usr/local/share/libsimpleio
ADA_SRC		?= $(LIBSIMPLEIO)/ada


REVISION	?= $(shell svn log -l 1 $(ADA_SRC) | awk '/svn/ { print substr($$1, 2) }' | head -n 1)
BUILDNUM	?= 1

PROJECT_NAME	:= libsimpleio

CRATE_NAME	:= $(PROJECT_NAME)
CRATE_VERSION	:= 1.$(REVISION).$(BUILDNUM)

default: pack

include $(ADA_SRC)/include/alire.mk

# Load the crate

populate.done: alire_mk_init_lib
	cp -R $(ADA_SRC)/bindings	$(CRATE_DIR)/src
	cp -R $(ADA_SRC)/devices	$(CRATE_DIR)/src
	cp -R $(ADA_SRC)/interfaces	$(CRATE_DIR)/src
	cp -R $(ADA_SRC)/objects	$(CRATE_DIR)/src
ifneq ($(GNATPP),)
	cd $(CRATE_DIR)/src && find * -type f -exec $(GNATPP) {} ";"
endif
	touch $@

# Pack the crate

pack: populate.done alire_mk_pack

# Build the crate

build: alire_mk_build

# Publish the crate

publish: alire_mk_publish

# Remove working files

clean: alire_mk_clean
	rm -f *.done

reallyclean: alire_mk_reallyclean clean

distclean: alire_mk_reallyclean reallyclean
