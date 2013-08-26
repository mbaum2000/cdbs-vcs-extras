# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
# Description: Defines rules to aid in debugging
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

ifeq ($(CDBS_VCS_DEBUG_DISABLE),)

_debug_makefile_name := $(lastword $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

ifndef _cdbs_rules_debug
_cdbs_rules_debug = 1

define _PRINT_DEBUG_VARIABLE
	@echo -e '\t$(1) = "$($(1))"'

endef

define _PRINT_DEBUG_VARIABLE_UNEXPAND
	@echo -e '\t$(1) = "$(value $(1))"'

endef

_global_cdbs_vars = _cdbs_scripts_path _cdbs_rules_path _cdbs_class_path _cdbs_vcs_rules_path _cdbs_vcs_class_path _cdbs_makefile_suffix

# Convenience rules to dump all debug info
debug/print-all: debug/print-all-vars debug/print-all-vars-unexpand

debug/print-all-vars: debug_variables := $(_global_cdbs_vars)
debug/print-all-vars::
	@echo Global Variables:
	$(foreach var,$(debug_variables),$(call _PRINT_DEBUG_VARIABLE,$(var)))
	@echo

debug/print-all-vars-unexpand: debug_variables := $(_global_cdbs_vars)
debug/print-all-vars-unexpand::
	@echo $(debug_makefile_name) Unexpanded Variables:
	$(foreach var,$(debug_variables),$(call _PRINT_DEBUG_VARIABLE_UNEXPAND,$(var)))
	@echo

endif #_cdbs_rules_debug

_debug_class_name = $(notdir $(basename $(_debug_makefile_name)))

# Rule to print variable names and values used by the file that included
# this file.
debug/print-all-vars:: debug/print-$(_debug_class_name)-vars

debug/print-$(_debug_class_name)-vars: debug_makefile_name := $(_debug_makefile_name)
debug/print-$(_debug_class_name)-vars: debug_variables := $(_debug_variables)
debug/print-$(_debug_class_name)-vars:
	@echo $(debug_makefile_name) Variables:
	$(foreach var,$(debug_variables),$(call _PRINT_DEBUG_VARIABLE,$(var)))
	@echo

# Rule to print variable names and unexpanded values used by the file
# that included this file.
debug/print-all-vars-unexpand:: debug/print-$(_debug_class_name)-vars-unexpand

debug/print-$(_debug_class_name)-vars-unexpand: debug_makefile_name := $(_debug_makefile_name)
debug/print-$(_debug_class_name)-vars-unexpand: debug_variables := $(_debug_variables)
debug/print-$(_debug_class_name)-vars-unexpand:
	@echo $(debug_makefile_name) Unexpanded Variables:
	$(foreach var,$(debug_variables),$(call _PRINT_DEBUG_VARIABLE_UNEXPAND,$(var)))
	@echo

endif #($(CDBS_VCS_DEBUG_DISABLE),)

# Make sure to unset these to avoid taint whenever this file is
# included again.
_debug_makefile_name =
_debug_variables =
