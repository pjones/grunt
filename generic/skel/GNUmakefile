################################################################################
GRUNT_HOME = $(CURDIR)/grunt
include $(GRUNT_HOME)/generic/mk/boot.mk

################################################################################
DIRS  = $(if $(wildcard packages),packages,)
DIRS += $(shell find . -maxdepth 1 -type d -not -name .\* -not -name packages -not -name grunt|sort)

################################################################################
$(eval $(call GRUNT_DESCEND_INTO_DIRECTORIES,$(DIRS)))
