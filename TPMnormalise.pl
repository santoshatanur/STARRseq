#! /usr/bin/perl

open(FILE,$ARGV[0]) || die "unable to open file";
$tcount = 0;
while(<FILE>)
 {
    $line=$_;
    chomp $line;
    @a=split("\t",$line);
    $tcount = $tcount + $a[1];
 }
close(FILE);
open(FILE,$ARGV[0]) || die "unable to open file";
while(<FILE>)
 {
    $line=$_;
    chomp $line;
    @a=split("\t",$line);
    $ncount = ($a[1] / $tcount) * 1000000;
    print "$a[0]\t$ncount\n";
 }
