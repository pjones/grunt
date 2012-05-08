# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk

################################################################################
VPATH = $(GRUNT_HOME)/generic/etc

################################################################################
GRUNT_NTP_SRV_NAME  = $(if $(wildcard /etc/init.d/openntpd),openntpd,ntp)

################################################################################
# $1: Full path to installed configuration file
# $2: Name of the service to restart
define GRUNT_SERVICE_CONF_TEMPLATE
install: $(1)
$(1): $(notdir $(1))
	$(GRUNT_INSTALL_READ_ONLY) $$< $$@
	-service $(2) stop > /dev/null 2>&1
	service $(2) start
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
# TODO: What is this for?
# $1: The name of a directory in /etc/sv with a matching .sh file in this dir
define SV_GRUNT_SERVICE_CONF_TEMPLATE
install: /etc/sv/$(1)/run
/etc/sv/$(1)/run: $(1).sh
	install -o root -g root -m 0555 $$< $$@
	sv restart $(1)
endef

################################################################################
# Files to install.

# File: default.keyboard  Destination: /etc/default/keyboard
$(eval $(if $(wildcard default.keyboard),$(call GRUNT_INSTALL_PLAIN_FILE,/etc/default/keyboard,default.keyboard)))

# File: hostname  Destination: /etc/hostname  Extra: Call hostname(1)
$(eval $(if $(wildcard hostname),$(call GRUNT_DEBIAN_HOSTNAME),))

# File: hosts  Destination: /etc/hosts
$(eval $(if $(wildcard hosts),$(call GRUNT_INSTALL_PLAIN_FILE,/etc/hosts),))

# File: interfaces  Destination: /etc/network/interfaces  Extra: restart networking
ifeq ($(GRUNT_DEBIAN_RESTART_NETWORK),YES)
  $(eval $(if $(wildcard interfaces),$(call GRUNT_SERVICE_CONF_TEMPLATE,/etc/network/interfaces,networking),))
else
  $(eval $(if $(wildcard interfaces),$(call GRUNT_INSTALL_PLAIN_FILE,/etc/network/interfaces)))
endif

# File: sshd_config  Destination: /etc/ssh/sshd_config  Extra: restart sshd
$(eval $(call GRUNT_SERVICE_CONF_TEMPLATE,/etc/ssh/sshd_config,ssh))
