#!/bin/bash

## Copyright 2018 Maxwell Leisner

## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## File:	TigerOS-CI.sh
## Developer:	Maxwell Leisner
## GitHub:	CoffeeFrame
## Date:	2018-04-08
## Updated:	2018-04-25
## Description:	Script for automating the building of TigerOS images when changes are made to the code repository

## What this script needs to do:
##	- be called from python Github webhook listener
##
##	- if a package: check if the resulting file already exists, if it does delete it
##	- copr-rpmbuild the packages git repository
##	- copy resulting package from /var/lib/copr-rpmbuild/results/ into user directory
##	- delete results directory

## Do not use tigeros- package prefix, script adds it automatically
## Usage: TigerOS-CI.sh [Package]

PACKAGE=$1
FEDORAVER=27
if [ -e "/home/$USER/to-sign/tigeros-$PACKAGE-*.*rpm" ] 
then rm "/home/$USER/to-sign/tigeros-$PACKAGE-*.*rpm"
fi

sudo rm -rf /var/lib/copr-rpmbuild/results
sudo copr-rpmbuild scm --clone-url https://github.com/RITlug/tigeros-$PACKAGE --chroot fedora-$FEDORAVER-x86_64
mkdir --parents ~/to-sign
sudo cp /var/lib/copr-rpmbuild/results/tigeros-$PACKAGE*.rpm ~/to-sign
