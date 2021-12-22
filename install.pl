#!/usr/bin/env perl
use strict;
use warnings;
use feature "say";
use experimental "switch";
use Config;
use File::Copy; #move/copy
use File::Path; #rmtree
use File::Temp qw/ tempfile tempdir /; #tempdir

my $hpath = h_path();
my $npath = n_path();
my $git = git_cmd();
show_menu();

# show the main menu
sub show_menu {
  my $out=0;
  do {
    system("clear");
    say "** Normen Install **";
    say "1) Install base to $npath";
    say "2) Set default configuration";
    say "3) Configure tmux";
    say "4) Install node";
    say "5) Install golang to ~/.go";
    say "7) Link dot files to $hpath";
    say "8) Update .normen";
    say "9) Update plugins";
    say "0) Exit";
    my $input = <>;
    given($input){
      when(1){
        install_base_apps();
        checkout_normen();
      }
      when(2){
        install_plugin_defaults();
        configure_vifm();
      }
      when(3){
        configure_tmux();
      }
      when(4){
        install_node();
      }
      when(5){
        install_go();
      }
      when(7){
        install_links();
      }
      when(8){
        chdir($npath);
        system("$git pull");
      }
      when(9){
        update_plugins();
      }
      when(0){
        $out=1;
        exit;
      }
      default {
        say "\nOption doesn't exist";
      }
    }
    say "Press Return...";
    $input = <>;
  } while(!$out);
}

# install the basic commands
sub install_base_apps {
  given($Config{osname}){
    when("linux"){
      install_apps("git", "zsh", "vim", "vifm", "mosh", "tmux");
      my $zsh_exe=`which zsh`;
      chomp $zsh_exe;
      die if system("chsh -s $zsh_exe");
    }
    when("darwin"){
      install_apps("ctags", "vim", "vifm", "mosh", "tmux");
    }
  }
}

# TODO
sub install_for_root {
}

# TODO
sub install_eslint_semistandard {
}

# link in the defaults
sub install_plugin_defaults {
  link_in("$npath/.vim/defaults/default-plugins.vim", "$npath/.vim/plugins.vim");
  link_in("$npath/.vim/defaults/default-coc-settings.json", "$npath/.vim/coc-settings.json");
}

sub install_links {
  my($root) = @_;
  if(!defined $root){
    $root = $hpath;
  }
  link_in("$npath/.vim", "$root/.vim");
  link_in("$npath/.zshrc", "$root/.zshrc");
  link_in("$npath/.tmux", "$root/.tmux");
  link_in("$npath/.tmux/tmux.conf", "$root/.tmux.conf");
  link_in("$npath/.inputrc", "$root/.inputrc");
  link_in("$npath/.ctags", "$root/.ctags");
  link_in("$npath/.nethackrc", "$root/.nethackrc");
}

# set up tmux & tpm
sub configure_tmux {
  unless(-d "$npath/.tmux/plugins/tpm") {
    return if system("$git clone https://github.com/tmux-plugins/tpm $npath/.tmux/plugins/tpm");
  } else{
    say "$npath/.tmux/plugins/tpm exists already";
  }
  system("$npath/.tmux/plugins/tpm/bin/install_plugins");
}

# set up vifm config file
sub configure_vifm {
  my $vifm_path = "$hpath/.vifm";
  if(!-d $vifm_path){
    $vifm_path = "$hpath/.config/vifm";
  }
  if(!-d $vifm_path){
    say "Could not find vifm configuration path";
    return;
  }
  if(!-f "$vifm_path/colors/gruvbox.vifm"){
    say "Installing vifm colors";
    system("rm -rf $vifm_path/colors");
    system("$git clone https://github.com/vifm/vifm-colors $vifm_path/colors");
  }
  my $f = "$vifm_path/vifmrc";
  add_config_lines($f,
    "colorscheme gruvbox",
    "nnoremap <C-e> :q<CR>",
    "nmap ö :") if -d $f;
  say "Configured vifm";
}

