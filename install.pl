#!/usr/bin/env perl
use strict;
use warnings;
use v5.12;
use POSIX;
use Config;
use File::Copy;                           #move/copy
use File::Path;                           #rmtree
use File::Temp qw/ tempfile tempdir /;    #tempdir
use Term::ANSIColor;
no warnings 'experimental';

my $hpath = h_path();
my $npath = n_path();
my $git   = git_cmd();

if ( @ARGV > 0 ) {
  parse_args();
} else {
  show_menu();
}

# parse args
sub parse_args {
  while ( my $arg = shift(@ARGV) ) {
    given ($arg) {
      when ("-u") {
        chdir($npath);
        say `$git pull`;
        update_plugins();
      }
      when ("-h") {
        my $path = shift(@ARGV);
        say "$path"
      }
    }
  }
}

# show the main menu
sub show_menu {
  my $out    = 0;
  my $header = <<'EOF';
    _     _   _  _                        
 __| |___| |_| \| |___ _ _ _ __  ___ _ _✨
/ _` / _ \  _| .` / _ \ '_| '  \/ -_) ' \ 
\__,_\___/\__|_|\_\___/_| |_|_|_\___|_||_|
EOF
  do {
    system( $^O eq 'MSWin32' ? 'cls' : 'clear' );
    print color("green");
    say $header;
    print color("blue");
    say ">----------------------------------------<";
    print color("reset");
    say "1) Install base applications";
    say "2) Checkout .normen to $npath";
    say "3) Set default app configurations";
    say "4) Link dot files to $hpath";
    say "5) Install node";
    say "6) Install golang to ~/.go";
    say "7) Build/update app in ~/src";
    say "8) Update .normen";
    say "9) Update plugins";
    say "0) Exit";
    print color("blue");
    say ">----------------------------------------<";
    print color("reset");
    my $input = <>;
    given ($input) {
      when (1) {
        install_base_apps();
      }
      when (2) {
        checkout_normen();
      }
      when (3) {
        install_vim_defaults();
        configure_vifm();
        configure_tmux();
      }
      when (4) {
        install_links();
      }
      when (5) {
        install_node();
      }
      when (6) {
        install_go();
      }
      when (7) {
        print("Name (mosh, tmux, vim, vifm): ");
        my $app_to_build = <>;
        chomp $app_to_build;
        build_app($app_to_build);
      }
      when (8) {
        chdir($npath);
        system("$git pull");
      }
      when (9) {
        update_plugins();
      }
      when (0) {
        $out = 1;
        exit;
      }
      default {
        say "\nOption doesn't exist";
      }
    }
    say "Press Return...";
    $input = <>;
  } while ( !$out );
}

# install the basic commands
sub install_base_apps {
  given ( $Config{osname} ) {
    system("curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir $npath/bin/all");
    when ("linux") {
      install_apps( "git", "zsh", "vim", "vifm", "mosh", "tmux", "jq", "rlwrap", "pandoc" );
      my $zsh_exe = qx{which zsh};
      chomp $zsh_exe;
      die if system("chsh -s $zsh_exe");
    }
    when ("MSWin32") {
      install_apps( "vim.vim", "Git.Git" );
    }
    when ("darwin") {
      install_apps( "git", "ctags", "vim", "vifm", "mosh", "tmux", "jq", "rlwrap", "pandoc" );
    }
  }
}

# get a copy of the .normen repo
sub checkout_normen {
  unless ( -d $npath ) {
    die if system("$git clone https://github.com/normen/.normen $npath");
    install_vim_defaults();
  } else {
    say "$npath exists already";
  }
}

# link in the defaults
sub install_vim_defaults {
  link_in( "$npath/.vim/defaults/default-plugins.vim", "$npath/.vim/plugins.vim" );
  #link_in("$npath/.vim/defaults/default-coc-settings.json", "$npath/.vim/coc-settings.json");
}

sub install_links {
  my ($root) = @_;
  if ( !defined $root ) {
    $root = $hpath;
  }
  if ( $Config{osname} eq "MSWin32" ) {
    link_in( "$npath/.vim", "$root/vimfiles" );
    return;
  }
  link_in( "$npath/.vim",            "$root/.vim" );
  link_in( "$npath/.zshrc",          "$root/.zshrc" );
  link_in( "$npath/.tmux",           "$root/.tmux" );
  link_in( "$npath/.tmux/tmux.conf", "$root/.tmux.conf" );
  link_in( "$npath/.inputrc",        "$root/.inputrc" );
  link_in( "$npath/.ctags",          "$root/.ctags" );
  link_in( "$npath/.nethackrc",      "$root/.nethackrc" );

  # add $NORMEN to profile if not in default location
  my $pro_file = "$hpath/.profile";
  if ( $npath ne glob "~" . "/.normen" ) {
    if ( file_regex( $pro_file, "NORMEN" ) ) {
      say "Already a NORMEN in $pro_file";
    } else {
      add_config_lines( $pro_file, "export NORMEN=$npath" );
    }
  }
}

