## Perl
### Basics
```perl
#!/usr/bin/env perl
use strict;
use warnings;

use feature "say";
use feature "switch";

# simple get output from command
my $dirlist = `ls`;
# same:
my $dirlist = qx{ls};
# remove newline
my $command_path = chomp(`which ls`);
# pipe from command
open(my $PS, 'ps -ef |');
while (<$PS>) { print $_ }
close($PS);
# pipe to command
open(my $OUT, '| less');
print $OUT "Hello";
print $OUT "to less";
print $OUT "from PERL";
close $OUT;

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

## check arch
use Config;
print "$Config{osname}\n";
print "$Config{archname}\n";
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
### RegEx
##### Character Classes
Regex Character Classes and Special Character classes.

- `[bgh.]`      One of the characters listed in the character class b,g,h or . in this case.
- `[b-h]`       The same as [bcdefgh].
- `[a-z]`       Lower case Latin letters.
- `[bc-]`       The characters b, c or - (dash).
- `[^bx]`       Complementary character class. Anything except b or x.
- `\w`          Word characters: [a-zA-Z0-9_].
- `\d`          Digits: [0-9]
- `\s`          [\f\t\n\r ] form-feed, tab, newline, carriage return and SPACE
- `\W`          The complementary of \w: [^\w]
- `\D`          [^\d]
- `\S`          [^\s]
- `[:class:]`   POSIX character classes (alpha, alnum...)
- `\p{...}`     Unicode definitions (IsAlpha, IsLower, IsHebrew, ...)
- `\P{...}`     Complementary Unicode character classes.

##### Quantifiers
Regex Quantifiers

- `a?`          0-1         'a' characters
- `a+`          1-infinite  'a' characters
- `a*`          0-infinite  'a' characters
- `a{n,m}`      n-m         'a' characters
- `a{n,}`       n-infinite  'a' characters
- `a{n}`        n           'a' characters

##### "Quantifier-modifier" aka. Minimal Matching
- `a+?`
- `a*?`
- `a{n,m}?`
- `a{n,}?`
- `a??`
- `a{n}?`

##### Other
- `|`           Alternation

##### Grouping and capturing
- `(...)`                Grouping and capturing
- `\1,\2,\3,\4...`   Capture buffers during regex matching
- `$1,$2,$3,$4...`   Capture variables after successful matching
- `(?:...)`              Group without capturing (don't set \1 nor $1)

##### Anchors
- `^`           Beginning of string (or beginning of line if /m enabled)
- `$`           End of string (or end of line if /m enabled)
- `\A`          Beginning of string
- `\Z`          End of string (or before new-line)
- `\z`          End of string
- `\b`          Word boundary (start-of-word or end-of-word)
- `\G`          Match only at pos():  at the end-of-match position of prior m//g

##### Modifiers
- `/m`           Change ^ and $ to match beginning and end of line respectively
- `/s`           Change . to match new-line as well
- `/i`           Case insensitive pattern matching
- `/x`           Extended pattern (disregard white-space, allow comments starting with #)

##### Extended
- `(?#text)`             Embedded comment
- `(?adlupimsx-imsx)`    One or more embedded pattern-match modifiers, to be turned on or off.
- `(?:pattern)`          Non-capturing group.
- `(?|pattern)`          Branch test.
- `(?=pattern)`          A zero-width positive look-ahead assertion.
- `(?!pattern)`          A zero-width negative look-ahead assertion.
- `(?<=pattern)`         A zero-width positive look-behind assertion.
- `(?<!pattern)`         A zero-width negative look-behind assertion.
- `(?'NAME'pattern)`
- `(?<NAME>pattern)`     A named capture group.
- `\k<NAME>`
- `\k'NAME'`             Named backreference.
- `(?{ code })`          Zero-width assertion with code execution.
- `(??{ code })`         A "postponed" regular subexpression with code execution.

### Tools
```bash
# create executable
cpan install pp
pp -o myprog script.pl
# MacOS:
/usr/local/opt/Perl/bin/pp -o myprog script.pl
# language server
cpan install Perl::LanguageServer
# if fails:
apt install libio-aio-perl
```