# install node.js
sub install_node {
  #curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
  # TODO: can't even
  #my $n = `curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n`;
  #system(qq{bash -c $n bash 17});
  say "Installing node via package manager";
  install_apps("node");
}

# install go for current platform
sub install_go {
  # TODO: curl uname tar
  my $dl_url = "https://go.dev/dl/";
  # GOROOT install location
  my $go_root = "$hpath/.go";
  # GOPATH folder in root
  my $go_path = "$hpath/go";
  # OS/ARCH
  my $osname = $Config{osname};
  #my $osname = `uname -s`;
  #chomp $osname;
  my $archname = `uname -m`;
  chomp $archname;
  # regex as variable needs "qr"..
  my $ver_regex=qr/go([0-9]*\.[0-9]*\.[0-9a-z]*)/;
  # find os and arch
  my $os="-";
  my $arch="-";
  my $suffix="tar.gz";
  given($osname){
    when(/linux/i){
      $os="linux";
      given($archname){
        when(/armv7|armv6/i){
          $arch="armv6l";
        }
        when(/arm64|armv8/i){
          $arch="armv64";
        }
        when(/x86_64/i){
          $arch="amd64";
        }
        when(/386/i){
          $arch="386";
        }
      }
    }
    when(/darwin/i){
      $os="darwin";
      given($archname){
        when(/x86_64/i){
          $arch="amd64";
        }
        when(/arm/i){
          $arch="arm64";
        }
      }
    }
  }
  # check if we found a platform
  if($arch eq "-" || $os eq "-"){
    say "Could not find os/arch for $osname/$archname ($os/$arch)";
    return;
  }
  # check for latest version (L=redirects s=silent)
  my $dl_page = `curl -Ls $dl_url`;
  my($version) = $dl_page =~ $ver_regex;
  if(!$version){
    say "Can't get latest go version from $dl_url";
    return;
  }
  say "Latest go version: $version";
  # check installed version
  my $cur_ver = "go0.0.0";
  my $go_exe = "$go_root/bin/go";
  if(-x $go_exe){
    $cur_ver = qx{$go_exe version};
    chomp $cur_ver;
  }
  my($installed_version) = $cur_ver =~ $ver_regex;
  $installed_version="0.0.0" if !$installed_version;
  say "Installed go version: $installed_version";
  if( $installed_version eq $version ){
    say "You have the latest go version.";
    return;
  }
  # ask user confirmation
  say "Install go $version to $go_root? (y/n)";
  my $user_input = <>;
  chomp $user_input;
  return unless $user_input eq "y";
  # download and install
  my $file_name = "go$version.$os-$arch.$suffix";
  my $dl_url = "https://go.dev/dl/$file_name";
  my $temp_folder = tempdir( CLEANUP => 1 );
  my $temp_file = "$temp_folder/$file_name";
  if(!-d $temp_folder){
    die "Can't create temp folder";
  }
  say "Downloading $file_name";
  die if system("curl -L -o $temp_file $dl_url");
  say "Unpacking $file_name";
  die if system("tar -C $temp_folder -xzf $temp_file");
  die "Can't delete $temp_file" unless unlink $temp_file;
  # remove old GOROOT
  if(-d $go_root){
    say "Removing old GOROOT at $go_root";
    die unless rmtree $go_root;
  }
  # move in new GOROOT
  die "Can't move go to $go_root" unless move("$temp_folder/go", "$go_root");
  say "Installed go to $go_root";
  # check if GOPATH exists
  if(!-d $go_path){
    say "Creating GOPATH at $go_path";
    mkdir($go_path) or die "Can't create $go_path";
  } else{
    say "GOPATH folder exists at $go_path";
  }
  # update PATH in .profile
  my $go_bin = "$go_root/bin";
  if($ENV{PATH}=~/$go_bin/){
    say ".go/bin already in PATH!";
  } else{
    my $pro_file = "$hpath/.profile";
    if(file_contains($pro_file,"GOPATH|GOROOT")){
      say "Already a GOPATH in $pro_file";
      if(!file_contains($pro_file,"$go_bin")){
        say "Path to .go/bin not found in .profile! Edit by hand!";
      }
    } else{
      add_config_lines($pro_file,
        "GOPATH=$go_path",
        "PATH=\$PATH:$go_bin:\$GOPATH/bin"
      );
    }
  }
}

