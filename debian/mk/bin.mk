# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/files.mk

################################################################################
GRUNT_DEBIAN_BIN_DIR ?= /usr/local/bin

################################################################################
# $1: The local path for the bin/script to install.
define GRUNT_DEBIAN_INSTALL_BIN
install: $(GRUNT_DEBIAN_BIN_DIR)/$(notdir $(1))
$(GRUNT_DEBIAN_BIN_DIR)/$(notdir $(1)): $(1)
	@ mkdir -p $(GRUNT_DEBIAN_BIN_DIR)
	$(GRUNT_INSTALL_ROOT_EXEC) $$< $$@
endef
