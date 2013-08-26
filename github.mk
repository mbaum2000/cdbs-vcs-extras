# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
# Description: Convenience rules for pulling upstream tarballs from github
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
# github.  Note that this MUST come before  tarball.mk if that is
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

ifndef _cdbs_rules_vcs_github
_cdbs_rules_vcs_github = 1

_debug_variables := DEB_UPSTREAM_URL DEB_TAR_SRCDIR VCS_FETCH_TAG github_fetch_tag_mangle hosted_short_revision
include $(_cdbs_vcs_rules_path)/debug.mk$(_cdbs_makefile_suffix)

github_fetch_tag_mangle = $(shell echo $(VCS_FETCH_TAG) | sed 's/^v//')

VCS_FETCH_TAG ?= v$(VCS_UPSTREAM_VERSION)

DEB_UPSTREAM_URL ?= https://github.com/$(VCS_FETCH_USER)/$(VCS_FETCH_PROJECT)/$(if $(VCS_FETCH_REV),tarball,archive)
DEB_TAR_SRCDIR ?= $(if $(VCS_FETCH_REV),$(VCS_FETCH_USER)-$(VCS_FETCH_PROJECT)-$(hosted_short_revision),$(VCS_FETCH_PROJECT)-$(github_fetch_tag_mangle))

include $(_cdbs_vcs_rules_path)/git-hosted.mk$(_cdbs_makefile_suffix)

# Bitbucket uses a 7 character revision number for git.
hosted_short_revision = $(shell echo $(VCS_FETCH_REV) | cut -c-7)

# If the git-repo does not tag its releases, we need to hardcode
# the srcrev and hack the cdbs_upstream_tarball var so that it d/l's
# the tarball for that specific revision.
ifneq ($(strip $(VCS_FETCH_REV)),)
cdbs_upstream_tarball = $(VCS_FETCH_REV)
endif

endif #_cdbs_rules_vcs_github
