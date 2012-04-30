GRUNT_DEBIAN_VERSION = $(shell awk '{print $$3}' /etc/issue)

ifeq ($(GRUNT_DEBIAN_VERSION),5.0)
  GRUNT_DEBIAN_CODENAME = lenny
else ifeq ($(GRUNT_DEBIAN_VERSION),6.0)
  GRUNT_DEBIAN_CODENAME = squeeze
else ifeq ($(GRUNT_DEBIAN_VERSION),7.0)
  GRUNT_DEBIAN_CODENAME = wheezy
else ifeq ($(GRUNT_DEBIAN_VERSION),wheezy/sid)
  GRUNT_DEBIAN_CODENAME = wheezy
else ifeq ($(GRUNT_DEBIAN_VERSION),sid)
  GRUNT_DEBIAN_CODENAME = sid
else
  GRUNT_DEBIAN_CODENAME = debian-unknown
endif
