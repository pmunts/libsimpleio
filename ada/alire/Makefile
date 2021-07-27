# Build an Alire crate contain the Ada libsimpleio binding

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

ALR		?= alr
GNATPP		?= /usr/local/gnat-gpl-2021/bin/gnatpp

CRATE_NAME	:= munts_libsimpleio
CRATE_DIR	:= $(CRATE_NAME)
CRATE_VERSION	?= 1.0.0
CRATE_MANIFEST	:= $(CRATE_NAME)-$(CRATE_VERSION).toml

ARCHIVE_DIR	:= $(CRATE_NAME)-$(CRATE_VERSION)
ARCHIVE_TARBALL := $(CRATE_NAME)-$(CRATE_VERSION).tbz2

SERVERSCP	?= private
SERVERURL	?= private

INDEX_CHECKOUT	:= $(HOME)/alire-index
INDEX_SUBDIR	:= index/$(shell echo $(CRATE_NAME) | cut -c '1-2')/$(CRATE_NAME)

default: publish.done

# Populate the crate

populate.done:
	mkdir -p					$(CRATE_DIR)
	$(ALR) init --lib				$(CRATE_DIR)
	-diff libsimpleio.gpr				$(CRATE_DIR)/$(CRATE_NAME).gpr
	rm						$(CRATE_DIR)/$(CRATE_NAME).gpr
	cp libsimpleio.gpr				$(CRATE_DIR)
	-diff libsimpleio.toml				$(CRATE_DIR)/alire.toml
	cp libsimpleio.toml				$(CRATE_DIR)/alire.toml
	sed -i 's/@@VERSION@@/$(CRATE_VERSION)/g'	$(CRATE_DIR)/*.toml $(CRATE_DIR)/*.gpr
	cp -R ../bindings				$(CRATE_DIR)/src
	cp -R ../devices				$(CRATE_DIR)/src
	cp -R ../interfaces				$(CRATE_DIR)/src
	cp -R ../objects				$(CRATE_DIR)/src
	rm						$(CRATE_DIR)/src/$(CRATE_NAME).ads
	cd $(CRATE_DIR)/src && find * -type f -exec $(GNATPP) {} ";"
	touch $@

# Build the crate archive

archive.done: populate.done
	mkdir -p					$(ARCHIVE_DIR)
	cp -R $(CRATE_DIR)/*				$(ARCHIVE_DIR)
	rm -rf						$(ARCHIVE_DIR)/alire
	rm -rf						$(ARCHIVE_DIR)/lib
	rm -rf						$(ARCHIVE_DIR)/obj
	rm -rf						$(ARCHIVE_DIR)/.gitignore
	tar cjf $(ARCHIVE_TARBALL)			$(ARCHIVE_DIR)
	touch $@

# Publish the crate archive

publish.done: archive.done
	test -d $(INDEX_CHECKOUT)
	scp $(ARCHIVE_TARBALL) $(SERVERSCP)
	alr publish $(SERVERURL)/$(ARCHIVE_TARBALL)
	cp alire/releases/$(CRATE_MANIFEST) $(INDEX_CHECKOUT)/$(INDEX_SUBDIR)
	cd $(INDEX_CHECKOUT) && git add $(INDEX_CHECKOUT)/$(INDEX_SUBDIR)/$(CRATE_MANIFEST)
	-cd $(INDEX_CHECKOUT) && git commit -m "munts-libsimpleio release $(CRATE_VERSION)"
	touch $@

# Build the crate

build.done: populate.done
	cd $(CRATE_DIR) && $(ALR) build
	touch $@

# Remove working files

clean:
	rm -rf *.done *.tbz2 $(CRATE_DIR) $(ARCHIVE_DIR)

reallyclean: clean
	rm -rf alire

distclean: reallyclean
