##############################################################################
APACHE_SERVER_ROOT = /etc/apache2

##############################################################################
install: $(APACHE_SERVER_ROOT)/.confd-stamp

$(APACHE_SERVER_ROOT)/.confd-stamp: $(wildcard conf.d/*)
	rsync -vctd --delete conf.d/ $(APACHE_SERVER_ROOT)/conf.d/
	chown root:root $(APACHE_SERVER_ROOT)/conf.d/*
	chmod 0444 $(APACHE_SERVER_ROOT)/conf.d/*
	touch $@

##############################################################################
install: $(APACHE_SERVER_ROOT)/.mods-enabled-stamp

$(APACHE_SERVER_ROOT)/.mods-enabled-stamp: modules
	sh activate-mods.sh $< $(APACHE_SERVER_ROOT)/mods-enabled
	touch $@

##############################################################################
install: $(APACHE_SERVER_ROOT)/apache2.conf

$(APACHE_SERVER_ROOT)/apache2.conf: httpd.conf
	install -o root -g root -m 0444 $< $@
	/etc/init.d/apache2 restart

##############################################################################
install: $(APACHE_SERVER_ROOT)/envvars

$(APACHE_SERVER_ROOT)/envvars: envvars
	install -o root -g root -m 0444 $< $@
	/etc/init.d/apache2 restart

##############################################################################
# Remove that default site file
DEFAULT_SITE = $(APACHE_SERVER_ROOT)/sites-enabled/000-default

ifeq ($(DEFAULT_SITE),$(wildcard $(DEFAULT_SITE)))
install:
	rm $(DEFAULT_SITE)
endif
