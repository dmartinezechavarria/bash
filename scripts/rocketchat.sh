#!/bin/bash
#
# @file Rocketchat (rocketchat.sh)
# @brief Contiene funciones para realizar acciones sobre la plataforma Rocket.Chat

## 
# @description Envia un mensaje a un canal de Rocketchat
#
# @example
#   rocketchatsendmessage "@dmartinezechavarria" "Mensaje de prueba"
#
# @arg $1 string Canal, puede ser un canal (ap2_arsys) o un usuario (@dmartinezechavarria).
# @arg $2 string Mensaje a enviar.
#
rocketchatsendmessage () {

    # Comprobamos los parámetros
    if [ -z "$1" ]
    then
        printerror "No channel provided"
        return 1
    else
        channel=$1

        if [ -z "$2" ]
        then
            printerror "No message provided"
            return 1
        else
            message=$2

            curl --location --request POST "$ROCKETCHATHOST/api/v1/chat.postMessage" \
            --header "X-Auth-Token: $ROCKETCHATTOKEN" \
            --header "X-User-Id: $ROCKETCHATUSER" \
            --header 'Content-type: application/json' \
            --data-raw "{ \"channel\": \"$channel\", \"text\": \"$message\" }" \
            --silent \
            --output /dev/null
        fi
    fi
}