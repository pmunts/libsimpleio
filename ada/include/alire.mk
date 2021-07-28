# Make definitions and rules for building Alire crates

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

# The following macros must be defined *before* including this file:
#
# CRATE_NAME
# CRATE_VERSION
# PROJECT_NAME

ALR		?= alr

CRATE_VERSION	?= undefined

CRATE_DIR	:= $(CRATE_NAME)
CRATE_MANIFEST	:= $(CRATE_NAME)-$(CRATE_VERSION).toml

ARCHIVE_DIR	:= $(CRATE_NAME)-$(CRATE_VERSION)
ARCHIVE_TARBALL := $(CRATE_NAME)-$(CRATE_VERSION).tbz2

ALIRE_REPO_SCP	?= undefined
ALIRE_REPO_URL	?= undefined

INDEX_CHECKOUT	:= $(HOME)/alire-index
INDEX_SUBDIR	:= index/$(shell echo $(CRATE_NAME) | cut -c '1-2')/$(CRATE_NAME)

# Initialize the crate workspace directory for a library project

alire_mk_init_lib:
	rm -rf						$(CRATE_DIR)
	mkdir -p					$(CRATE_DIR)
	$(ALR) init --lib				$(CRATE_DIR)
	rm						$(CRATE_DIR)/$(CRATE_NAME).gpr
	rm						$(CRATE_DIR)/src/$(CRATE_NAME).ads
	cp $(PROJECT_NAME).gpr				$(CRATE_DIR)
	cp $(CRATE_NAME).toml				$(CRATE_DIR)/alire.toml
	sed -i 's/@@VERSION@@/$(CRATE_VERSION)/g'	$(CRATE_DIR)/*.toml $(CRATE_DIR)/*.gpr

# Initialize the crate workspace directory for a program project

alire_mk_init_prog:
	rm -rf						$(CRATE_DIR)
	mkdir -p					$(CRATE_DIR)
	$(ALR) init --bin				$(CRATE_DIR)
	rm						$(CRATE_DIR)/$(CRATE_NAME).gpr
	rm						$(CRATE_DIR)/src/$(CRATE_NAME).adb
	cp $(PROJECT_NAME).gpr				$(CRATE_DIR)
	cp $(CRATE_NAME).toml				$(CRATE_DIR)/alire.toml
	sed -i 's/@@VERSION@@/$(CRATE_VERSION)/g'	$(CRATE_DIR)/*.toml $(CRATE_DIR)/*.gpr

# Pack the crate

alire_mk_pack:
	test -d $(CRATE_DIR)
	rm -rf						$(ARCHIVE_DIR)
	mkdir -p					$(ARCHIVE_DIR)
	cp -R $(CRATE_DIR)/*				$(ARCHIVE_DIR)
	rm -rf						$(ARCHIVE_DIR)/alire
	rm -rf						$(ARCHIVE_DIR)/bin
	rm -rf						$(ARCHIVE_DIR)/lib
	rm -rf						$(ARCHIVE_DIR)/obj
	rm -rf						$(ARCHIVE_DIR)/.gitignore
	tar cjf $(ARCHIVE_TARBALL)			$(ARCHIVE_DIR)

# Publish the crate

alire_mk_publish:
	test -f $(ARCHIVE_TARBALL)
	test "$(ALIRE_REPO_SCP)" != "undefined"
	test "$(ALIRE_REPO_URL)" != "undefined"
	test -d $(INDEX_CHECKOUT)
	scp $(ARCHIVE_TARBALL) $(ALIRE_REPO_SCP)
	$(ALR) publish $(ALIRE_REPO_URL)/$(ARCHIVE_TARBALL)
	mkdir -p $(INDEX_CHECKOUT)/$(INDEX_SUBDIR)
	cp alire/releases/$(CRATE_MANIFEST) $(INDEX_CHECKOUT)/$(INDEX_SUBDIR)
	cd $(INDEX_CHECKOUT) && git add $(INDEX_CHECKOUT)/$(INDEX_SUBDIR)/$(CRATE_MANIFEST)
	cd $(INDEX_CHECKOUT) && git commit -m "$(CRATE_NAME) release $(CRATE_VERSION)"

# Build the crate

alire_mk_build:
	test -d $(CRATE_DIR)
	cd $(CRATE_DIR) && $(ALR) build

# Remove working files

alire_mk_clean:
	rm -rf $(CRATE_DIR) $(ARCHIVE_DIR) $(ARCHIVE_TARBALL)

alire_mk_reallyclean: alire_mk_clean
	rm -rf alire

alire_mk_distclean: alire_mk_reallyclean
