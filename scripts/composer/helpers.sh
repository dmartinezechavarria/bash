#!/bin/bash
#
# @file Composer/Helpers (composer/helpers.sh)
# @brief Contiene funciones para realizar acciones de composer masivamente sobre los repositorios

## 
# @description Realiza un composer install en los repositorios seleccionados
#
# @example
#   composerinstall all
#
# @arg $1 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
composerinstall () {
    printtitle "Composer install"
    printlinebreak

    local selectedRepositories=()
    if [ -z "$1" ] 
    then
        private_composerpickpaths selectedRepositories
    else
        if [ $1 = "all" ]; 
        then
            selectedRepositories=( $(private_composergitpaths) )
        fi
    fi

    printlinebreak

    if [ ${#selectedRepositories[@]} -eq 0 ]; then
        printerror "No repositories picked"
    else
        private_gitlooppaths "private_composer" "install" "$(echo ${selectedRepositories[@]})"
    fi
}

## 
# @description Realiza un composer update en los repositorios seleccionados
#
# @example
#   composerupdate all
#
# @arg $1 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
composerupdate() {
    printtitle "Composer update"
    printlinebreak

    local selectedRepositories=()
    if [ -z "$1" ] 
    then
        private_composerpickpaths selectedRepositories
    else
        if [ $1 = "all" ]; 
        then
            selectedRepositories=( $(private_composergitpaths) )
        fi
    fi

    printlinebreak

    if [ ${#selectedRepositories[@]} -eq 0 ]; then
        printerror "No repositories picked"
    else
        private_gitlooppaths "private_composer" "update" "$(echo ${selectedRepositories[@]})"
    fi
}

## 
# @description Realiza un composer dump-autoload en los repositorios seleccionados
#
# @example
#   composerdumpautoload all
#
# @arg $1 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
composerdumpautoload() {
    printtitle "Composer dump-autoload"
    printlinebreak

    local selectedRepositories=()
    if [ -z "$1" ] 
    then
        private_composerpickpaths selectedRepositories
    else
        if [ $1 = "all" ]; 
        then
            selectedRepositories=( $(private_composergitpaths) )
        fi
    fi

    printlinebreak

    if [ ${#selectedRepositories[@]} -eq 0 ]; then
        printerror "No repositories picked"
    else
        private_gitlooppaths "private_composer" "dump-autoload" "$(echo ${selectedRepositories[@]})"
    fi
}

##
# @internal
#
# @description Ejecuta Composer en un repositorio con unos parámetros
#
# @arg $1 string Repositorio.
# @arg $2 string Parámetros para la llamada a Composer.
#
private_composer () {
    local parameters=$2

    ( # try
        set -e # Exit if error in any command

        local composerCall="composer $parameters"

        printtext "Executing $_COLORYELLOW_$composerCall$_COLORDEFAULT_ on $_FONTBOLD_$1$_FONTDEFAULT_"

        ( set -x; $composerCall; )

        printlinebreak
        printsuccess "Finished $composerCall on $1"
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printlinebreak
        printerror "An error occurred while execute composer"
        printlinebreak
        return $errorCode
    fi
}

##
# @internal
#
# @description Devuelve los repositorios Git disponibles con Composer
#
# @noargs
#
private_composergitpaths () {
    local paths=( $(private_gitpaths) )

    filteredPaths=()
    for path in ${paths[@]}; do
        if [[ -f "$GITROOT$path/composer.json" ]]; then
            filteredPaths+=("$path")
        fi
    done

    echo ${filteredPaths[@]}
}

##
# @internal
#
# @description Muestra un select para elegir paths de GIT con Composer
#
# @noargs
#
private_composerpickpaths () {
    local retval=$1
    local paths=( $(private_composergitpaths) )

    printtext "Pick repositories with spacebar and confirm with enter"
    printlinebreak

    promptformultiselect results "$(echo ${paths[@]})" #"api_proc panel" 

    eval $retval='("${results[@]}")'
}