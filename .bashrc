#!/bin/bash
# ~/.bashrc

#####################################################
#               BEER-WARE LICENSE
# Matthew Levandowski wrote this file. As long as you
# retain this notice you can do whatever you want
# with this file and its contents. If we meet some
# day and you think it is worth it, you can buy
# me a beer in return.             - Matt Levandowski
# 11/30/2011            levandowski.matthew@gmail.com
#####################################################

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# source some files
[ -f ~/.bash_options ] && source $HOME/.bash_options
[ -f ~/.bash_functions ] && source $HOME/.bash_functions
[ -f ~/.bash_alias ] && source $HOME/.bash_alias
#[ -f ~/.bash_alias_arch ] && source $HOME/.bash_alias_arch
[ -f ~/.bash_alias_ubuntu ] && source $HOME/.bash_alias_ubuntu
[ -f ~/.bash_colors ] && source $HOME/.bash_colors

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ];
    then debian_chroot=$(cat /etc/debian_chroot)
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix;
    then . /etc/bash_completion
fi
