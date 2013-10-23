#!/bin/bash

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

if ! vagrant --help > /dev/null; then
  echo " [!] missing vagrant. install vagrant and continue"
  exit 1
fi

echo "done."