# update all plugins, silent fail
sub update_plugins {
  system("$npath/.tmux/plugins/tpm/bin/update_plugins all");
  system("zsh -c 'source $npath/.zshrc;antigen update'");
  system("vim +PlugUpdate +qa");
  system("vim +CocUpdateSync +ls +qa");
  my $local_update = "$npath/plugin-update.local";
  if(-x $local_update){
    system($local_update);
  }
}

# get a copy of the .normen repo
sub checkout_normen {
  unless(-d $npath) {
    die if system("$git clone https://github.com/normen/.normen $npath");
  } else{
    say "$npath exists already";
  }
  # add $NORMEN to profile if not in default location
  my $pro_file = "$hpath/.profile";
  if($npath ne "$ENV{HOME}/.normen"){
    if(file_contains($pro_file,"NORMEN=")){
      say "Already a NORMEN in $pro_file";
    } else{
      add_config_lines($pro_file, "NORMEN=$npath");
    }
  } else {
    say "Standard .normen location, won't modify .profile";
  }
}

## TOOLS

# get the path for .normen ($NORMEN env var or home/.normen)
sub n_path {
  my $npath = $ENV{NORMEN};
  unless($npath) {
    $npath = "$hpath/.normen";
  }
  return $npath;
}

# get a suitable home path
sub h_path {
  my $hpath = $ENV{HOME};
  # a-Shell
  if($ENV{TERM_PROGRAM} eq "a-Shell"){
    $hpath = "$hpath/Documents";
  }
  return $hpath;
}

# gets a suitable git command (a-shell etc)
sub git_cmd {
  if($ENV{TERM_PROGRAM} eq "a-Shell"){
    return "lg2";
  }
  return "git";
}

# adds lines of text to a file
# first param = filename
# other params = lines to add (if they don't exist)
sub add_config_lines {
  my($file_name, @new_lines) = @_;
  for(@new_lines){
    my $new_line = $_;
    unless(file_contains($new_line)){
      open my $fh, '>>', $file_name or die "Can't open $!";
      print $fh "$new_line\n";
      close $fh;
      say "Added $new_line to $file_name";
    }
  }
}

# checks if a file exists and contains a string
sub file_contains {
  my($file_name, $content) = @_;
  open my $fh, '<', $file_name or return 0;
  my $file_content = do { local $/; <$fh> };
  close $fh;
  return $file_content =~ m/$content/;
}

# links a file to another location, removes existing files
sub link_in {
  my($src, $dest) = @_;
  if(-e $dest){
    die "Can't delete $dest" if system("rm -rf $dest");
  }
  die "Can't link $src" if system("ln -s $src $dest");
  say "Linked in $dest";
}

# install a list of commands if they don't exist (per platform)
# params are command / package names (no support for differing names)
sub install_apps {
  foreach(@_){
    my $app_name = $_;
    my $app_exe = `which $app_name`;
    chomp $app_exe;
    unless(-x $app_exe){
      given($Config{osname}){
        when("linux"){
          die if system("sudo apt install $app_name");
        }
        when("darwin"){
          if($Config{archname}=~m/thread-multi/){
            my $brew_exe = `which brew`;
            chomp $brew_exe;
            unless(-x $brew_exe){
              say "No homebrew found, installing...";
              die if system(qq{/bin/bash -c "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"});
            } else{
              say "found brew";
            }
            die if system("brew install $app_name");
          }else{
            say "No thread-multi platform, won't use brew..";
          }
        }
      }
    } else {
      say "$app_name already installed";
    }
  }
}

