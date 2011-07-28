################################################################################
GRUNT_PKG_FILES = $(wildcard *.pkgs)
GRUNT_PKG_TOUCH_DIR ?= /etc

################################################################################
define GRUNT_RUN_PACKAGE_INSTALLER
install: $(GRUNT_PKG_TOUCH_DIR)/$(1:.pkgs=.pkgs-installed)
$(GRUNT_PKG_TOUCH_DIR)/$(1:.pkgs=.pkgs-installed): $(1)
	@ $(GRUNT_HOME)/generic/bin/pkgs.sh $(1)
	@ touch $$@
endef

################################################################################
$(foreach f,$(GRUNT_PKG_FILES),$(eval $(call GRUNT_RUN_PACKAGE_INSTALLER,$f)))
