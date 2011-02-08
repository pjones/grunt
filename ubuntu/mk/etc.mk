# -*- mode: makefile-gmake -*-

################################################################################
INSTALL_READ_ONLY = install -o root -g root -m 0444
INSTALL_ROOT_ONLY = install -o root -g root -m 0400
INSTALL_ROOT_EXEC = install -o root -g root -m 0755
NTP_SRV_NAME = $(if $(wildcard /etc/init.d/openntpd),openntpd,ntp)

################################################################################
# $1 What directories to look in (e.g. 'etc' for all etc directories)
# $2 The base name of the file.
define FIND_FILE_IN_GRUNT
$(if $(wildcard $(2)),$(2),$(if $(wildcard $(GRUNT_OS)/$(1)/$(2)),$(GRUNT_OS)/$(1)/$(2),$(GRUNT_HOME)/generic/$(1)/$(2)))
endef

################################################################################
# $1: Full path to file to install
# $2: Optional command to run after the install
define INSTALL_ETC_FILE
install: $(1)
$(1): $(call FIND_FILE_IN_GRUNT,etc,$(notdir $(1)))
	$(INSTALL_READ_ONLY) $$< $$@
	$(if $(2),$(2),)
endef

################################################################################
# $1: Full path to the file to install
# $2: Optional command to run after the install
define INSTALL_PRIVATE_ETC_FILE
install: $(1)
$(1): $(call FIND_FILE_IN_GRUNT,etc,$(notdir $(1)))
	$(INSTALL_ROOT_ONLY) $$< $$@
	$(if $(2),$(2),)
endef

################################################################################
# $1: Full path to installed configuration file
# $2: Name of the service to restart
#
# That really long line below tries to find the source file:
#  1. In the current directory
#  2. In the ubuntu/etc directory
#  3. In the generic/etc directory
define SERVICE_CONF_TEMPLATE
install: $(1)
$(1): $(call FIND_FILE_IN_GRUNT,etc,$(notdir $(1)))
	$(INSTALL_READ_ONLY) $$< $$@
	/etc/init.d/$(2) restart
endef

################################################################################
# $1: The name of a directory in /etc/sv with a matching .sh file in this dir
define SV_SERVICE_CONF_TEMPLATE
install: /etc/sv/$(1)/run
/etc/sv/$(1)/run: $(1).sh
	install -o root -g root -m 0555 $$< $$@
	sv restart $(1)
endef
