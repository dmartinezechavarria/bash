#!/bin/bash
#
# @file Git/Alias (git/alias.sh)
# @brief Contiene alias para Git

alias gadd='git add'
alias gbranch='git branch'
alias gcheckout='git checkout'
alias gcommit='git commit'
alias gconfig='git config'
alias gdiff='git --no-pager diff --patience --color=always'
alias gfetch='git fetch'
alias glog='git log --graph --abbrev-commit --decorate=full --all --color=always --format='\''%C(bold blue)%h%C(reset) %C(red)%an%C(reset)%C(bold yellow)%d%C(reset) %C(bold green)(%cD)%C(reset) [%C(bold white)%s%C(reset)] %b%N'\'''
alias glog2='glog --pretty --source --name-status'
alias glogbranch='git log --graph --pretty=oneline --abbrev-commit --first-parent --format='\''%C(bold blue)%h%C(reset) %C(red)%an%C(reset)%C(bold yellow)%d%C(reset) %C(bold green)(%cD)%C(reset) [%C(bold white)%s%C(reset)] %b%N'\'''
alias gmerge='git merge'
alias gpull='git pull'
alias grebase='git rebase'
alias grep='nice -n 19 grep --color --exclude-dir=".svn" --exclude-dir=".git"'
alias greset='git reset'
alias gstatus='git status'
alias gtag='git tag'
alias gupdate='git fetch --all --prune --tags; git pull --all --tags'

alias gitstatusall='gitstatus all'
alias gitpullall='gitpull all'
alias gitfetchall='gitfetch all'

##
# @internal
#
# @description Alias que realiza un checkout a una rama local sobre todos los repositorios
#
# @arg $1 string Rama local
#
gitcheckoutall () {
    if [ -z "$1" ] 
    then
        printerror "No local branch supplied"
        return 1
    else
        gitcheckout $1 all
    fi
}

##
# @internal
#
# @description Alias que realiza un checkout a una rama remota sobre todos los repositorios
#
# @arg $1 string Rama remota
#
gitcheckoutremoteall () {
    if [ -z "$1" ] 
    then
        printerror "No remote branch supplied"
        return 1
    else
        gitcheckoutremote $1 all
    fi
}

##
# @internal
#
# @description Alias que muestra el log de todos los repositorios
#
# @arg $1 int Opciona, número de líneas a mostrar
#
gitlogall () {
    if [ -z "$1" ] 
    then
        printerror "No number of lines supplied"
        return 1
    else
        gitlog $1 all
    fi
}
