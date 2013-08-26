# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
# Description: Defines rules for creating upstream tarballs from a hosted git service
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
# tarball from a hosted git service.  Note that this MUST come before
# tarball.mk if that is being used (despite the warning in tarball.mk
# that it must come first in the list of included rules).  Also, as a
# convenience, this rule will set the DEB_TARBALL and DEB_TAR_SRCDIR
# variables for use in tarball.mk.
####

_cdbs_scripts_path ?= /usr/lib/cdbs
_cdbs_rules_path ?= /usr/share/cdbs/1/rules
_cdbs_class_path ?= /usr/share/cdbs/1/class
_cdbs_vcs_rules_path ?= $(_cdbs_rules_path)
_cdbs_vcs_class_path ?= $(_cdbs_class_path)

ifndef _cdbs_rules_vcs_git_hosted
_cdbs_rules_vcs_git_hosted = 1

_debug_variables := DEB_TARBALL DEB_TAR_SRCDIR DEB_UPSTREAM_TARBALL_BASENAME DEB_UPSTREAM_TARBALL_EXTENSION DEB_UPSTREAM_WORKDIR VCS_FETCH_USER VCS_FETCH_PROJECT VCS_FETCH_TAG VCS_FETCH_REV cdbs_upstream_tarball hosted_short_revision
include $(_cdbs_vcs_rules_path)/debug.mk$(_cdbs_makefile_suffix)

include $(_cdbs_rules_path)/buildvars.mk$(_cdbs_makefile_suffix)

ifeq ($(VCS_FETCH_USER),)
$(error VCS_FETCH_USER must be specified)
endif
ifeq ($(VCS_FETCH_PROJECT),)
$(error VCS_FETCH_PROJECT must be specified)
endif

VCS_FETCH_TAG ?= $(VCS_UPSTREAM_VERSION)
VCS_FETCH_REV ?= $(VCS_UPSTREAM_REVISION)

DEB_UPSTREAM_TARBALL_BASENAME ?= $(if $(hosted_short_revision),$(hosted_short_revision),$(VCS_FETCH_TAG))
DEB_UPSTREAM_TARBALL_EXTENSION ?= tar.gz

DEB_TAR_SRCDIR ?= $(if $(VCS_FETCH_REV),$(VCS_FETCH_USER)-$(VCS_FETCH_PROJECT)-$(hosted_short_revision),$(VCS_FETCH_PROJECT)-$(VCS_FETCH_TAG))
DEB_TARBALL ?= $(DEB_UPSTREAM_WORKDIR)/$(DEB_SOURCE_PACKAGE)_$(DEB_UPSTREAM_VERSION).orig.$(DEB_UPSTREAM_TARBALL_EXTENSION)

# Under the hood, we use upstream-tarball.mk to pull a generated
# tarball for the particular revision/tag from the hosted git service.
include $(_cdbs_rules_path)/upstream-tarball.mk$(_cdbs_makefile_suffix)
include $(_cdbs_vcs_rules_path)/vcs-vars.mk$(_cdbs_makefile_suffix)

hosted_short_revision ?= $(VCS_FETCH_REV)

endif #_cdbs_rules_vcs_git_hosted
