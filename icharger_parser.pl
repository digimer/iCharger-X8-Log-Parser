#!/usr/bin/perl
#
# http://www.jun-si.com/UploadFiles/ReleaseNotes-iChargerX8.txt
#

use strict;
use warnings;

my $file            = "/home/digimer/Videos/TDM/010/bank1/Junsi/X8/Log/lifepo4_bank1.txt";
my $total_time      = 0;
my $lines           = 0;
my $last_time       = 0;
my $total_amp_hours = 0;
my $last_amp_hours  = 0;
my $next_print      = 0;
print "Time (seconds),Charge Amps,Charge Voltage,Pack Voltage\n";
open (my $file_handle, "<", $file) or die "Failed to read: [".$file."], error was: [".$!."]\n";
while (<$file_handle>)
{
	chomp;
	my $line = $_;
	   $line =~ s/\r//;
	
	#print "line: [".$line."]\n";
	#                    $1            $2        $3    $4            $5
	#              0   1 2     3   4   5     6   7     8     9   10  11  12  13  14  15  16  17  18  19
	if ($line =~ /^\$1;1;(\d+);\d+;\d+;(\d+);\d+;(\d+);(\d+);\d+;\d+;(\d+);\d+;\d+;\d+;\d+;\d+;\d+;\d+;\d+/)
	{
		my $this_time             = $1;
		my $this_charge_amps      = $2;
		my $this_output_voltage   = $3; 
		my $this_charge_amp_hours = $4; 
		my $this_pack_voltage     = $5; 
		   $lines++;
		
		if ($this_time > $last_time)
		{
			# Time incremented.
			my $diff       =  $this_time - $last_time;
			   $total_time += $diff;
		}
		$last_time = $this_time;
		
		if ($this_charge_amp_hours < $last_amp_hours)
		{
			# New charge, record the last amp hour value onto the total amp hours.
			$total_amp_hours += $last_amp_hours;
		}
		$last_amp_hours = $this_charge_amp_hours;
		
		my $say_time           = $total_time / 1000;
		my $say_charge_amps    = $this_charge_amps / 100;
		my $say_charge_voltage = $this_output_voltage / 1000;
		my $say_pack_voltage   = $this_pack_voltage / 1000;
		if ($say_time > $next_print)
		{
			my $say_minutes =  $say_time / 60;
			   $next_print  += 60;
			   $say_minutes =~ s/\..*//;
			   
			print $say_minutes.",".$say_charge_amps.",".$say_charge_voltage.",".$say_pack_voltage."\n";
		}
	}
}
close $file_handle;

print "Total Ah: [".($total_amp_hours / 1000)."]\n";
