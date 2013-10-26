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

 # This is the build script corresponding to chapter 5.4 of LFS2
 ############################################################################## 


set -e
set -u

if [ -n "${DEBUG:-}" ]; then
  set -x
fi

echo " [*] 5.4. binutils-2.23.2 Pass 1"

pushd /mnt/gnu/sources &> /dev/null

tar -xf binutils-2.23.2.tar.bz2

cd binutils-2.23.2
sed -i -e 's/@colophon/@@colophon/' \
       -e 's/doc@cygnus.com/doc@@cygnus.com/' bfd/doc/bfd.texinfo

patch -s -i $ROOT/patches/config.sub.patch

mkdir -p ../binutils-build
cd ../binutils-build

../binutils-2.23.2/configure   \
    --prefix=/tools            \
    --with-sysroot=$GNU        \
    --with-lib-path=/tools/lib \
    --target=$GNU_TGT          \
    --disable-nls              \
    --disable-werror &> /mnt/gnu/logs/5.4.conf.log \
    || (echo " [!] configure failed. see /mnt/gnu/logs/5.4.conf.log" && exit 1)

make &> /mnt/gnu/logs/5.4.build.log \
    || (echo " [!] build failed. see /mnt/gnu/logs/5.4.build.log" && exit 1)

case $(uname -m) in
  x86_64) mkdir -p /tools/lib && ln -s lib /tools/lib64 ;;
esac

make install &> /mnt/gnu/logs/5.4.install.log \
    || (echo " [!] install failed. see /mnt/gnu/logs/5.4.install.log" && exit 1)

cd ..

rm -rf binutils-2.23.2 binutils-build
popd &> /dev/null

