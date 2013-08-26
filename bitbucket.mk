# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
# Description: Convenience rules for pulling upstream tarballs from bitbucket
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
# sets up a get-orig-source target for downloading a source tarball from
# bitbucket.  Note that this MUST come before  tarball.mk if that is
# being used (despite the warning in tarball.mk that it must come first
# in the list of included rules).  Also, as a convenience, this rule
# will set the DEB_TARBALL and DEB_TAR_SRCDIR variables for use in
# tarball.mk.
####

_cdbs_scripts_path ?= /usr/lib/cdbs
_cdbs_rules_path ?= /usr/share/cdbs/1/rules
_cdbs_class_path ?= /usr/share/cdbs/1/class
_cdbs_vcs_rules_path ?= $(_cdbs_rules_path)
_cdbs_vcs_class_path ?= $(_cdbs_class_path)

ifndef _cdbs_rules_vcs_bitbucket
_cdbs_rules_vcs_bitbucket = 1

_debug_variables := DEB_UPSTREAM_URL hosted_short_revision
include $(_cdbs_vcs_rules_path)/debug.mk$(_cdbs_makefile_suffix)

# Setup the download url for the generated tarball from bitbucket.org.
DEB_UPSTREAM_URL ?= https://bitbucket.org/$(VCS_FETCH_USER)/$(VCS_FETCH_PROJECT)/get

include $(_cdbs_vcs_rules_path)/git-hosted.mk$(_cdbs_makefile_suffix)

# Bitbucket uses a 12 character revision number for git.
hosted_short_revision = $(shell echo $(VCS_FETCH_REV) | cut -c-12)

endif #_cdbs_rules_vcs_bitbucket
