# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
# Description: Defines rules for creating upstream tarballs from a vcs
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

ifndef _cdbs_rules_vcs_fetch
_cdbs_rules_vcs_fetch = 1

_debug_variables := DEB_UPSTREAM_WORKDIR DEB_TARBALL DEB_TAR_SRCDIR VCS_TARBALL_WORKDIR_ROOT VCS_TARBALL_WORKDIR VCS_TARBALL_EXTENSION VCS_FETCH_SRC vcs_base_stamps vcs_base_components vcs_clean_src_uris vcs_clean_base_stamps
include $(_cdbs_vcs_rules_path)/debug.mk$(_cdbs_makefile_suffix)

include $(_cdbs_vcs_rules_path)/vcs-vars.mk$(_cdbs_makefile_suffix)

DEB_UPSTREAM_WORKDIR ?= ../tarballs
DEB_TAR_SRCDIR ?= $(DEB_SOURCE_PACKAGE)-$(VCS_UPSTREAM_REVISION)

ifeq ($(VCS_FETCH_SRC),)
$(error VCS_FETCH_SRC must be specified)
endif

VCS_TARBALL_WORKDIR_ROOT = $(DEB_UPSTREAM_WORKDIR)/dfsg/
VCS_TARBALL_WORKDIR = $(VCS_TARBALL_WORKDIR_ROOT)$(DEB_TAR_SRCDIR)
VCS_TARBALL_EXTENSION ?= tar.gz

vcs_base_stamps := $(strip $(shell echo $(VCS_FETCH_SRC) | sed 's/\(^\| \)\($(vcs_types_regexp)\)+/ /g'))
vcs_base_components := $(notdir $(basename $(VCS_FETCH_SRC)))
vcs_clean_src_uris := $(shell echo $(VCS_FETCH_SRC) | tr :/ _)
vcs_clean_base_stamps := $(shell echo $(vcs_base_stamps) | tr :/ _)

vcs_fn_index = $(shell echo '$(2)' | awk -v v='$(strip $(1))' '{split($$0,a); for(i=NF;i>0;i--) if(a[i]==v) {break}} END {print i}')

# If there are multiple source uri's to fetch, then create an
# <source>_<version>.orig-<component>.tar.{gz,bz2,lzma,xz} as used by
# Debian Source Format 3.0 (quilt).
# http://wiki.debian.org/Projects/DebSrc3.0
ifeq ($(words $(vcs_base_components)),1)
DEB_TARBALL := $(DEB_UPSTREAM_WORKDIR)/$(DEB_SOURCE_PACKAGE)_$(DEB_UPSTREAM_VERSION).orig.$(VCS_TARBALL_EXTENSION)
else
DEB_TARBALL := $(vcs_base_components:%=$(DEB_UPSTREAM_WORKDIR)/$(DEB_SOURCE_PACKAGE)_$(DEB_UPSTREAM_VERSION).orig-%.$(VCS_TARBALL_EXTENSION))
endif

_part_getword = $(word $(call vcs_fn_index,$@,
_part_base_stamps = ),$(vcs_base_stamps))
_part_base_components = ),$(vcs_base_components))
_part_deb_tarball = ),$(DEB_TARBALL))

# Setup variables to be used inside the target for each source to fetch.
define _SETUP_TARGET_VARS
$(1): src_uri = $(value _part_getword)$(1)$(value _part_base_stamps)
$(1): component = $(value _part_getword)$(1)$(value _part_base_components)
$(1): create_tarball = $(value _part_getword)$(1)$(value _part_deb_tarball)

endef
$(foreach vcs_type,$(vcs_types_known),$(eval $(vcs_type)_stamps := $(addprefix debian/stamps-$(vcs_type)+,$(vcs_clean_base_stamps))))
$(foreach vcs_type,$(vcs_types_known),$(eval $(call _SETUP_TARGET_VARS,$(value $(vcs_type)_stamps))))

get-orig-source: $(DEB_TARBALL)

$(DEB_TARBALL): $(addprefix debian/stamps-,$(vcs_clean_src_uris))

# Commands to compress the fetched sources into the desired package.
vcs_fn_compress_tar = tar -b1 -C $(3) -c -f $(1) $(2)/
vcs_fn_compress_tar.gz = GZIP=-9 tar -b1 -C $(3) -c -z -f $(1) $(2)/
vcs_fn_compress_tgz = $(vcs_fn_compress_tar.gz)
vcs_fn_compress_tar.bz2 = BZIP2=-9 tar -b1 -C $(3) -c -j -f $(1) $(2)/
vcs_fn_compress_tbz2 = $(vcs_fn_compress_tar.bz2)
vcs_fn_compress_tar.bz = $(vcs_fn_compress_tar.bz2)
vcs_fn_compress_tbz = $(vcs_fn_compress_tar.bz2)
vcs_fn_compress_tar.lzma = XZ_OPT=-9 tar -b1 -C $(3) -c --lzma -f $(1) $(2)/

cleanbuilddir::
	rm -f $(addprefix debian/stamps-,$(vcs_clean_src_uris))
	rm -rf $(VCS_TARBALL_WORKDIR_ROOT)
	
endif #_cdbs_rules_vcs_fetch
