# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk

################################################################################
GRUNT_YMLAUNCH_TOOL  ?= $(GRUNT_HOME)/darwin/bin/ymlaunch.rb
GRUNT_YMLAUNCH_OPTS  ?= --load
GRUNT_YMLAUNCH_FILES ?= $(wildcard *.yml)

################################################################################
define GRUNT_INSTALL_LAUNCHD_PLIST
install: $(2)
$(2): $(1)
	$(GRUNT_YMLAUNCH_TOOL) $(GRUNT_YMLAUNCH_OPTS) $(1)
endef

################################################################################
$(foreach f,$(GRUNT_YMLAUNCH_FILES),$(eval $(call GRUNT_INSTALL_LAUNCHD_PLIST,$(f),$(shell $(GRUNT_YMLAUNCH_TOOL) --list $(f)))))
