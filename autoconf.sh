#! /bin/sh

# This script should be run instead of just autoconf to make
# sure any changes made in the config/ directory are reflected
# in acinclude.m4.  Might as well touch aclocal.m4 as well.
#
touch acinclude.m4
touch aclocal.m4

# Now run autoconf
#
autoconf

