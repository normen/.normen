#!/usr/bin/env perl
use strict;
use feature "say";
my $args=join(" ", @ARGV);
my $key;
my $host;
if(@ARGV > 1 && $ARGV[0] eq "clone") {
  $host = $ARGV[1];
} elsif (open my $fh, '<', glob '.git/config') {
  my $content = do {local $/;<$fh>};
  close $fh;
  ($host) = $content =~ m/^\s*url\s*=\s*[^\s:]*:\/\/([^\s\/\$]*)/gm;
}
if ($host && open my $fh, '<', glob '~/Documents/.git-credentials') {
  my $content = do {local $/;<$fh>};
  close $fh;
  ($key) = $content =~ m/^[^\s:]*:[^\s:]*:([^\@]*)\@$host/gm;
}
if ($key) {
  say "Found key in .git-credential";
  exit system("echo $key | lg2 $args");
} else {
  exit system("lg2 $args");
}
