#!/bin/bash
#
# @file Googlechat (googlechat.sh)
# @brief Contiene funciones para realizar acciones sobre la plataforma Google Chat

## 
# @description Envia un mensaje a un webhook de Google Chat
#
# @example
#   googlechatwebhookmessage "https://chat.googleapis.com/v1/spaces/AAAAKEfZZXM/messages?key=AIzaSyDdI0hCZtE6vySjMm-WEfRq3CPzqKqqsHI&token=TQ7fU3qe_i5PKjaOyjW9yqNn7XaFPzU-lyd8xGsi9UA%3D" "Mensaje de prueba"
#
# @arg $1 string Webhook.
# @arg $2 string Mensaje a enviar.
#
googlechatwebhookmessage () {

    # Comprobamos los parámetros
    if [ -z "$1" ]
    then
        printerror "No webhook provided"
        return 1
    else
        webhook=$1

        if [ -z "$2" ]
        then
            printerror "No message provided"
            return 1
        else
            message=$2

            curl --location --request POST "$webhook" \
            --header 'Content-type: application/json' \
            --data-raw "{ \"text\": \"$message\" }" \
            --silent \
            --output /dev/null
        fi
    fi
}