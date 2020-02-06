#!/bin/bash
#
# @file Git/Alias (git/alias.sh)
# @brief Contiene alias para Git

alias gitstatusall='gitstatus all'
alias gitpullall='gitpull all'
alias gitfetchall='gitfetch all'

# Alias que realiza un checkout a una rama remota sobre todos los repositorios
gitcheckoutremoteall () {
    gitcheckoutremote $1 all
}

# Alias que realiza un checkout a una rama local sobre todos los repositorios
gitcheckoutall () {
    gitcheckout $1 all
}

# Alias que muestra el log de todos los repositorios
gitlogall () {
    gitlog $1 all
}
