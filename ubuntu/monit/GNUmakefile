################################################################################
include ../mk/etc.mk

################################################################################
install: /etc/init/monit.conf

################################################################################
/etc/init/monit.conf: monit.conf
	$(INSTALL_READ_ONLY) $< $@
	rm -f /etc/init.d/monit
	- update-rc.d monit remove
	initctl reload-configuration
	initctl start monit
