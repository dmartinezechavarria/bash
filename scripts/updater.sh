#!/bin/bash
#
# @file Updater (updater.sh)
# @brief Contiene funciones para actualizar las tools

##
# @internal
#
# @description Devuelve los repositorios Git disponibles
#
# @noargs
#
toolscheckupdates () {
    local pwd=$(pwd)
    cd $SCRIPTPATH

    printtext "Checking for updates..."

    local BRANCH="main"
    local LAST_UPDATE=`git show --no-notes --format=format:"%H" $BRANCH | head -n 1`
    local LAST_COMMIT=`git show --no-notes --format=format:"%H" origin/$BRANCH | head -n 1`

    git remote update &> /dev/null
    if [ "$LAST_COMMIT" != "$LAST_UPDATE" ]; then
        printwarning "New version available"
        printtext "Installing..."
        git pull --no-edit &> /dev/null
        printsuccess "Installation complete"
        clear
        bashrc
    else
        printtext "No updates available"
        cd $pwd
    fi
}

