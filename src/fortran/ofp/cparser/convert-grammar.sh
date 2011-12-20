#!/usr/bin/env perl
#

# This file converts the ANTLR grammar for the Fortran C target
# into the java one.
#
# For input file, CFortranGrammar.g (for example), the output file,
# FortranGrammar-java.g will be created.
#

use strict;

if ($#ARGV != 1 ) {
   print "usage: convert-grammar filename-in.g filename-out.g\n";
   exit(1);
}

#----------------------------------------------------------------------------

my $filename_in  = $ARGV[0];
my $filename_out = $ARGV[1];

# Read in the input file
open(FILE_IN,  "$filename_in")  || die "Couldn't open file $filename_in";
my $input;
$input .= $_
    while (<FILE_IN>);
close(FILE_IN);

# Convert C grammar elements for Java ones.
#
$input =~ s/language=C/language=Java;\n   superClass=FortranParser/;
$input =~ s/ASTLabelType=pANTLR3_BASE_TREE/ASTLabelType=CommonTree/;
$input =~ s/\#include    \<stdio.h\>\n//;
$input =~ s/\/\/\///g;

$input =~ s/ANTLR3_BOOLEAN/boolean/g;
$input =~ s/ANTLR3_FALSE/false/g;
$input =~ s/NULL/null/g;
$input =~ s/c_action_/action./g;
$input =~ s/pANTLR3_COMMON_TOKEN/Token/g;

# Only write the output file a) if doesn't already exist, or b) it
# exists, but its contents are different than $output.

my $need_write = 0;
if (! -f $filename_out) {
    $need_write = 1;
} else {
    open(FILE_IN, $filename_out) || die "Couldn't open $filename_out";
    my $tmp;
    $tmp .= $_
        while (<FILE_IN>);
    close(FILE_IN);
    if ($input ne $tmp) {
        $need_write = 1;
    }
}

if ($need_write) {
    open(FILE_OUT, ">$filename_out") || die "Couldn't open $filename_out";
    print FILE_OUT $input;
    close(FILE_OUT);
    print "created $filename_out\n";
} else {
    print "$filename_out unchanged; not written\n";
}

# Done
exit(0);
