################################################################################
# Functions to help configure the Apache web server.
include $(GRUNT_HOME)/generic/mk/symlinks.mk

################################################################################
GRUNT_APACHE_ETC ?= /etc/apache2
GRUNT_APACHE_MODS_AVAIL ?= $(GRUNT_APACHE_ETC)/mods-available
GRUNT_APACHE_MODS_ENABL ?= $(GRUNT_APACHE_ETC)/mods-enabled

################################################################################
# Enable a single Apache module.
define GRUNT_APACHE_ENABLE_MOD
  # Install the ".load" file.
  $(eval $(call GRUNT_MAKE_SYMLINK,\
    $(GRUNT_APACHE_MODS_AVAIL)/$(1).load,\
    $(GRUNT_APACHE_MODS_ENABL)/$(1).load))
  # Only install a ".conf" file if it exists.
  $(if $(wildcard $(GRUNT_APACHE_MODS_AVAIL)/$(1).conf),\
    $(eval $(call GRUNT_MAKE_SYMLINK,\
      $(GRUNT_APACHE_MODS_AVAIL)/$(1).conf,\
      $(GRUNT_APACHE_MODS_ENABL)/$(1).conf)))
endef

################################################################################
# Make sure that the given modules are enabled.
define GRUNT_APACHE_ENABLE_MODS
$(foreach f,$(1),$(eval $(call GRUNT_APACHE_ENABLE_MOD,$(f))))
endef
