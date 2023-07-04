#! /usr/bin/perl

open(UMI,$ARGV[0]) || die "Unable to open file";

while(<UMI>)
 {
   $line=$_;
   chomp $line;
   if($line =~ /^\@(M03291:\S+)\s\S+/)
    {
      $umi = <UMI>;
      chomp $umi;
      $h{$1} = $umi;
      #print "$a[0]\t$umi\n";
    }
 }

open(BAM,$ARGV[1]) || die "Unable to open file";

while(<BAM>)
 {
   $line=$_;
   chomp $line;
   @a=split("\t",$line);
   $id = $a[7];
   $chr = $a[3];
   if($chr ne $pchr)
    {
      if($flag == 0)
       {
         $number = keys %uh;
         print "$pchr\t$number\n";
       }
      if($flag == 1)
       {
         $number = 0;
         print "$pchr\t$number\n";
       }
      %uh = ();
      $flag = 0;
      $v=$h{$id};
      if($v !~ /^$/)
       {
         $uh{$v} = "AAA";
       }
      else
       {
         $flag = 1;
       }
    }
   if($chr eq $pchr)
    {
      $v=$h{$id};
      $uh{$v} = "AAA";
    }
   $pchr = $chr;
 }


      if($flag == 0)
       {
         $number = keys %uh;
         print "$pchr\t$number\n";
       }
      if($flag == 1)
       {
         $number = 0;
         print "$pchr\t$number\n";
       }
