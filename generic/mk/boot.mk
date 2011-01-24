# -*- mode: makefile-gmake -*-

################################################################################
GRUNT_OS = $(GRUNT_HOME)/$(shell sh $(GRUNT_HOME)/bin/detectos.sh)

################################################################################
include $(GRUNT_HOME)/generic/mk/dirs.mk
