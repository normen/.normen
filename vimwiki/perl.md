## Perl
### Basics
```perl
#!/usr/bin/env perl
use strict;
use warnings;

use feature "say";
use feature "switch";

my $name = "Normen";
if(rand 2 > 1){
  $name="Else";
}
my $long_text = <<"END";
This
is long
text
END
my $text_with_quotes = qq{Hallo $name, this is text "with quotes"\n};
print("Hallo $name\n");
print($text_with_quotes);
printf("Hallo %s, %d Buchstaben!\n", $name, length($name));
say $text_with_quotes;

say rand 11;
say int(rand 11);
if(rand 11 > 5){
  say $long_text;
} else{
  say $text_with_quotes;
}

if($name eq "Normen"){
  say "Normen detected";
}
if($name ne "Normen"){
  say "Normen not detected";
}
for(my $i=0;$i<10;$i++){
  printf("This is %s %d\n", $name, $i);
}

# while / do..while

# switch:
given($name){
  when ($_ eq "Normen"){
    say "Switch Normen";
    continue;
  }
  when ($_ eq "Else"){
    say "Switch Else";
    continue;
  }
}

# strings
say index($name, "e");
say substr($name, 0, 2);
say uc $name; # uppercase
say ucfirst $name; # uppercase
say lc $name; # lowercase
$long_text=~s/is/was/g;
say $long_text;

# array
my @primes=(2,3,5,7,11,13,17);
my @my_info=("Normen", "Sylt", 25980);
my @arr = ('a' .. 'z');
say join(", ", @arr);
for my $info (@my_info) {
  say $info;
}
# change
$my_info[1]= "Morsum";
# slice
@my_info=@my_info[0,1];
# quickloop
for(@my_info){
  say $_;
}

# pop/push/shift/unshift/splice/join/sort/reverse
say @primes;
# filter
my @odds_array = grep{$_ %2} @primes;
say @odds_array;
# apply change
my @new_array = map{$_ * 2} @primes;
say @new_array;

# hashes
my %stuff = ("Normen"=>10,"Indy"=>5,"Marius"=>1);
$stuff{Lilou} = 0;
say $stuff{Normen};
say exists $stuff{"Normen"};
delete $stuff{Normen};
say exists $stuff{"Normen"};

# subroutines
sub get_random {
  return int(rand 11);
}

sub get_random_max {
  my ($max_num) = @_;
  $max_num ||= 11;
  return int(rand $max_num);
}

printf("Rnd Max: %d\n",get_random_max(100));
my $countr;

# states -> "global" vars declared locally, keep value!
sub my_counter {
  # only initialized on first call
  #my $countr;
  #state $countr = 0;
  $countr++;
  return $countr;
}

for(my $k=0;$k<6;$k++){
  my $count = my_counter();
  say "Twas $count";
}

# Files
my $filename = 'text.txt';
open my $file, '<', $filename
  or die "Cannot open File";
while(my $info = <$file>){
  say chomp($info);
}
close $file or die "Could't close File";
```
### packages
```perl
# packages
#package Animal::Cat;
#use strict;
#use warnings;
#sub new {
#}
```
### read/write example
```perl
use strict;
use warnings;
 
my $filename = 'README.txt';
 
my $data = read_file($filename);
$data =~ s/Copyright Start-Up/Copyright Large Corporation/g;
write_file($filename, $data);
exit;
 
sub read_file {
    my ($filename) = @_;
 
    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;
 
    return $all;
}
 
sub write_file {
    my ($filename, $content) = @_;
 
    open my $out, '>:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;
 
    return;
}
```
