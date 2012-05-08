# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk

################################################################################
GRUNT_DEBIAN_BIN_DIR  ?= /usr/local/bin
GRUNT_DEBIAN_BOOT_DIR ?= /etc/init.d

################################################################################
# $1: The local path for the bin/script to install.
define GRUNT_DEBIAN_INSTALL_BIN
install: $(GRUNT_DEBIAN_BIN_DIR)/$(notdir $(1))
$(GRUNT_DEBIAN_BIN_DIR)/$(notdir $(1)): $(1)
	@ mkdir -p $(GRUNT_DEBIAN_BIN_DIR)
	$(GRUNT_INSTALL_ROOT_EXEC) $$< $$@
endef

################################################################################
# $1: The local path to the script to run at boot.
define GRUNT_DEBIAN_INSTALL_BOOT
install: $(GRUNT_DEBIAN_BOOT_DIR)/$(notdir $(1))
$(GRUNT_DEBIAN_BOOT_DIR)/$(notdir $(1)): $(1)
	$(GRUNT_INSTALL_ROOT_EXEC) $$< $$@
	update-rc.d $(notdir $(1)) defaults
endef
