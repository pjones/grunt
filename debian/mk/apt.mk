# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk
include $(GRUNT_HOME)/debian/mk/codename.mk

################################################################################
VPATH = $(GRUNT_HOME)/debian/apt/$(GRUNT_DEBIAN_CODENAME)

################################################################################
GRUNT_APT_DIR      = /etc/apt
GRUNT_APT_PREF_DIR = $(GRUNT_APT_DIR)/preferences.d
GRUNT_APT_LIST_DIR = $(GRUNT_APT_DIR)/sources.list.d

################################################################################
# $1: The basename of the APT file (no extension)
define GRUNT_INSTALL_APT_FILE
install: $(GRUNT_APT_LIST_DIR)/$(1).list $(GRUNT_APT_PREF_DIR)/$(1).pref
$(GRUNT_APT_LIST_DIR)/$(1).list: $(1).list
	$(GRUNT_INSTALL_READ_ONLY) $$< $$@
	$$(if $$(wildcard $$(patsubst %.list,%.gpg,$$<)),apt-key add $$(patsubst %.list,%.gpg,$$<) > /dev/null)
	$$(if $$(wildcard $$(patsubst %.list,%.gpg.url,$$<)),wget -qO - -i $$(patsubst %.list,%.gpg.url,$$<)|apt-key add - > /dev/null)
	apt-get update

$(GRUNT_APT_PREF_DIR)/$(1).pref: $(1).pref
	$(GRUNT_INSTALL_READ_ONLY) $$< $$@
endef

################################################################################
# Automatically install any *.list files with their *.pref files.
GRUNT_APT_LIST_FILES ?= $(subst .list,,$(shell ls *.list | grep -v sources.list))
$(foreach l,$(GRUNT_APT_LIST_FILES),$(eval $(call GRUNT_INSTALL_APT_FILE,$(l))))

################################################################################
# A file named "sources.list" is special, and gets installed in /etc/apt.
ifeq (sources.list,$(wildcard sources.list))
$(eval $(call GRUNT_INSTALL_PLAIN_FILE,$(GRUNT_APT_DIR)/sources.list,,apt-get update))
endif

################################################################################
# List the basenames of extra APT files to install.  For example:
#
#  GRUNT_APT_EXTRAS  = emacs-snapshot
#  GRUNT_APT_EXTRAS += bitlbee-dev
#
# Will look for files called: emacs-snapshot.list,
# emacs-snapshot.pref, bitlbee-dev.list, and bitlbee-dev.pref.
GRUNT_APT_EXTRAS ?=

################################################################################
$(foreach e,$(GRUNT_APT_EXTRAS),$(eval $(call GRUNT_INSTALL_APT_FILE,$(e))))
