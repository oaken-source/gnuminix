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


set -e
set -u

if [ -n "${DEBUG:-}" ]; then
  set -x
fi

# fetch LFS book
if [ ! -f LFS-BOOK-7.4.pdf ]; then
  echo " [*] fetching LFS-BOOK-7.4.pdf"
  wget -q http://www.linuxfromscratch.org/lfs/downloads/stable/LFS-BOOK-7.4.pdf
fi

# check for vagrant installation
if ! vagrant --help > /dev/null; then
  echo " [!] missing vagrant. install vagrant and continue"
  exit 1
fi

echo "done."
