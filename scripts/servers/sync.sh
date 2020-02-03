#!/bin/bas
#
# @file Servers/Sync (servers/sync.sh)
# @brief Contiene funciones para la sincronizacion de los servidores

## 
# @description Ejecuta la sincronizacion de servidores para un proyecto y entorno
#
# @example
#   syncservers pdc pre
#
# @arg $1 string Proyecto, puede ser pdc o webadmin.
# @arg $2 string Entorno, puede ser pre o pro.
#
syncservers () {
    # Comprobamos que se pasa un proyecto
    if [ -z "$1" ]
    then
        printerror "No project provided"
        return 1
    else
        project=$1

        # Comprobamos que se pasa un entorno
        if [ -z "$2" ]
        then
            printerror "No environment provided"
            return 1
        else
            env=$2

             # Comprobamos que el proyecto existe
            local projects=(pdc webadmin)
            if ! [[ " ${projects[@]} " =~ " ${project} " ]]; then
                printerror "Project '$project' no exists"
                return 1
            fi

            # Comprobamos que el entorno existe
            local environments=(pre pro)
            if ! [[ " ${environments[@]} " =~ " ${env} " ]]; then
                printerror "Environment '$env' no exists"
                return 1
            fi

            printtitle "Syncing project $_COLORYELLOW_$project$_COLORDEFAULT_ environment $_COLORGREEN_$env$_COLORDEFAULT_"
                
            # Sincronizamos
            printlinebreak
            printtext "Connecting to $_FONTBOLD_$SYNCSERVERHOST$_FONTDEFAULT_ with user $_FONTBOLD_$SYNCSERVERUSER$_FONTDEFAULT_ and execute script"
            printlinebreak
            printtext "Syncing machines..."
            printlinebreak

            ssh -i $RSAPRIVATEKEY $SYNCSERVERUSER@$SYNCSERVERHOST "sh ~/bin/syncservers-pdc.sh $env"

            printlinebreak
            printsuccess "Sync completed successfully"
        fi 
    fi
}