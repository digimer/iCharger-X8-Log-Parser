#!/usr/bin/perl
#
# http://www.jun-si.com/UploadFiles/ReleaseNotes-iChargerX8.txt
#

use strict;
use warnings;
use Data::Dumper;

my $pwd = defined $ENV{PWD} ? $ENV{PWD} : "";
print "Please enter the directory to the iCharger logs:\n";
print "- [".$pwd."]: ";
my $directory = <STDIN>;
chomp $directory;

if (not $directory)
{
	$directory = $pwd;
}

print "Looking for iCharger X8 logs in: [".$directory."]\n";

if (not -d $directory)
{
	print "Error: Invalid directory.\n";
	exit(1);
}

my $files = {};
local(*DIRECTORY);
opendir(DIRECTORY, $directory);
while(my $file = readdir(DIRECTORY))
{
	if ($file =~ /^.*?\[Charge_(\d+)\].txt/)
	{
		# Zero-pad the sequence so it sorts in the right order.
		my $sequence  = sprintf("%06d", $1);
		$files->{$sequence} = $directory."/".$file;
		#print "[ Debug ] - Sequence: [".$sequence."], file: [".$files->{$sequence}."]\n";
	}
}

my $unified_log = "";
foreach my $sequence (sort {$a cmp $b} keys %{$files})
{
	print "Reading: [".$files->{$sequence}."]... ";
	if ((not -f $files->{$sequence}) or (not -r $files->{$sequence}))
	{
		print "Failed!\n";
		print "- The file: [".$files->{$sequence}."] doesn't exist or couldn't be read.\n";
	}
	open (my $file_handle, "<", $files->{$sequence}) or die "Failed to read: [".$files->{$sequence}."], error was: [".$!."]\n";
	while (<$file_handle>)
	{
		chomp;
		my $line =  $_;
		   $line =~ s/\r//;
		
		$unified_log .= $line."\n";
	}
	close $file_handle;
	print "Done.\n";
}

print "Unified logs created, parsing now...\n";
my $total_time      = 0;
my $lines           = 0;
my $last_time       = 0;
my $total_amp_hours = 0;
my $last_amp_hours  = 0;
my $next_print      = 0;
my $output_file     = $directory."/parsed_iCharger_X8.".time.".csv";
open (my $file_handle, ">", $output_file) or die "Failed to open to write: [".$output_file."]. The error was: [".$!."]\n";
print $file_handle "Time (minutes),Charge Amps,Charge Voltage,Pack Voltage\n";
foreach my $line (split/\n/, $unified_log)
{
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
			   
			print $file_handle $say_minutes.",".$say_charge_amps.",".$say_charge_voltage.",".$say_pack_voltage."\n";
		}
	}
}
close $file_handle;

my $say_time =  int($total_time / 1000);
   $say_time /= 60;
   $say_time =~ s/(\d+\.\d).*$/$1/;
print "Processed: [".$lines."] lines of log.\n";
print "Total cumulative charge Ah: [".($total_amp_hours / 1000)."] over: [".$say_time."] minutes.\n";
print "You can now upload / import the CSV file: [".$output_file."]\n";
print "Processing complete!\n";

exit;


=cut
Mode of Operation
mop[1]  = "Charging"
mop[2]  = "Discharging"
mop[3]  = "Monitor"
mop[4]  = "Waiting"
mop[5]  = "Motor burn-in"
mop[6]  = "Finished"
mop[7]  = "Error"
mop[8]  = "LIxx trickle"
mop[9]  = "NIxx trickle"
mop[10] = "Foam cut"
mop[11] = "Info"
mop[12] = "External-discharging"
=cut
