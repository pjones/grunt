# -*- mode: makefile-gmake -*-

################################################################################
INSTALL_READ_ONLY = install -o root -g root -m 0444
NTP_SRV_NAME = $(if $(wildcard /etc/init.d/openntpd),openntp,ntp)

################################################################################
# $1: Full path to file to install
define INSTALL_ETC_FILE
install: $(1)
$(1): $(notdir $(1))
	$(INSTALL_READ_ONLY) $$< $$@
endef

################################################################################
# $1: Full path to installed configuration file
# $2: Name of the service to restart
define SERVICE_CONF_TEMPLATE
install: $(1)
$(1): $(notdir $(1))
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

################################################################################
$(eval $(call SERVICE_CONF_TEMPLATE,/etc/ntp.conf,$(NTP_SRV_NAME)))
$(eval $(call SERVICE_CONF_TEMPLATE,/etc/ssh/sshd_config,ssh))
