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

# rocketchatstart Function
# -----------------------------------
# Parametro 1: Nombre para la feature
# Parametro 2 (opcional): Rama de origen para la feature
# 
# Crea una nueva feature a partir de una rama, si no se pasa rama utiliza dev
# -----------------------------------
#rocketchatstart () {
    #local JIRAAuthorization=$(echo -n "$UNITEDUSER:$UNITEDPWD" | openssl base64)


    #local response=$(curl --location --request GET "$CONFLUENCEHOST/rest/api/content/48183489?expand=body.storage" \
    #--insecure --silent \
    #--header "Authorization: Basic $JIRAAuthorization")

    #local content=$(echo -n $response | grep -Po '"value":.*?[^\\]",')
    #local table=$(echo -n $content | grep -Po '<tr><td>.*?</td></tr>')


    #local lines=($(echo -n $table | grep -Poi "^<tr>.*?<\/tr>"))
    #echo $table


    #local entries=$(awk -F'</tr>' '{print $table}')

    #local td=$(echo -n $content | grep -Po '<ac:task-status>complete</ac:task-status>')

    #printarray ${lines[@]}

#}