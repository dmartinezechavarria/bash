#!/bin/bash
#
# @file Servers/Machines (servers/machines.sh)
# @brief Contiene funciones para interactuar con máquinas

## 
# @description Comprueba la salud de DNS de las máquinas pasadas en un csv con tres columnas separadas por tabuladores (hostname, hostname de servicio, IP pública)
#
# @example
#   machinesdnshealthy < ~/machines.csv > ~/maquinas_erroneas.csv
#
# @noargs
#
machinesdnshealthy () {
    while IFS=$'\t' read -r column1 column2 ; do
        column3=$(echo $column2 | tr "\r\n" " ")
        ( # try
            
            set -e # Exit if error in any command

            machinednshealthy ${column1} ${column2}
        )
        errorCode=$?
        if [ $errorCode -ne 0 ]; then
            local errorMessage=$errorCode
            case $errorCode in
                2)
                    errorMessage="No devuelve IP"
                ;;
                3)
                    errorMessage="La IP inversa no responde"
                ;;
                4)
                    errorMessage="La resolución inversa es incorrecta"
                ;;
                5)
                    errorMessage="Resolución de hostname de servicio incorrecta"
                ;;
            esac
            
            echo -e "${column1}\t${column2}\t$errorMessage"
        fi
    done < "${1:-/dev/stdin}"
}

## 
# @description Comprueba la salud de DNS de una máquina
#
# @example
#   machinednshealthy atlante.servidoresdns.net atlante.arsys.server.lan 217.76.128.10
#
# @arg $1 string Hostname de la máquina.
# @arg $2 string Hostname de servicio con el cambiazo.
# @arg $3 string IP pública de la máquina.
#
machinednshealthy () {
    if [ -z "$1" ]; then
        printerror "No hostname provided"
        return 1
    else
        if [ -z "$2" ]; then
            printerror "No service hostname provided"
            return 1
        else
            local hostname=$1
            local serviceHostname=$2

            ( # try
                set -e # Exit if error in any command

                reverseIP=$(nslookup $hostname | awk '/Address: / { print $2 }')
                # Comprobamos la IP inversa
                if [ "$reverseIP" == "" ]; then
                    return 2
                fi

                #reverseIP=$(host $ip | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
                # Comprobamos si la IP inversa es la correcta
                #if [ "$ip" != "$reverseIP" ]; then
                #    return 2
                #fi

                reverseHostname=$(nslookup $reverseIP | awk '/name = / { print $4 }')

                # Comprobamos el hostname inverso
                if [ "$reverseHostname" == "" ]; then
                    return 3
                fi

                if [ "$hostname" != "${reverseHostname::${#reverseHostname}-1}" ]; then
                    return 4
                fi

                #serviceIP=$(nslookup $serviceHostname | awk '/Address: / { print $2 }')
                # Comprobamos la IP de servicio
                #if [ "$serviceIP" == "" ]; then
                #    return 5
                #fi
            )
            errorCode=$?
            if [ $errorCode -ne 0 ]; then
                return $errorCode
            fi
        fi
    fi

    return 0
}