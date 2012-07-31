# -*- mode: makefile-gmake -*-

################################################################################
include $(GRUNT_HOME)/generic/mk/init.mk

################################################################################
# Place a user in all the groups listed.  Removes the user from any
# groups not listed.  The list of groups doesn't need to include the
# private group named after the username.
#
# $1: The username
# $2: The list of groups
define GRUNT_SET_USER_GROUPS
.PHONEY: grunt_set_user_groups_for_$(1)
install: grunt_set_user_groups_for_$(1)
grunt_set_user_groups_for_$(1):
	@ $(GRUNT_HOME)/debian/bin/set-user-groups.sh $(1) $(2)
endef
