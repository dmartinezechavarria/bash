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
    gitcheckout $1 all
}

##
# @internal
#
# @description Alias que realiza un checkout a una rama remota sobre todos los repositorios
#
# @arg $1 string Rama remota
#
gitcheckoutremoteall () {
    gitcheckoutremote $1 all
}


##
# @internal
#
# @description Alias que muestra el log de todos los repositorios
#
# @arg $1 int Opciona, número de líneas a mostrar
#
gitlogall () {
    gitlog $1 all
}
