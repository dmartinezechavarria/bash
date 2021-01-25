#!/bin/bash
#
# @file Alias (alias.sh)
# @brief Contiene alias utiles para el resto de scripts y el uso normal de bash

alias bashrc='source ~/.bashrc'

alias l.='ls -d .* --color=auto'
alias ll='ls -laiFh --color'
alias ls='ls --color=auto'
alias la='ls -lah'
alias lt='ls --human-readable --size -1 -S --classify'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

alias gh='history|grep'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias vi='vim'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
alias xless='less -RNi'