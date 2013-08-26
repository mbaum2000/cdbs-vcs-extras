# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
# Description: Convenience rules for creating upstream tarballs from svn
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

####
# sets up a get-orig-source target for downloading and creating a source
# tarball from an upstream svn server.  Note that this MUST come before
# tarball.mk if that is being used (despite the warning in tarball.mk
# that it must come first in the list of included rules.  Also, as a
# convenience, this rule will set the DEB_TARBALL and DEB_TAR_SRCDIR
# variables for use in tarball.mk.
####

_cdbs_scripts_path ?= /usr/lib/cdbs
_cdbs_rules_path ?= /usr/share/cdbs/1/rules
_cdbs_class_path ?= /usr/share/cdbs/1/class
_cdbs_vcs_rules_path ?= $(_cdbs_rules_path)
_cdbs_vcs_class_path ?= $(_cdbs_class_path)

ifndef _cdbs_rules_vcs_fetch_svn
_cdbs_rules_vcs_fetch_svn = 1

_debug_variables := SVN_UPSTREAM_REVISION
include $(_cdbs_vcs_rules_path)/debug.mk$(_cdbs_makefile_suffix)

include $(_cdbs_vcs_rules_path)/vcs-fetch.mk$(_cdbs_makefile_suffix)

$(svn_stamps):
	svn export $(src_uri) $(VCS_TARBALL_WORKDIR) $(if $(SVN_UPSTREAM_REVISION),-r $(SVN_UPSTREAM_REVISION))
	$(call vcs_fn_compress_$(VCS_TARBALL_EXTENSION),$(create_tarball),$(DEB_TAR_SRCDIR),$(VCS_TARBALL_WORKDIR_ROOT))
	rm -rf $(VCS_TARBALL_WORKDIR_ROOT)
	touch $@

endif #_cdbs_rules_vcs_fetch_svn
