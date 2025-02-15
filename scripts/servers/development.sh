#!/bin/bash
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

    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST -t  "cd $DEVSERVERREMAKECONFIGPATH && sh environmentManager.sh" < /dev/tty

    printlinebreak
    printsuccess "Remake completed successfully"
}

## 
# @description Crea un tunel SSH al puerto 9000 del servidor de desarrollo para usar xdebug
#
# @example
#   devxdebugtunnel
#
# @noargs
#
devxdebugtunnel () {

    printtitle "Creating SSH tunnel to port 9003"

    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER

    ssh -i $RSAPRIVATEKEY -R 9003:localhost:9003 $DEVSERVERUSER@$DEVSERVERHOST

    printlinebreak
    printsuccess "SSH tunnel destroyed"
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
        
    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST "php /usr/share/app/memoria_ap2_.php"

    printlinebreak
    printsuccess "Memory variables have been set up sucessfully"
}

## 
# @description Genera un nuevo token Kestone para las APIs
#
# @example
#   devkeystonegeneratetoken
#
# @noargs
#
devkeystonegeneratetoken () {

    printtitle "Generate Keystone Token"
        
    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST "php /usr/share/app/$ARSYSUSER/procws/bin/scripts/generateKeystoneToken.php"

    printlinebreak
    printsuccess "Check Keystone token generation in Kibana"
}

## 
# @description Guarda el token Kestone para las APIs en memoria
#
# @example
#   devkeystonesetmemory
#
# @noargs
#
devkeystonesetmemory () {

    printtitle "Set Keystone Token in memory"
        
    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST "php /usr/share/app/$ARSYSUSER/procws/bin/scripts/setMemCacheKeystoneToken.php"

    printlinebreak
    printsuccess "Check Keystone token set in Kibana"
}

## 
# @description Genera un nuevo token Kestone para las APIs y lo guarda en memoria. Combina devkeystonegeneratetoken y devkeystonesetmemory
#
# @example
#   devkeystone
#
# @noargs
#
devkeystone () {
    devkeystonegeneratetoken
    printlinebreak
    devkeystonesetmemory
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

    printtitle "Clean Smarty cache"
        
    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER

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
        
    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER
    printtext "Showing PHP log (Ctrl+c to exit)..."
    printlinebreak

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST -t  "echo '' && tail -f $DEVSERVERPHPERRORLOGPATH" < /dev/tty

    printlinebreak
    printsuccess "Bye"
}

## 
# @description Muestra el log de procesos del servidor de desarrollo
#
# @example
#   devlogprocess
#
# @noargs
#
devlogprocess () {

    printtitle "Show process log"
        
    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER
    printtext "Showing process log (Ctrl+c to exit)..."
    printlinebreak

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST -t  "echo '' && tail -f /tmp/checkerSch.$ARSYSUSER.log" < /dev/tty

    printlinebreak
    printsuccess "Bye"
}

## 
# @description Elimina la carpeta, el vhost, la configuracion fpm y el usuario de un dominio en una maquina
#
# @example
#   devremovedomainweb entornox255.arsysdesarrollo.lan c4a-davidpes01.com
#
# @arg $1 string Host de la maquina en la que se quiere eliminar el dominio.
# @arg $2 string Dominio a eliminar.
#
devremovedomainweb () {
    # Comprobamos los parámetros
    if [ -z "$1" ]
    then
        printerror "No host provided"
        return 1
    else
        channel=$1

        if [ -z "$2" ]
        then
            printerror "No domain provided"
            return 1
        else
            local user='root'

            printtitle "Remove domain web $2"
                
            # Sincronizamos
            printtitleconnect $1 $user

            ssh $user@$1 "rm -Rf /etc/httpd/conf/$2/ && rm -Rf /var/www/vhost/$2/ && rm -Rf /etc/httpd/conf/vhost/$2/ && userdel $2"

            printlinebreak
            printsuccess "Domain $2 removed successfully"
        fi
    fi
}