# set up tmux & tpm
sub configure_tmux {
  unless ( -d "$npath/.tmux/plugins/tpm" ) {
    return if system("$git clone https://github.com/tmux-plugins/tpm $npath/.tmux/plugins/tpm");
  } else {
    say "$npath/.tmux/plugins/tpm exists already";
  }
  system("$npath/.tmux/plugins/tpm/bin/install_plugins");
}

# set up vifm config file
sub configure_vifm {
  my $vifm_path = "$hpath/.vifm";
  if ( !-d $vifm_path ) {
    $vifm_path = "$hpath/.config/vifm";
  }
  if ( !-d $vifm_path ) {
    say "Could not find vifm configuration path";
    return;
  }
  if ( !-f "$vifm_path/colors/gruvbox.vifm" ) {
    say "Installing vifm colors";
    rmtree("$vifm_path/colors");
    system("$git clone https://github.com/vifm/vifm-colors $vifm_path/colors");
  }
  my $f = "$vifm_path/vifmrc";
  add_config_lines( $f,
    "colorscheme gruvbox",
    "nnoremap <C-e> :q<CR>",
    "nmap ö :" ) if -f $f;
  say "Configured vifm";
}

# install node.js
sub install_node {
  #curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
  # TODO: can't even
  #my $n = qx{curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n};
  #system(qq{bash -c $n bash 17});
  say "Installing node via package manager";
  install_apps("node");
}

# install go for current platform
# uses curl and tar which are also on windows 10+
sub install_go {
  ( my $osname, my $nodename, my $releasename, my $versionname, my $archname ) = POSIX::uname();
  # go download page
  my $go_dl_url = "https://go.dev/dl/";
  # GOROOT install location
  my $go_root = "$hpath/.go";
  # GOPATH folder in root
  my $go_path = "$hpath/go";
  # regex as variable needs "qr"..
  my $go_ver_regex = qr/go([0-9]*\.[0-9]*\.[0-9a-z]*)/;
  # find os and arch
  my $os     = "-";
  my $arch   = "-";
  my $suffix = "tar.gz";
  given ($archname) {
    when (/armv7|armv6/i)      { $arch = "armv6l"; }
    when (/arm64|armv8/i)      { $arch = "arm64"; }
    when (/x64|x86_64|amd64/i) { $arch = "amd64"; }
    when (/386/i)              { $arch = "386"; }
  }
  given ($osname) {
    when (/linux/i)           { $os = "linux"; }
    when (/darwin/i)          { $os = "darwin"; }
    when (/windows|MSWin32/i) { $os = "windows"; $suffix = "zip"; }
  }
  # check if we found a platform
  if ( $arch eq "-" || $os eq "-" ) {
    say "Could not find os/arch for $osname/$archname ($os/$arch)";
    return;
  }
  # check for latest version (L=redirects s=silent)
  my $dl_page = qx{curl -Ls $go_dl_url};
  my ($version) = $dl_page =~ $go_ver_regex;
  if ( !$version ) {
    say "Can't get latest go version from $go_dl_url";
    return;
  }
  say "Latest go version: $version";
  # check installed version
  my $cur_ver = "go0.0.0";
  my $go_exe  = "$go_root/bin/go";
  $go_exe = $go_exe . ".exe" if $os eq "windows";
  if ( -x $go_exe ) {
    $cur_ver = qx{$go_exe version};
    chomp $cur_ver;
  }
  my ($installed_version) = $cur_ver =~ $go_ver_regex;
  $installed_version = "0.0.0" if !$installed_version;
  say "Installed go version: $installed_version";
  if ( $installed_version eq $version ) {
    say "You have the latest go version.";
    return;
  }
  # ask user confirmation
  say "Install go $version to $go_root? (y/n)";
  my $user_input = <>;
  chomp $user_input;
  return unless $user_input eq "y";
  # download and install
  my $file_name   = "go$version.$os-$arch.$suffix";
  my $pack_url    = "https://go.dev/dl/$file_name";
  my $temp_folder = tempdir( CLEANUP => 1 );
  my $temp_file   = "$temp_folder/$file_name";
  if ( !-d $temp_folder ) {
    die "Can't create temp folder";
  }
  say "Downloading $file_name";
  die if system("curl -L -o $temp_file $pack_url");
  say "Unpacking $file_name";
  die if system("tar -C $temp_folder -xzf $temp_file");
  die "Can't delete $temp_file" unless unlink $temp_file;
  # remove old GOROOT
  if ( -d $go_root ) {
    say "Removing old GOROOT at $go_root";
    die unless rmtree $go_root;
  }
  # move in new GOROOT
  die "Can't move go to $go_root" unless move( "$temp_folder/go", "$go_root" );
  say "Installed go to $go_root";
  # check if GOPATH exists
  if ( !-d $go_path ) {
    say "Creating GOPATH at $go_path";
    mkdir($go_path) or die "Can't create $go_path";
  } else {
    say "GOPATH folder exists at $go_path";
  }
  # ENV for windows
  if ( $Config{osname} eq "MSWin32" ) {
    system("setx GOPATH $hpath\\go");
    my $curpath = $ENV{Path};
    unless ( $curpath =~ /\.go\\bin/ ) {
      unless ( length( $curpath . ";$go_root\\bin" ) > 1024 ) {
        system("setx PATH \"%PATH%;$go_root\\bin\"");
      } else {
        say "PATH would be longer than 1024 characters, add home/.go/bin to path manually.";
      }
    }
    return;
  }
  # update PATH in .profile
  my $go_bin = "$go_root/bin";
  if ( $ENV{PATH} =~ m{$go_bin} ) {
    say ".go/bin already in PATH!";
  } else {
    my $pro_file = "$hpath/.profile";
    if ( file_regex( $pro_file, "GOPATH|GOROOT" ) ) {
      say "Already a GOPATH in $pro_file";
      if ( !file_contains( $pro_file, "$go_bin" ) ) {
        say "Path to .go/bin not found in .profile! Edit by hand!";
      }
    } else {
      add_config_lines( $pro_file,
        "GOPATH=$go_path",
        "PATH=\$PATH:$go_bin:\$GOPATH/bin"
      );
    }
  }
}

