# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk

################################################################################
DARWIN_ETC_FILES = hosts shells

################################################################################
$(foreach f,$(DARWIN_ETC_FILES),$(eval $(call GRUNT_INSTALL_ETC_FILE,/etc/$(f))))
