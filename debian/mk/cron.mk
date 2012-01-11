# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk

################################################################################
GRUNT_CRON_SPOOL = /var/spool/cron/crontabs
GRUNT_CRONT_TAB_FILES = $(wildcard *.crontab)

################################################################################
# $1 should be the source crontab file like: pjones.crontab.
define GRUNT_INSTALL_CRON_TAB_FILE
all: $(GRUNT_CRON_SPOOL)/$(basename $(1))
$(GRUNT_CRON_SPOOL)/$(basename $(1)): $(1)
	crontab -u $(basename $(1)) $(1)
endef

################################################################################
$(eval $(foreach f,$(GRUNT_CRONT_TAB_FILES),$(call GRUNT_INSTALL_CRON_TAB_FILE,$(f))))
