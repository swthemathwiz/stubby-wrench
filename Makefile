#
# Copyright (c) Stewart Whitman, 2024.
#
# File:    Makefile
# Project: Stubby Wrench
# License: CC BY-NC-SA 4.0 (Attribution-NonCommercial-ShareAlike)
# Desc:    Makefile for directory 
#

OPENSCAD = openscad
PNGCRUSH = pngcrush -brute

SRCS = \
	flat-knurled.scad \
	slanted.scad \
	rounded.scad \
	smidge.scad \

BUILDS = \
	stubby-wrench.scad \
	stubby-bit-holder.scad \
 
EXTRAS = \
	Makefile \

LIBRARIES = ./libraries

LIBRARY_REPOS = \
	https://github.com/openscad/scad-utils \
	https://github.com/Irev-Dev/Round-Anything

LIBRARY_FILES = \

TARGETS = $(BUILDS:.scad=.stl)
IMAGES = $(BUILDS:.scad=.png)
ICONS = $(BUILDS:.scad=.icon.png)

DEPDIR := .deps
DEPFLAGS = -d $(DEPDIR)/$*.d

COMPILE.scad = $(OPENSCAD) -o $@ $(DEPFLAGS)
RENDER.scad = $(OPENSCAD) -o $@ --render --colorscheme=Tomorrow
RENDERICON.scad = $(RENDER.scad) --imgsize=256,256

.PHONY: all images icons clean distclean

all: $(TARGETS)

images: $(IMAGES)

icons : $(ICONS)

%.stl : %.scad
%.stl : %.scad $(DEPDIR)/%.d | $(DEPDIR)
	$(COMPILE.scad) $<

%.unoptimized.png : %.scad
	$(RENDER.scad) $<

%.icon.unoptimized.png : %.scad
	$(RENDERICON.scad) $<

%.png : %.unoptimized.png
	$(PNGCRUSH) $< $@ || mv $< $@

clean:
	rm -f *.stl *.bak *.png

distclean: clean
	rm -rf $(DEPDIR)

local-libraries: SHELL := /usr/bin/bash
local-libraries:
	@[ -d $(LIBRARIES)  ] || mkdir $(LIBRARIES)
	# Install the repositories
	@cd $(LIBRARIES) || exit 1 ; \
	for repo in $(LIBRARY_REPOS); do \
		dn=`echo "$$repo" | tr / ' ' | awk '{ print $$NF }'` ; \
		echo "Getting repository $$repo"; \
		[ -d "$$dn" ] || git clone --depth=1 "$$repo" ; \
	done
	# Install the files
	@cd $(LIBRARIES) || exit 1 ; \
	for filename in $(LIBRARY_FILES); do \
		readarray -td, fnarr < <(printf '%s' "$$filename"); \
		url="$${fnarr[0]}" ; \
		fn="$${fnarr[1]}" ; \
		[ "$$fn" != "" ] || fn=`echo "$$url" | tr / ' ' | awk '{ print $$NF }'` ; \
		echo "Getting file $$fn from $$url"; \
		[ -f "$$fn" ] || curl "$$url" --output "$$fn" --location --silent ; \
	done
	# Make each repository directory with a Makefile
	@for repo in $(LIBRARY_REPOS); do \
		dn=`echo "$$repo" | tr / ' ' | awk '{ print $$NF }'` ; \
		if [ -f "$(LIBRARIES)/$$dn/Makefile" ]; then \
			echo "Making repository $$dn"; \
			cd "$(LIBRARIES)/$$dn" && $(MAKE); \
		fi ; \
	done

$(DEPDIR): ; @mkdir -p $@

DEPFILES := $(TARGETS:%.stl=$(DEPDIR)/%.d)
$(DEPFILES):

include $(wildcard $(DEPFILES))
