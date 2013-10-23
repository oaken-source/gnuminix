#!/bin/bash

 ##############################################################################
 #                               GNU / Minix                                  #
 #                                                                            #
 #    Copyright (C) 2013  Andreas Grapentin                                   #
 #                                                                            #
 #    This program is free software: you can redistribute it and/or modify    #
 #    it under the terms of the GNU General Public License as published by    #
 #    the Free Software Foundation, either version 3 of the License, or       #
 #    (at your option) any later version.                                     #
 #                                                                            #
 #    This program is distributed in the hope that it will be useful,         #
 #    but WITHOUT ANY WARRANTY; without even the implied warranty of          #
 #    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           #
 #    GNU General Public License for more details.                            #
 #                                                                            #
 #    You should have received a copy of the GNU General Public License       #
 #    along with this program.  If not, see <http://www.gnu.org/licenses/>.   #
 ############################################################################## 

 # This script is the entry to the bootstrapping of GNU/Minix. This  script is
 # responsible for setting up the environment inside the virtual machine, e.g.
 # partitioning of the minix disk, mounting, user management, and calling the
 # build subscript.
 ############################################################################## 


set -e
set -u

if [ -n "${DEBUG:-}" ]; then
  set -x
fi


