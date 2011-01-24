# -*- mode: makefile-gmake -*-

################################################################################
# $1: The directory to create
# $2: Owner and group of new directory
define CREATE_USER_DIRECTORY
install: $(1)
$(1):
	mkdir -p $$@
	chown $(2):$(2) $$@
	chmod 0755 $(1)
endef

################################################################################
# $1: The name of the directory to create
define CREATE_ADMIN_ONLY_DIRECTORY
install: $(1)
$(1):
	mkdir -p $$@
	chown root:admin $$@
	chmod 2770 $$@
endef

################################################################################
$(eval $(call CREATE_ADMIN_ONLY_DIRECTORY,/opt/backup/postgresql))
