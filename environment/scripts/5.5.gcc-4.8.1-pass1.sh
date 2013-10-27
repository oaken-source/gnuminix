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

 # This is the build script corresponding to chapter 5.5 of LFS2
 ############################################################################## 


set -e
set -u

if [ -n "${DEBUG:-}" ]; then
  set -x
fi

echo " [*] 5.5. gcc-4.8.1 Pass 1"

pushd /mnt/gnu/sources &> /dev/null

tar -xf gcc-4.8.1.tar.bz2

cd gcc-4.8.1

tar -Jxf ../mpfr-3.1.2.tar.xz
mv mpfr-3.1.2 mpfr
tar -Jxf ../gmp-5.1.2.tar.xz
mv gmp-5.1.2 gmp
tar -zxf ../mpc-1.0.1.tar.gz
mv mpc-1.0.1 mpc

patch -s -i $ROOT/patches/config.sub.patch

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -u $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

mkdir -p ../gcc-build
cd ../gcc-build

../gcc-4.8.1/configure                               \
    --target=$GNU_TGT                                \
    --prefix=/tools                                  \
    --with-sysroot=$GNU                              \
    --with-newlib                                    \
    --without-headers                                \
    --with-local-prefix=/tools                       \
    --with-native-system-header-dir=/tools/include   \
    --disable-nls                                    \
    --disable-shared                                 \
    --disable-multilib                               \
    --disable-decimal-float                          \
    --disable-threads                                \
    --disable-libatomic                              \
    --disable-libgomp                                \
    --disable-libitm                                 \
    --disable-libmudflap                             \
    --disable-libquadmath                            \
    --disable-libsanitizer                           \
    --disable-libssp                                 \
    --disable-libstdc++-v3                           \
    --enable-languages=c,c++                         \
    --with-mpfr-include=$(pwd)/../gcc-4.8.1/mpfr/src \
    --with-mpfr-lib=$(pwd)/mpfr/src/.libs &> /mnt/gnu/logs/5.5.conf.log \
    || (echo " [!] configure failed. see /mnt/gnu/logs/5.5.conf.log" && exit 1)

make &> /mnt/gnu/logs/5.5.build.log \
    || (echo " [!] build failed. see /mnt/gnu/logs/5.5.build.log" && exit 1)

make install &> /mnt/gnu/logs/5.5.install.log \
    || (echo " [!] install failed. see /mnt/gnu/logs/5.5.install.log" && exit 1)

ln -s libgcc.a `$GNU_TGT-gcc -print-libgcc-file-name | sed 's/libgcc/&_eh/'`

cd ..

rm -rf gcc-4.8.1 gcc-build
popd &> /dev/null

