#!/bin/bas
#
# @file Servers/Development (servers/development.sh)
# @brief Contiene funciones para interactuar con el servidor de desarrollo

## 
# @description Ejecuta el remake de config
#
# @example
#   devremakeconfig
#
# @noargs
#
devremakeconfig () {

    printtitle "Remake Config"
        
    # Sincronizamos
    printlinebreak
    printtext "Connecting to $_FONTBOLD_$SYNCSERVERHOST$_FONTDEFAULT_ with user $_FONTBOLD_$SYNCSERVERUSER$_FONTDEFAULT_ and execute script"
    printlinebreak
    printtext "Connecting to server..."
    printlinebreak

    ssh -i $RSAPRIVATEKEY  $DEVSERVERUSER@$DEVSERVERHOST -t  "cd /usr/share/app/tools/dev_environment/ && sh environmentManager.sh" < /dev/tty

    printlinebreak
    printsuccess "Remake completed successfully"
}

## 
# @description Elimina la cache de smarty
#
# @example
#   devcleancache
#
# @noargs
#
devcleancache () {

    printtitle "Remove Smarty cache"
        
    # Sincronizamos
    printlinebreak
    printtext "Connecting to $_FONTBOLD_$SYNCSERVERHOST$_FONTDEFAULT_ with user $_FONTBOLD_$SYNCSERVERUSER$_FONTDEFAULT_ and execute script"
    printlinebreak
    printtext "Connecting to server..."
    printlinebreak

    ssh -i $RSAPRIVATEKEY  $DEVSERVERUSER@$DEVSERVERHOST "rm -f /usr/share/app/$ARSYSUSER/panel/tmp/smarty/templates_c/*"

    printlinebreak
    printsuccess "Cache cleaned successfully"
}