#!/bin/bash - 
#===============================================================================
#
#          FILE:  nodeinst.sh
# 
#         USAGE:  ./nodeinst.sh 
# 
#   DESCRIPTION:  i
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Dr. Fritz Mehner (fgm), mehner@fh-swf.de
#       COMPANY: FH Südwestfalen, Iserlohn
#       CREATED: 04/16/2013 02:32:54 PM EDT
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

# The install script
# Adapted from https://gist.github.com/579814
 
echo '# Added by install script for node.js and npm in 30s' >> ~/.bashrc
echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
echo 'export NODE_PATH=$HOME/local/lib/node_modules' >> ~/.bashrc
. ~/.bashrc
 
mkdir -p ~/local
mkdir -p ~/Downloads/node-latest-install
 
cd ~/Downloads/node-latest-install
curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
 
./configure --prefix=~/local # if SSL support is not required, use --without-ssl
make install # ok, fine, this step probably takes more than 30 seconds...

