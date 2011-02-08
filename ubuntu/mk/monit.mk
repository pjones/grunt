# -*- mode: makefile-gmake -*-
################################################################################
include $(GRUNT_OS)/mk/etc.mk

################################################################################
install: /etc/init/monit.conf

################################################################################
/etc/init/monit.conf: $(call FIND_FILE_IN_GRUNT,etc,monit.conf)
	$(INSTALL_ROOT_ONLY) $< $@
	rm -f /etc/init.d/monit
	- update-rc.d monit remove
	initctl reload-configuration
	initctl start monit
