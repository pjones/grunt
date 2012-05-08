################################################################################
GRUNT_ROOT_USER  = $(shell grep :0:0: /etc/passwd | awk -F: '{print $$1}')
GRUNT_ROOT_GROUP = $(shell grep :0:   /etc/group  | awk -F: '{print $$1}')

################################################################################
GRUNT_INSTALL_READ_ONLY = install -o $(GRUNT_ROOT_USER) -g $(GRUNT_ROOT_GROUP) -m 0444
GRUNT_INSTALL_ROOT_ONLY = install -o $(GRUNT_ROOT_USER) -g $(GRUNT_ROOT_GROUP) -m 0400
GRUNT_INSTALL_ROOT_EXEC = install -o $(GRUNT_ROOT_USER) -g $(GRUNT_ROOT_GROUP) -m 0755

################################################################################
# $1: Full path to the target file
# $2: Local file name (optional, defaults to $(notdir $(2)))
# $3: Optional command to run after the install
define GRUNT_INSTALL_PLAIN_FILE
install: $(1)
$(1): $(if $(2),$(2),$(notdir $(1)))
	$(GRUNT_INSTALL_READ_ONLY) $$< $$@
	$(if $(3),$(3),)
endef

################################################################################
# $1: Full path to the target file
# $2: Local file name (optional, defaults to $(notdir $(2)))
# $3: Optional command to run after the install
define GRUNT_INSTALL_ROOT_BIN_FILE
install: $(1)
$(1): $(if $(2),$(2),$(notdir $(1)))
	$(GRUNT_INSTALL_ROOT_EXEC) $$< $$@
	$(if $(3),$(3),)
endef


################################################################################
# DEPRECATED: please use VPATH instead.
#
# $1 What directories to look in (e.g. 'etc' for all etc directories)
# $2 The base name of the file.
#
# That really long line below tries to find the source file:
#  1. In the current directory
#  2. In the <os>/$1 directory
#  3. In the generic/$1 directory
define GRUNT_FIND_SOURCE_FILE
$(if $(wildcard $(2)),$(2),$(if $(wildcard $(GRUNT_OS)/$(1)/$(2)),$(GRUNT_OS)/$(1)/$(2),$(GRUNT_HOME)/generic/$(1)/$(2)))
endef

################################################################################
# DEPRECATED: please use VPATH with GRUNT_INSTALL_PLAIN_FILE instead.
#
# $1: Full path to file to install
# $2: Optional command to run after the install
define GRUNT_INSTALL_ETC_FILE
install: $(1)
$(1): $(call GRUNT_FIND_SOURCE_FILE,etc,$(notdir $(1)))
	$(GRUNT_INSTALL_READ_ONLY) $$< $$@
	$(if $(2),$(2),)
endef

################################################################################
# DEPRECATED: please use VPATH instead.
#
# $1: Full path to the file to install
# $2: Optional command to run after the install
define GRUNT_INSTALL_PRIVATE_ETC_FILE
install: $(1)
$(1): $(call GRUNT_FIND_SOURCE_FILE,etc,$(notdir $(1)))
	$(GRUNT_INSTALL_ROOT_ONLY) $$< $$@
	$(if $(2),$(2),)
endef
