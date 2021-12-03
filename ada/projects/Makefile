.PHONY: default build clean

LIBSIMPLEIO	?= /usr/local/share/libsimpleio

include $(LIBSIMPLEIO)/ada/include/ada.mk
include $(LIBSIMPLEIO)/ada/include/@@KIND@@.mk

PROGRAMS	+= @@NAME@@

default: build

# Build the programs

build: $(PROGRAMS)

# Remove working files

clean: ada_mk_clean
	rm -f $(PROGRAMS)
