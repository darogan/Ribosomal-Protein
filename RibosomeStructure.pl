#!/usr/bin/perl

use strict;

my $FILE_CIF = $ARGV[0];
my $FILE_LUT = $ARGV[1];
my %Molecules;
my %Molecules60s;
my %Molecules40s;

my( $Verbose, %RP_LUT, 
    $globalX, $globalY, $globalZ, $globalN,
    $globalX60s, $globalY60s, $globalZ60s, $globalN60s,
    $globalX40s, $globalY40s, $globalZ40s, $globalN40s );

$Verbose = 1;

open(LUT,$FILE_LUT) || die "Can't open $FILE_LUT for reading: $!\n";
while(<LUT>)
  {
    chomp;
    my $line = $_;
    my @Line = split(/,/,$line);
    $Line[1] =~ s/^ //g;
    $Line[2] =~ s/^ //g;
    $Line[3] =~ s/^ //g;
    $RP_LUT{$Line[2]} = $Line[1] . "; " . $Line[3];
    print $Line[2], ";", $RP_LUT{$Line[2]}, "\n", if($Verbose);
  }
close LUT;

open(CIF,$FILE_CIF) || die "Can't open $FILE_CIF for reading: $!\n";
while(<CIF>)
  {
    my $line = $_;
    if($line =~ m/^ATOM/)
      {
        my @Line = split(/\s+/,$line); 
        $globalX += $Line[10];
        $globalY += $Line[11];
        $globalZ += $Line[12];
        $globalN += 1;
        $Molecules{$Line[18]} = $Molecules{$Line[18]} . "$Line[10],$Line[11],$Line[12]\n";

        if($RP_LUT{uc($Line[18])} =~ m/60S/){
        $globalX60s += $Line[10];
        $globalY60s += $Line[11];
        $globalZ60s += $Line[12];
        $globalN60s += 1; 
        $Molecules60s{$Line[18]} = $Molecules60s{$Line[18]} . "$Line[10],$Line[11],$Line[12]\n"; }

        if($RP_LUT{uc($Line[18])} =~ m/40S/){
        $globalX40s += $Line[10];
        $globalY40s += $Line[11];
        $globalZ40s += $Line[12];
        $globalN40s += 1; 
        $Molecules40s{$Line[18]} = $Molecules40s{$Line[18]} . "$Line[10],$Line[11],$Line[12]\n"; }
      }
  }
close CIF;

my (%Centroids, %Centroids60s, %Centroids40s);

foreach my $mol (keys %Molecules)
   {
     my($localX, $localY, $localZ);
     my @coords = split(/\n/, $Molecules{$mol});
     foreach my $atom (@coords)
        {
          my($x,$y,$z) = split(/,/,$atom);
          $localX += $x; $localY += $y; $localZ += $z;
        }
      $Centroids{$mol} = $localX/scalar(@coords) . "," . $localY/scalar(@coords) . "," . $localZ/scalar(@coords);
   }

foreach my $mol (keys %Molecules60s)
   {
     my($localX, $localY, $localZ);
     my @coords = split(/\n/, $Molecules60s{$mol});
     foreach my $atom (@coords)
        {
          my($x,$y,$z) = split(/,/,$atom);
          $localX += $x; $localY += $y; $localZ += $z;
        }
      $Centroids60s{$mol} = $localX/scalar(@coords) . "," . $localY/scalar(@coords) . "," . $localZ/scalar(@coords);
   }

foreach my $mol (keys %Molecules40s)
   {
     my($localX, $localY, $localZ);
     my @coords = split(/\n/, $Molecules40s{$mol});
     foreach my $atom (@coords)
        {
          my($x,$y,$z) = split(/,/,$atom);
          $localX += $x; $localY += $y; $localZ += $z;
        }
      $Centroids40s{$mol} = $localX/scalar(@coords) . "," . $localY/scalar(@coords) . "," . $localZ/scalar(@coords);
   }

$globalX    = $globalX   /$globalN;     $globalY    = $globalY   /$globalN;     $globalZ    = $globalZ   /$globalN;
$globalX60s = $globalX60s/$globalN60s;  $globalY60s = $globalY60s/$globalN60s;  $globalZ60s = $globalZ60s/$globalN60s;
$globalX40s = $globalX40s/$globalN40s;  $globalY40s = $globalY40s/$globalN40s;  $globalZ40s = $globalZ40s/$globalN40s;

print "+ Ribosome subunit centroids\n";
#printf "ALL: %6.2f,%6.2f,%6.2f\n", $globalX, $globalY, $globalZ;
printf "60s: %6.2f,%6.2f,%6.2f\n", $globalX60s, $globalY60s, $globalZ60s;
printf "40s: %6.2f,%6.2f,%6.2f\n", $globalX40s, $globalY40s, $globalZ40s;


#my %Distances;
#foreach my $cent (keys %Centroids)
#  {
#    my($x,$y,$z) = split(/,/,$Centroids{$cent});
#    my $dist = sqrt(($x-$globalX)**2+($y-$globalY)**2+($z-$globalZ)**2);
#    $Distances{$cent} = $dist;
#  }
#printf "ALL: %-2s %6s %s\n", "Cn", "Dist", "Description" ;
#foreach my $cent (sort { $Distances{$b} <=> $Distances{$a} } keys %Distances) 
#  {
#    printf "ALL: %-2s %6.2f %s\n", $cent, $Distances{$cent}, $RP_LUT{uc($cent)};
#  }


my %Distances60s;
foreach my $cent (keys %Centroids60s)
  {
    my($x,$y,$z) = split(/,/,$Centroids60s{$cent});
    my $dist = sqrt(($x-$globalX60s)**2+($y-$globalY60s)**2+($z-$globalZ60s)**2);
    $Distances60s{$cent} = $dist;
  }
printf "60s: %-2s %6s %s\n", "Cn", "Dist", "Description" ;
foreach my $cent (sort { $Distances60s{$b} <=> $Distances60s{$a} } keys %Distances60s)
  {
    my $desc = $RP_LUT{$cent};
    $desc =~ s/[0-9]0S ribosomal protein //g;
    printf "60s: %-2s %6.2f %s\n", $cent, $Distances60s{$cent}, $desc;
  }

my %Distances40s;
foreach my $cent (keys %Centroids40s)
  {
    my($x,$y,$z) = split(/,/,$Centroids40s{$cent});
    my $dist = sqrt(($x-$globalX40s)**2+($y-$globalY40s)**2+($z-$globalZ40s)**2);
    $Distances40s{$cent} = $dist;
  }
printf "40s: %-2s %6s %s\n", "Cn", "Dist", "Description" ;
foreach my $cent (sort { $Distances40s{$b} <=> $Distances40s{$a} } keys %Distances40s)
  {
    my $desc = $RP_LUT{$cent};
    $desc =~ s/[0-9]0S ribosomal protein //g;
    printf "40s: %-2s %6.2f %s\n", $cent, $Distances40s{$cent}, $desc;
  }






#
# END OF SCRIPT
#
