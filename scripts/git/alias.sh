#!/bin/bash
#
# @file Git/Alias (git/alias.sh)
# @brief Contiene alias para Git

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
