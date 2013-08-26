# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
# Description: Sets up links using Debian's alternatives system
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

_cdbs_scripts_path ?= /usr/lib/cdbs
_cdbs_rules_path ?= /usr/share/cdbs/1/rules
_cdbs_class_path ?= /usr/share/cdbs/1/class
_cdbs_vcs_rules_path ?= $(_cdbs_rules_path)
_cdbs_vcs_class_path ?= $(_cdbs_class_path)

ifndef _cdbs_rules_vcs_alternatives
_cdbs_rules_vcs_alternatives = 1

_debug_variables := ALTERNATIVES_LINK ALTERNATIVES_NAME ALTERNATIVES_PATH ALTERNATIVES_PRIORITY ALTERNATIVES_PACKAGE
include $(_cdbs_vcs_rules_path)/debug.mk$(_cdbs_makefile_suffix)

include $(_cdbs_rules_path)/buildvars.mk$(_cdbs_makefile_suffix)

ifeq ($(ALTERNATIVES_LINK),)
$(error ALTERNATIVES_LINK must be specified)
endif
ifeq ($(ALTERNATIVES_NAME),)
$(error ALTERNATIVES_NAME must be specified)
endif
ifeq ($(ALTERNATIVES_PATH),)
$(error ALTERNATIVES_PATH must be specified)
endif

ALTERNATIVES_PRIORITY ?= 1
ALTERNATIVES_PACKAGE ?= $(firstword $(DEB_PACKAGES))

# Add script snippets to the (postinst|prerm).debhelper scripts to
# configure alternatives rules.  This should really be in a
# dh_alternatives script or something.
common-binary-arch::
	echo '# Automatically added by debian/rules' \
	     '\nif [ "$$1" = "configure" ];then' \
	     '\n\tif which update-alternatives >/dev/null 2>&1; then' \
	     '\n\t\tupdate-alternatives --install $(ALTERNATIVES_LINK) $(ALTERNATIVES_NAME) $(ALTERNATIVES_PATH) $(ALTERNATIVES_PRIORITY)' \
	     '\n\tfi' \
	     '\nfi' \
	     '\n# End automatically added section' >> debian/$(ALTERNATIVES_PACKAGE).postinst.debhelper
	echo '# Automatically added by debian/rules' \
	     '\nif which update-alternatives >/dev/null 2>&1; then' \
	     '\n\tupdate-alternatives --remove $(ALTERNATIVES_NAME) $(ALTERNATIVES_PATH)' \
	     '\nfi' \
	     '\n# End automatically added section' >> debian/$(ALTERNATIVES_PACKAGE).prerm.debhelper

endif #_cdbs_rules_vcs_alternatives
