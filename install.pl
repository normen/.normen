#!/usr/bin/env perl
use strict;
use warnings;
use feature "say";
use experimental "switch";
use Config;

my $hpath = h_path();
my $npath = n_path();
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
    say "8) Link dot files to $hpath";
    say "9) Update plugins";
    say "0) Exit";
    my $input = <>;
    given($input){
      when(1){
        say "\nInstalling base..";
        install_base_apps();
        checkout_normen();
      }
      when(2){
        say "\nSetting defaults..";
        install_plugin_defaults();
        configure_vifm();
      }
      when(3){
        say "\nConfiguring tmux..";
        configure_tmux();
      }
      when(4){
        say "\nInstalling node..";
        install_node();
      }
      when(8){
        say "\nInstalling links..";
        install_links();
      }
      when(9){
        say "\nUpdating plugins..";
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

sub install_for_root {
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
    return if system("git clone https://github.com/tmux-plugins/tpm ~/.normen/.tmux/plugins/tpm || true");
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
    system("git clone https://github.com/vifm/vifm-colors $vifm_path/colors");
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
  #TODO: can't even
  #my $n = `curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n`;
  #system(qq{bash -c $n bash 17});
  install_apps("node");
}

# update all plugins, silent fail
sub update_plugins {
  system("$npath/.tmux/plugins/tpm/bin/update_plugins all");
  system("zsh -c 'source $npath/.zshrc;antigen update'");
  system("vim +PlugUpdate +qa");
  system("vim +CocUpdateSync +ls +qa");
}

# get a copy of the .normen repo
sub checkout_normen {
  unless(-d $npath) {
    die if system("git clone https://github.com/normen/.normen $npath");
  } else{
    say "$npath exists already";
  }
}

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
  # TODO: this only works for a-shell
  unless(-w $hpath) {
    $hpath = "$hpath/Documents";
  }
  return $npath;
}

# adds lines of text to a file
# first param = filename
# other params = lines to add (if they don't exist)
sub add_config_lines {
  my($file_name, @new_lines) = @_;
  for(@new_lines){
    my $new_line = $_;
    open my $fh, '<', $file_name or return "Can't open $!";
    my $file_content = do { local $/; <$fh> };
    close $fh;
    unless($file_content =~ m/$new_line/){
      open $fh, '>>', $file_name or return "Can't open $!";
      print $fh "$new_line\n";
      close $fh;
      say "Added $new_line to $file_name";
    }
  }
}

# links a file to another location, removes existing files
sub link_in {
  my($src, $dest) = @_;
  if(-e $dest){
    return "Can't delete $dest" if system("rm -rf $dest");
  }
  return "Can't link $src" if system("ln -s $src $dest");
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

