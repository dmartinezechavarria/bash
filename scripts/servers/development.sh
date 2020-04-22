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

    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER

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
        
    printtitleconnect $DEVSERVERHOST $DEVSERVERUSER

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

    ssh -i $RSAPRIVATEKEY $DEVSERVERUSER@$DEVSERVERHOST -t  "echo '' && tail -f /var/opt/remi/php72/log/php-fpm/www-error.log" < /dev/tty

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