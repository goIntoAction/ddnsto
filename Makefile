#
# Copyright (C) 2015-2016 OpenWrt.org
# Copyright (C) 2020 jjm2473@gmail.com
#
# This is free software, licensed under the GNU General Public License v3.
#

include $(TOPDIR)/rules.mk

PKG_ARCH_DDNSTO:=$(ARCH)

PKG_NAME:=ddnsto
PKG_VERSION:=3.0.4
PKG_RELEASE:=$(PKG_ARCH_DDNSTO)-7
PKG_SOURCE:=$(PKG_NAME)-binary-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://fw.koolcenter.com/binary/ddnsto/
PKG_HASH:=486aa15a5e026b5a3aca72f1850746e127a7e86ef11db8a7c498dad29545eaf6

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-binary-$(PKG_VERSION)

PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Web Servers/Proxies
	TITLE:=DDNS.to - the reverse proxy
	DEPENDS:=
	PKGARCH:=all
	URL:=https://www.ddnsto.com/
endef

define Package/$(PKG_NAME)/description
  DDNS.to is a reverse proxy
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/ddnsto
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	[ -f /etc/uci-defaults/ddnsto ] && /etc/uci-defaults/ddnsto && rm -f /etc/uci-defaults/ddnsto
	exit 0
fi
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/config $(1)/etc/init.d $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ddnsto.$(PKG_ARCH_DDNSTO) $(1)/usr/sbin/ddnstod
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ddwebdav.$(PKG_ARCH_DDNSTO) $(1)/usr/sbin/ddwebdav
	$(INSTALL_CONF) ./files/ddnsto.config $(1)/etc/config/ddnsto
	$(INSTALL_BIN) ./files/ddnsto.init $(1)/etc/init.d/ddnsto
	$(INSTALL_BIN) ./files/ddnsto.uci-default $(1)/etc/uci-defaults/ddnsto
	$(LN) /usr/sbin/ddnstod $(1)/usr/sbin/ddnsto
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
