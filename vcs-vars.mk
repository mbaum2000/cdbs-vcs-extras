# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
# Description: Defines some useful variables for dealing with upstream vcs's
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

ifndef _cdbs_rules_vcs_vars
_cdbs_rules_vcs_vars = 1

_debug_variables := DEB_VCS_UPSTREAM_VERSION DEB_VCS_UPSTREAM_REVISION DEB_VCS_UPSTREAM_TYPE VCS_UPSTREAM_VERSION VCS_UPSTREAM_REVISION VCS_UPSTREAM_TYPE vcs_types_known vcs_types_regexp vcs_changelog_regexp
include $(_cdbs_vcs_rules_path)/debug.mk$(_cdbs_makefile_suffix)

include $(_cdbs_rules_path)/buildvars.mk$(_cdbs_makefile_suffix)

# Look in the rules directory for all fetchers available and populate
# vcs_types_known based on what we find.  This allows up to add new
# vcs types in the future simply by creating a vcs-fetch-<name>.mk file.
vcs_types_known := $(patsubst vcs-fetch-%.mk$(_cdbs_makefile_suffix),%,$(notdir $(wildcard $(_cdbs_vcs_rules_path)/vcs-fetch-*.mk$(_cdbs_makefile_suffix))))
vcs_types_regexp := \($(subst $(space),\|,$(vcs_types_known))\)
vcs_changelog_regexp := ^.*\(+$(vcs_types_regexp)\(.*\)\|$$\)

# Grab the upstream info from the package version:
# <tag>[+<vcs-type><revision>][-debian_revision]
DEB_VCS_UPSTREAM_VERSION := $(shell echo $(DEB_UPSTREAM_VERSION) | sed 's/+$(vcs_types_regexp).*$$//')
DEB_VCS_UPSTREAM_REVISION := $(shell echo $(DEB_UPSTREAM_VERSION) | sed 's/$(vcs_changelog_regexp)/\3/')
DEB_VCS_UPSTREAM_TYPE := $(shell echo $(DEB_UPSTREAM_VERSION) | sed 's/$(vcs_changelog_regexp)/\2/')

# But allow them to be overridden with these variables:
VCS_UPSTREAM_VERSION ?= $(DEB_VCS_UPSTREAM_VERSION)
VCS_UPSTREAM_REVISION ?= $(DEB_VCS_UPSTREAM_REVISION)
VCS_UPSTREAM_TYPE ?= $(DEB_VCS_UPSTREAM_TYPE)

# Create a <VCS-NAME>_UPSTREAM_REVISION variable for the current type,
# for example, if the type is "git", then set GIT_UPSTREAM_REVISION.
$(shell echo $(VCS_UPSTREAM_TYPE) | tr [a-z] [A-Z])_UPSTREAM_REVISION ?= $(VCS_UPSTREAM_REVISION)

endif #_cdbs_rules_vcs_vars
