# -*- mode: makefile-gmake -*-

################################################################################
CRON_BASE_DIR = /var/spool/cron/crontabs

################################################################################
# $1 cron file in the form of <username>.crontab
define INSTALL_CRONTAB
install: $(CRON_BASE_DIR)/$(basename $(notdir $(1)))
$(CRON_BASE_DIR)/$(basename $(notdir $(1))): $(1)
	crontab -u $(basename $(notdir $(1))) $(1)
endef
