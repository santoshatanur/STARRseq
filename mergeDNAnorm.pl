#! /usr/bin/perl

open(REF,$ARGV[0]) || die "unable to open file";
while(<REF>)
 {
   $line=$_;
   chomp $line;
   @a=split("\t",$line);
   if($a[0] =~ /(\S+_\d+_\S_\S_\S+)::\S+:\d+-\d+_(\S+)_\S+/)
    {
      $id=$1 . "_" . $2;
      $h{$id} = $a[1];
    }
   #if($a[0] =~ /(\S+)_(\d+)_(\S)_-(\w+)::\S+:\d+-\d+_(\S+)_\S+/ || $a[0] =~ /(\S+)_(\d+)_(\S)_-(\w+-\w+)::\S+:\d+-\d+_(\S+)_\S+/)
   # {
    #  $snp = $1 . "_" . $2 . "_" . $3 . "_-_" . $4; 
    #  $id=$snp . "_" . $5;
    #  $h{$id} = $a[1];
    #} 
 }

open(ALT,$ARGV[1]) || die "unable to open file";
#chr12_115102312_G_-TBX5-AS1
while(<ALT>)
 {
   $line=$_;
   chomp $line;
   @a=split("\t",$line);
   if($a[0] =~ /(\S+_\d+_\S_\S_\S+)::\S+:\d+-\d+_(\S+)_\S+/)
    {
      $id=$1 . "_" . $2;
      $snp = $1;
      $v = $h{$id};
      if($v !~ /^$/)
       {
         print "$snp\t$v\t$a[1]\n";
       }
      if($v =~ /^$/)
       {
         print "$snp\tNA\t$a[1]\n";
       }
    }
   if($a[0] =~ /(\S+)_(\d+)_(\S)_-(\w+)::\S+:\d+-\d+_(\S+)_\S+/ || $a[0] =~ /(\S+)_(\d+)_(\S)_-(\w+-\w+)::\S+:\d+-\d+_(\S+)_\S+/)
    { 
      $snp = $1 . "_" . $2 . "_" . $3 . "_-_" . $4;
      #print "$snp\n";
      $id=$snp . "_" . $5;
      #print "$id\n";
      $v = $h{$id};
      if($v !~ /^$/)
         {
            print "$snp\t$v\t$a[1]\n";
         } 

    }
 }

