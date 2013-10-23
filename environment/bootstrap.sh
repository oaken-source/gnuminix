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

# installing required packages
echo " [*] installing and configuring required host packages"
apt-get update -qq
apt-get install -yqq vim build-essential bash binutils bison bzip2 coreutils diffutils findutils gawk gcc libc6 grep gzip m4 make patch perl sed tar texinfo xzip  &> /dev/null
ln -fs /bin/bash /bin/sh

echo " [*] preparing and mounting partitions"
mkdir -p /mnt/gnu
if [ -z "$(cat /etc/mtab | grep /mnt/gnu)" ]; then
  parted -s -- /dev/sdb mklabel gpt
  parted -s -- /dev/sdb mkpart primary ext2 0 32mb &> /dev/null
  parted -s -- /dev/sdb mkpart primary linux-swap 32mb 1056mb
  parted -s -- /dev/sdb mkpart primary ext3 1056mb -1

  mkfs.ext2 -q /dev/sdb1
  mkfs.ext3 -q /dev/sdb3
  mkswap /dev/sdb2 > /dev/null

  mount /dev/sdb3 /mnt/gnu 
  mkdir -p /mnt/gnu/boot
  mount /dev/sdb1 /mnt/gnu/boot
  swapon /dev/sdb2
fi

echo " [*] fetching guest packages"
mkdir -p /mnt/gnu/sources
chmod a+wt /mnt/gnu/sources
wget -q -i all-packages -P /mnt/gnu/sources
pushd /mnt/gnu/sources
md5sums -c all-packages.MD5
popd

echo "done."
