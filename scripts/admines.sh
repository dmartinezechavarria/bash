#!/bin/bash
#
# @file Admines (admines.sh)
# @brief Contiene funciones para realizar acciones sobre los admines

## 
# @description Devuelve las versiones de los admines en una máquina Linux
#
# @example
#   adminesversion entorno256.arsysdesarrollo.lan
#
# @arg $1 string Hostname de la maquina
#
adminesversion () {

    # Comprobamos los parámetros
    if [ -z "$1" ]
    then
        printerror "No hostname provided"
        return 1
    else
        local hostname=$1

        printtitle "Versiones de los admines en $hostname"
        
        # Sincronizamos
        printlinebreak
        printtext "Connecting to $_FONTBOLD_$hostname$_FONTDEFAULT_ with user$_FONTBOLD_ root$_FONTDEFAULT_ and execute script"
        printlinebreak
        printtext "Connecting to server..."
        printlinebreak

        ssh -i $RSAPRIVATEKEY root@$hostname "rpm -qa | grep admin"

        printlinebreak 
    fi
}

## 
# @description Extrae las funciones de un fichero perl
#
# @example
#   admineslistfunctions admindns.pm
#
# @arg $1 string Ruta al fichero del que extraer las funciones.
#
admineslistfunctions () {

    # Comprobamos los parámetros
    if [ -z "$1" ]
    then
        printerror "No file .pm provided"
        return 1
    else
        local file=$1

        declare -a lines=("$(grep '^sub *' $1)")

        for line in "${lines[@]}"
        do
            local function=${line//sub /}
            function=${function//{/}
            function=${function// /}
            echo "$function"
        done
        
    fi
}