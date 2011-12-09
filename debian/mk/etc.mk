# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk

################################################################################
GRUNT_NTP_SRV_NAME  = $(if $(wildcard /etc/init.d/openntpd),openntpd,ntp)

################################################################################
# $1: Full path to installed configuration file
# $2: Name of the service to restart
define GRUNT_SERVICE_CONF_TEMPLATE
install: $(1)
$(1): $(call GRUNT_FIND_SOURCE_FILE,etc,$(notdir $(1)))
	$(GRUNT_INSTALL_READ_ONLY) $$< $$@
	-service $(2) stop > /dev/null 2>&1
	service $(2) start
endef

################################################################################
# $1: The name of a directory in /etc/sv with a matching .sh file in this dir
define SV_GRUNT_SERVICE_CONF_TEMPLATE
install: /etc/sv/$(1)/run
/etc/sv/$(1)/run: $(1).sh
	install -o root -g root -m 0555 $$< $$@
	sv restart $(1)
endef

################################################################################
# Install a /etc/hostname file
define GRUNT_DEBIAN_HOSTNAME
install: /etc/hostname
/etc/hostname: hostname
	$(GRUNT_INSTALL_READ_ONLY) $$< $$@
	hostname --file $$@
endef

################################################################################
# Install some actual files.
$(eval $(if $(wildcard hostname),$(call GRUNT_DEBIAN_HOSTNAME),))
$(eval $(if $(wildcard hosts),$(call GRUNT_INSTALL_ETC_FILE,/etc/hosts),))
$(eval $(call GRUNT_SERVICE_CONF_TEMPLATE,/etc/ssh/sshd_config,ssh))
$(eval $(if $(wildcard interfaces),$(call GRUNT_SERVICE_CONF_TEMPLATE,/etc/network/interfaces,networking),))
