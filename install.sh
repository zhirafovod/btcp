#!/usr/bin/env bash
# 
# script to install BtCP 
# 
# 
# 
# 

set -x   # uncomment for debbugging output

COOKBOOKS_PATH='/var/chef-solo/cookbooks'
SRC=`pwd`


### functions
parse_args() {
  case $1 in 
    "btcp-cassandra") install_btcp btcp-cassandra ;;
    "btcp-daemon") install_btcp btcp-daemon ;;
    *) show_usage ;;
  esac
}

show_usage() {
  echo "Usage: $(basename $0) (btcp-cassandra|btcp-daemon)"
}

install_btcp() {
  install_dependencies
  install_chef11
  install_cookbooks $1
  chef-solo -c $SRC/files/solo.rb -j $SRC/files/$1.json
}

install_dependencies() {
  . $SRC/files/platform_version.sh    # set variables $machine $platform $platform_version 
  case $platform in
    "debian") method="apt" ;;
    "ubuntu") method="apt" ;;
    *) echo "no installation method for platform $platform"
       exit 1
       ;;
  esac 
  "install_dependencies_${method}"
}

install_dependencies_apt() {
  apt-get -y --force-yes install git 
}

install_chef11() { 
  SUDO=`which sudo` 
  test -e `which chef-solo` && 
  [ "`chef-solo -v | cut -d ' ' -f 2 | cut -c 1-2`" -eq 11 ] && 
  echo "chef-solo 11 is already installed" || 
  $( cat ./files/chef11.install.sh | $SUDO bash )  # fixed installation for wheezy
}

clone_chef_solo_cookbook() {
  g=$1  # src - remote git repository
  l=$2  # dst - local git repository
  if test -d "$l" ; then
    cd $l && git pull || ( echo "Error: unable to clone from $f to $l, directory exists and is not a git repository" ; exit 1 )
  else 
    git clone $g $l
  fi
}

install_cookbooks() {
  # clone cookbooks for chef-solo to $COOKBOOKS_PATH directory
  test -d $COOKBOOKS_PATH || mkdir -p $COOKBOOKS_PATH
  clone_chef_solo_cookbook "https://github.com/zhirafovod/$1-cookbook.git" "$COOKBOOKS_PATH/$1"
  for c in yum python apt build-essential; do
    clone_chef_solo_cookbook "https://github.com/opscode-cookbooks/$c.git" "$COOKBOOKS_PATH/$c"
  done
}


### main
parse_args $1
