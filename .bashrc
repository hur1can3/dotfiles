#!/bin/bash
# ~/.bashrc

####################################################
#               BEER-WARE LICENSE
# Matthew Levandowski wrote this file. As long as you
# retain this notice you can do whatever you want 
# with this file and its contents. If we meet some
# day and you think it is worth it, you can buy
# me a beer in return. -Matt Levandowski
# 01/31/2010         levandowski.matthew@gmail.com
####################################################

# exit if we're in a script
[ -z "$PS1" ] && return

# source some files
[ -f ~/.bash_functions ] && source $HOME/.bash_functions
[ -f ~/.bash_exports ] && source $HOME/.bash_exports
[ -f ~/.bash_alias ] && source $HOME/.bash_alias
[ -f ~/.bash_alias ] && source $HOME/.bash_alias_distro
[ -f ~/.bash_alias ] && source $HOME/.bash_colors

# colorize dir and ls
#[ -f ~/.dircolors ] && eval `/bin/dircolors -b ~/.dircolors`

# advanced bash-completion
set show-all-if-ambiguous on
[ -f /etc/bash_completion ] && source /etc/bash_completion
complete -cf sudo

# This is the main function for the prompt
set_prompt_style () {

  PS1="┌─[\[\e[34m\]\h\[\e[0m\]][\[\e[32m\]\w\[\e[0m\]]\n└─╼ "

}
set_prompt_style


# auto startx and logout, security ! 
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/vc/1 ]]; then
  startx
  logout
fi
