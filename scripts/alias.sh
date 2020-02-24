#!/bin/bash
#
# @file Alias (alias.sh)
# @brief Contiene alias utiles para el resto de scripts y el uso normal de bash

alias bashrc='source ~/.bashrc'

alias ll='ls -l'
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