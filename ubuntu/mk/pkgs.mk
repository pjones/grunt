# -*- mode: makefile-gmake -*-

################################################################################
install: /etc/.pkgs.stamp

################################################################################
/etc/.pkgs.stamp: packages/aptitude packages/gems
	sh $(GRUNT_OS)/bin/pkgs
	touch $@
