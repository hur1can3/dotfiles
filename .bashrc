#!/bin/bash
# ~/.bashrc

#####################################################
#               BEER-WARE LICENSE
# Matthew Levandowski wrote this file. As long as you
# retain this notice you can do whatever you want
# with this file and its contents. If we meet some
# day and you think it is worth it, you can buy
# me a beer in return.             - Matt Levandowski
# 01/28/2012            levandowski.matthew@gmail.com
#####################################################

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# source some files
[ -f ~/.bash_options ] && source $HOME/.bash_options
[ -f ~/.bash_alias ] && source $HOME/.bash_alias
[ -f ~/.bash_alias_ubuntu ] && source $HOME/.bash_alias_ubuntu
[ -f ~/.bash_colors ] && source $HOME/.bash_colors
[ -f ~/.bash_functions ] && source $HOME/.bash_functions

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
