#!/usr/bin/env bash
# 
# script to install BtCP 
# 
# 

set -x 

COOKBOOKS='/var/chef-solo/cookbooks'
SRC=`pwd`

install_dependencies_debian() {
  apt-get -y --force-yes install git chef
}

install_chef11() { 
  test -e `which chef-solo` && 
  [ "`chef-solo -v | cut -d ' ' -f 2 | cut -c 1-2`" -eq 11 ] && 
  echo "chef-solo 11 is already installed" || 
  $( cat ./files/chef11.install.sh | sudo bash )  # fixed installation for wheezy
}

clone_chef_solo_cookbook() {
  g=$1  # src - remote git repository
  l=$2  # dst - local git repository
  if test -d "$l" ; then
    cd $l && git pull || ( mkdir $l && git clone $g $l )
  else 
    git clone $g $l
  fi
}


# main
install_dependencies_debian
install_chef11

# clone cookbooks for chef-solo to $COOKBOOKS directory
test -d $COOKBOOKS || mkdir -p $COOKBOOKS
clone_chef_solo_cookbook "https://github.com/zhirafovod/btcp-daemon-cookbook.git" "$COOKBOOKS/btcp-daemon"
for c in yum python apt build-essential; do
  clone_chef_solo_cookbook "https://github.com/opscode-cookbooks/$c.git" "$COOKBOOKS/$c"
done


chef-solo -c $SRC/files/solo.rb -j $SRC/files/btcp-daemon.json
