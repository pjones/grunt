# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk

################################################################################
GRUNT_APT_PREF_DIR = /etc/apt/preferences.d
GRUNT_APT_LIST_DIR = /etc/apt/sources.list.d

################################################################################
GRUNT_APT_PREF_FILES = $(wildcard *.pref)
GRUNT_APT_LIST_FILES = $(wildcard *.list)

################################################################################
$(eval $(foreach p,$(GRUNT_APT_PREF_FILES),$(call GRUNT_INSTALL_ETC_FILE,$(GRUNT_APT_PREF_DIR)/$(p))))
$(eval $(foreach l,$(GRUNT_APT_LIST_FILES),$(call GRUNT_INSTALL_ETC_FILE,$(GRUNT_APT_LIST_DIR)/$(l))))
