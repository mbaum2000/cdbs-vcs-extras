#!/usr/bin/make -f
# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2013 Mike Baum <mb694@cairn.edu>
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

CDBS1_DIR = $(DESTDIR)/usr/share/cdbs/1
RULES_DIR = $(CDBS1_DIR)/rules
CLASS_DIR = $(CDBS1_DIR)/class

RULES_FILES = alternatives.mk autofetch.mk bitbucket.mk debug.mk git-hosted.mk github.mk vcs-fetch.mk vcs-fetch-git.mk vcs-fetch-svn.mk vcs-vars.mk
CLASS_FILES = 

define NL


endef

build:

clean:

install:
	$(foreach rules,$(RULES_FILES),install -D $(rules) $(RULES_DIR)/$(notdir $(rules))$(NL))
	$(foreach class,$(CLASS_FILES),install -D $(class) $(CLASS_DIR)/$(notdir $(class))$(NL))

uninstall:
	$(foreach rules,$(RULES_FILES),rm -f $(RULES_DIR)/$(notdir $(rules))$(NL))
	$(foreach class,$(CLASS_FILES),rm -f $(CLASS_DIR)/$(notdir $(class))$(NL))
	rmdir --ignore-fail-on-non-empty --parents $(RULES_DIR)
	rmdir --ignore-fail-on-non-empty --parents $(CLASS_DIR)
