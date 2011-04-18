# -*- mode: makefile-gmake -*-

################################################################################
.PHONY: grunt_directory_descender

################################################################################
GRUNT_MAKE_FLAGS = $(if $(DEBUG),--print-directory --debug=ji,--no-print-directory)

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
# $1: A list of directories to descend into
define GRUNT_DESCEND_INTO_DIRECTORIES
install: grunt_directory_descender
grunt_directory_descender:
	@ for d in $(1); do \
		$(MAKE) $(GRUNT_MAKE_FLAGS) -C $$$$d install \
		GRUNT_HOME=$(GRUNT_HOME) GRUNT_OS=$(GRUNT_OS) || exit 1; \
	done
endef
