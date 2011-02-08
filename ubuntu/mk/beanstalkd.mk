# -*- mode: makefile-gmake -*-
################################################################################
include $(GRUNT_OS)/mk/etc.mk

################################################################################
BEANSTALKD_BIN = /usr/sbin/beanstalkd
BEANSTALKD_VERION = 1.4.6
BEANSTALKD_URL = http://xph.us/dist/beanstalkd/beanstalkd-$(BEANSTALKD_VERION).tar.gz

################################################################################
BEANMASTER_BIN = $(dir $(BEANSTALKD_BIN))/beanmaster
BEANMASTER_SRC = $(GRUNT_HOME)/generic/bin/beanmaster

################################################################################
install: $(BEANSTALKD_BIN) $(BEANMASTER_BIN)

################################################################################
$(BEANSTALKD_BIN):
	wget --no-check-certificate $(BEANSTALKD_URL)
	tar -xf `basename $(BEANSTALKD_URL)`
	(cd `basename $(BEANSTALKD_URL) .tar.gz` && \
		sh configure && make && \
		$(INSTALL_READ_ONLY) beanstalkd $@)
	rm `basename $(BEANSTALKD_URL)`
	rm -r `basename $(BEANSTALKD_URL) .tar.gz`

################################################################################
$(BEANMASTER_BIN): $(BEANMASTER_SRC)
	$(INSTALL_ROOT_EXEC) $< $@

################################################################################
$(eval $(call INSTALL_ETC_FILE,/etc/monit/conf.d/beanstalkd.monit.rc,monit reload))
