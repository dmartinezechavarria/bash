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

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST -t  "cd /usr/share/app/tools/dev_environment/ && sh environmentManager.sh" < /dev/tty

    printlinebreak
    printsuccess "Remake completed successfully"
}

## 
# @description Setea las variables de memoria necesarias para arrancar AP-2
#
# @example
#   devsetmemoryvars
#
# @noargs
#
devsetmemoryvars () {

    printtitle "Set memory variables"
        
    # Sincronizamos
    printlinebreak
    printtext "Connecting to $_FONTBOLD_$DEVSERVERHOST$_FONTDEFAULT_ with user $_FONTBOLD_$DEVSERVERUSER$_FONTDEFAULT_ and execute script"
    printlinebreak
    printtext "Connecting to server..."
    printlinebreak

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST "php72 /usr/share/app/memoria_ap2_.php"

    printlinebreak
    printsuccess "Memory variables have been set up sucessfully"
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
    printtext "Connecting to $_FONTBOLD_$DEVSERVERHOST$_FONTDEFAULT_ with user $_FONTBOLD_$DEVSERVERUSER$_FONTDEFAULT_ and execute script"
    printlinebreak
    printtext "Connecting to server..."
    printlinebreak

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST "rm -f /usr/share/app/$ARSYSUSER/panel/tmp/smarty/templates_c/*"

    printlinebreak
    printsuccess "Cache cleaned successfully"
}

## 
# @description Muestra el log de PHP FPM del servidor de desarrollo
#
# @example
#   devlogphp
#
# @noargs
#
devlogphp () {

    printtitle "Show PHP log"
        
    # Sincronizamos
    printlinebreak
    printtext "Connecting to $_FONTBOLD_$DEVSERVERHOST$_FONTDEFAULT_ with user $_FONTBOLD_$DEVSERVERUSER$_FONTDEFAULT_ and execute script"
    printlinebreak
    printtext "Connecting to server..."
    printlinebreak
    printtext "Showing PHP log (Ctrl+c to exit)..."
    printlinebreak

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST -t  "echo '' && tail -f /var/opt/remi/php72/log/php-fpm/www-error.log" < /dev/tty

    printlinebreak
    printsuccess "Bye"
}