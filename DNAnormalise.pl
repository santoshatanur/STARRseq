#! /usr/bin/perl

open(DNA,$ARGV[0]) || die "unable to open file";
open(RNA,$ARGV[1]) || die "unable to open file";
while(<DNA>)
 {
    $line=$_;
    chomp $line;
    @a=split("\t",$line);
    $dna = $a[1];
    
    $rline = <RNA>;
    chomp $rline;
    @b=split("\t",$rline);
    $rna = $b[1];
    if($dna > 0 )
     {
       $norm = $rna / $dna;
       $normr = sprintf("%.4f",$norm);
       print "$b[0]\t$normr\n";
     }
    else
     {
       print "$b[0]\tNA\n";
     }
 }
