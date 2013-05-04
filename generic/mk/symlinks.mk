################################################################################
# Ensure a symbolic link exists.
#
# $1: Source file.
# $2: Destination link.
#
# TODO: Try to get this to make the links relative.
define GRUNT_MAKE_SYMLINK
install: $(2)
$(2): $(1)
	ln -nfs $(1) $(2)
endef
