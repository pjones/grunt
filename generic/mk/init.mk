# -*- mode: makefile-gmake -*-

################################################################################
.PHONY: install

################################################################################
$(if $(GRUNT_OS),,$(eval include $(GRUNT_HOME)/generic/mk/os.mk))

################################################################################
include $(GRUNT_HOME)/generic/mk/dirs.mk
include $(GRUNT_HOME)/generic/mk/files.mk