# installs or updates vim plugins manually from plugins.vim (a-Shell)
sub update_vim_plugins {
  my $file_name = "$npath/.vim/plugins.vim";
  open my $fh, '<', $file_name or return 0;
  my $file_content = do { local $/; <$fh> };
  close $fh;
  my @plugin_list = $file_content =~ m/^\s*(?:Plug|Plugin)\s*['"]([^'"]*)'/gm;
  my $plug_path   = "$npath/.vim/plugged";
  if ( !-d $plug_path ) {
    mkdir($plug_path) or die "Can't created plugin path";
  }
  foreach my $plug_name (@plugin_list) {
    my ($plug_short) = $plug_name =~ m{.*/(.*)};
    if ( -d "$plug_path/$plug_short" ) {
      chdir("$plug_path/$plug_short");
      say `$git pull`;
      if ( -d "$plug_path/$plug_short/doc" ) {
        system("vim -c 'helptags doc' +qa");
      }
      say "$plug_short updated";
    } else {
      chdir($plug_path);
      if ( $plug_name =~ /^http.*/m ) {
        say `$git clone $plug_name`;
      } else {
        say `$git clone https://github.com/$plug_name`;
      }
      say "$plug_short installed";
    }
  }
}

# update all plugins, silent fail
sub update_plugins {
  if ( $git eq "lg2" ) {
    update_vim_plugins();
    return;
  }
  system("$npath/.tmux/plugins/tpm/bin/update_plugins all");
  system("zsh -c 'source $npath/.zshrc;antigen update'");
  system("vim +PlugUpdate +qa");
  system("curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir $npath/bin/all");
  my $local_update = "$npath/plugin-update.local";
  if ( -x $local_update ) {
    system($local_update);
  }
}

# build base apps locally
sub build_app {
  my ($name) = @_;
  if ( !$name ) { return; }
  my $command = "";
  given ($name) {
    when ("mosh") {
      $command = <<END;
$git clone https://github.com/mobile-shell/mosh ~/src/mosh
set -e
cd ~/src/mosh
$git stash
$git pull
./autogen.sh
./configure --prefix=/usr/local
make clean
make -j4
sudo make install
END
    }
    when ("vim") {
      $command = <<END;
$git clone https://github.com/vim/vim ~/src/vim
set -e
cd ~/src/vim
$git stash
$git pull
./configure --prefix=/usr/local --enable-python3interp=dynamic --enable-perlinterp=dynamic --enable-luainterp=dynamic
cd src
make clean
make -j4
sudo make install
END
    }
    when ("vifm") {
      $command = <<END;
$git clone https://github.com/vifm/vifm ~/src/vifm
set -e
cd ~/src/vifm
$git stash
$git pull
aclocal
./configure --prefix=/usr/local
make clean
make -j4
sudo make install
END
    }
    when ("tmux") {
      $command = <<END;
#sudo apt install libevent-dev bison
$git clone https://github.com/tmux/tmux ~/src/tmux
set -e
cd ~/src/tmux
$git stash
$git pull
./autogen.sh
./configure --prefix=/usr/local
make clean
make -j4
sudo make install
END
    }
    when ("test") {
      $command = <<END;
END
    }
  }
  unless ( $command eq "" ) {
    system($command);
  }
}

## TOOLS

# get the path for .normen ($NORMEN env var or home/.normen)
sub n_path {
  my $npath = $ENV{NORMEN};
  unless ($npath) {
    $npath = "$hpath/.normen";
  }
  return $npath;
}

# get a suitable home path
sub h_path {
  my $hpath = $ENV{HOME};
  if ( !$hpath ) {
    # windows
    $hpath = glob '~';
  }
  # a-Shell
  my $term_prog = $ENV{TERM_PROGRAM};
  if ( $term_prog && $term_prog eq "a-Shell" ) {
    $hpath = "$hpath/Documents";
  }
  return $hpath;
}

# gets a suitable git command (a-shell etc)
sub git_cmd {
  my $term_prog = $ENV{TERM_PROGRAM};
  if ( $term_prog && $term_prog eq "a-Shell" ) {
    return "lg2";
  }
  return "git";
}

# adds lines of text to a file
# first param = filename
# other params = lines to add (if they don't exist)
sub add_config_lines {
  my ( $file_name, @new_lines ) = @_;
  foreach my $new_line (@new_lines) {
    unless ( file_contains( $file_name, $new_line ) ) {
      open my $fh, '>>', $file_name or die "Can't open $!";
      print $fh "$new_line\n";
      close $fh;
      say "Added $new_line to $file_name";
    }
  }
}

# checks if a file exists and contains a string
sub file_regex {
  my ( $file_name, $content ) = @_;
  open my $fh, '<', $file_name or return 0;
  my $file_content = do { local $/; <$fh> };
  close $fh;
  return $file_content =~ m/$content/;
}

# checks if a file exists and contains a string
sub file_contains {
  my ( $file_name, $content ) = @_;
  open my $fh, '<', $file_name or return 0;
  my $file_content = do { local $/; <$fh> };
  close $fh;
  return index( $file_content, $content ) >= 0;
}

# links a file to another location, removes existing files
sub link_in {
  my ( $src, $dest ) = @_;
  if ( -l $dest || -e $dest ) {
    if ( !unlink $dest ) {
      unless ( rmtree($dest) ) {
        if ( system("rm $dest") != 0 ) {
          die "Can't delete $dest";
        }
      }
    }
  }
  if ( $Config{osname} eq "MSWin32" ) {
    if ( -d $src ) {
      dircopy( $src, $dest ) or die "Can't copy $dest";
    } else {
      copy( $src, $dest ) or die "Can't copy $dest";
    }
    say "Copied $dest";
  } else {
    die "Can't link $dest" unless symlink $src, $dest;
    say "Linked $dest";
  }
}

# recursive copy - doesn't exist in perl
sub dircopy {
  my @dirlist = ( $_[0] );
  my @dircopy = ( $_[1] );
  until ( scalar(@dirlist) == 0 ) {
    mkdir "$dircopy[0]";
    opendir my ($dh), $dirlist[0];
    my @filelist = grep { !/^\.\.?$/ } readdir $dh;
    for my $i ( 0 .. scalar(@filelist) - 1 ) {
      if ( -f "$dirlist[0]/$filelist[$i]" ) {
        copy( "$dirlist[0]/$filelist[$i]", "$dircopy[0]/$filelist[$i]" );
      }
      if ( -d "$dirlist[0]/$filelist[$i]" ) {
        push @dirlist, "$dirlist[0]/$filelist[$i]";
        push @dircopy, "$dircopy[0]/$filelist[$i]";
      }
    }
    closedir $dh;
    shift @dirlist; shift @dircopy;
  }
}

# install a list of commands if they don't exist (per platform)
# params are command / package names (no support for differing names)
sub install_apps {
  foreach my $app_name (@_) {
    my $app_exe = $app_name;
    $app_exe = qx{which $app_name} unless $Config{osname} eq "MSWin32";
    chomp $app_exe;
    unless ( -x $app_exe ) {
      given ( $Config{osname} ) {
        when ("linux") {
          die if system("sudo apt install $app_name");
        }
        when ("MSWin32") {
          die if system("winget install -h $app_name");
        }
        when ("darwin") {
          if ( $Config{archname} =~ m/thread-multi/ ) {
            my $brew_exe = qx{which brew};
            chomp $brew_exe;
            unless ( -x $brew_exe ) {
              say "No homebrew found, installing...";
              die if system(qq{/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"});
            } else {
              say "found brew";
            }
            die if system("brew install $app_name");
          } else {
            say "No thread-multi platform, won't use brew..";
          }
        }
      }
    } else {
      say "$app_name already installed";
    }
  }
}

