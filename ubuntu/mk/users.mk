# Create user accounts for all users in USERS_TO_CREATE
################################################################################
ifndef USERS_TO_CREATE
$(error You must set USERS_TO_CREATE before including users.mk)
endif

################################################################################
define NEW_USER_TEMPLATE
install: /home/$(1)
/home/$(1):
	adduser --disabled-password --gecos '' $(1)
endef

################################################################################
$(foreach user,$(USERS_TO_CREATE),$(eval $(call NEW_USER_TEMPLATE,$(user))))
