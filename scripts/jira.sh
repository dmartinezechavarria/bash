#!/bin/bash
#
# @file Jira (jira.sh)
# @brief Contiene funciones para realizar acciones sobre la plataforma Jira

## 
# @description Crea un aviso en Jira para una intervencion
#
# @example
#   jirasendnotice "Titulo de la intervencion" 2020-05-06 10:00 "Texto largo de la intervencion" cb
#
# @arg $1 string Mensaje a enviar.
# @arg $2 string Fecha de la intervencion (YYYY-MM-DD).
# @arg $3 string Hora de la intervencion (HH:MM), se programará una duración de una hora.
# @arg $4 string Opcional, Descripcion larga de la intervencion, si no se pasa se usa el mensaje de $1.
# @arg $5 string Opcional, Si se le pasa el valor "cb" incluye a CloudBuilder en el aviso
#
jirasendnotice () {

    # Comprobamos los parámetros
    if [ -z "$1" ]
    then
        printerror "No message provided"
        return 1
    else
        local message=$1

        if [ -z "$2" ]
        then
            printerror "No date provided (yyyy-mm-dd)"
            return 1
        else
            local date=$2

            local dateregexp="^([12][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]))$"
            if ! [[ "$date" =~  $dateregexp ]]; then
                printerror "Invalid date $date must be yyyy-mm-dd"
                return 1
            fi

            if [ -z "$3" ]
            then
                printerror "No time provided"
                return 1
            else
                local time=$3

                local timeregexp="^(0[0-9]|1[0-9]|2[0-2]):[0-5][0-9]$"
                if ! [[ "$time" =~  $timeregexp ]]; then
                    printerror "Invalid time $time must be hh:mm"
                    return 1
                fi

                local description=$4
                if [ -z "$4" ]
                then
                    description=$1
                fi

                local watchers='{ "name": "ArsysPlannedChanges"}, { "name": "dsainzpajares" }, { "name": "flestadomahave" }, { "name": "gagredalabrador" }, { "name": "gbastidarodriguez" }, { "name": "iramirezsuarez" }, { "name": "joriamartinez" }, { "name": "svictormaria" }, { "name": "ivorozbueno" }, { "name": "mfresnedamartinez" }, { "name": "dmartinezechavarria" }, { "name": "jbelmontegoyeneche" }'
                local teams=(cb)
                if [[ " ${teams[@]} " =~ " ${5} " ]]; then
                    local watchers='{ "name": "ArsysPlannedChanges"}, { "name": "dsainzpajares" }, { "name": "flestadomahave" }, { "name": "gagredalabrador" }, { "name": "gbastidarodriguez" }, { "name": "iramirezsuarez" }, { "name": "joriamartinez" }, { "name": "svictormaria" }, { "name": "ivorozbueno" }, { "name": "mfresnedamartinez" }, { "name": "dmartinezechavarria" }, { "name": "jbelmontegoyeneche" }, { "name": "cbenitohernandez" }, { "name": "andrmoralrodriguez" }, { "name": "aramirezfernandez" }, { "name": "egomezcejudo" }, { "name": "ldan" }, { "name": "cmartinezibanez" }'
                fi

                # Sumamos una hora al inicio
                local timeParts=(${time//:/ })
                local hourPart=${timeParts[0]}
                local minutePart=${timeParts[1]}
                hourPart=$((hourPart + 1))
                timeParts=( $hourPart $minutePart )
                local finishTime=$(joinby : "${timeParts[@]}")

                local timeOffset=$(date +%z)

                local JIRAAuthorization=$(echo -n "$UNITEDUSER:$UNITEDPWD" | openssl base64)

                #local data='{
                #    "fields": {
                #        "project":
                #        {
                #            "key": "PRUEB"
                #        },
                #        "summary": "REST ye merry gentlemen.",
                #        "description": "Creating of an issue using project keys and issue type names using the REST API",
                #        "issuetype": { "id": "10003" },
                #        "customfield_10028": { "id": "10026" },
                #        "customfield_10029": [{ "id": "10027" }],
                #        "customfield_10030": [{ "id": "5eb3aa8ba39bb50bb10e9074" }],
                #        "customfield_10015": "'$date'T'$time':00.908+0000",
                #        "duedate": "'$date'T'$finishTime':00.908+0000",
                #        "labels": ["ARSYS", "PIENSA"],
                #        "customfield_10031": [ {"id": "5eb3aa8ba39bb50bb10e9074" } ]
                #    }
                #}'

                local data='{
                    "fields": {
                        "project":
                        {
                            "key": "TECCM"
                        },
                        "summary": "'$message'",
                        "description": "'$description'",
                        "issuetype": { "id": "11408" },
                        "customfield_13809": { "id": "13302" },
                        "customfield_13811": [{ "id": "13469" }],
                        "customfield_11912": { "name": "Auto-Domain - Arsys Products and Tools Development" },
                        "customfield_13806": "'$date'T'$time':00.908'$timeOffset'",
                        "customfield_13807": "'$date'T'$finishTime':00.908'$timeOffset'",
                        "labels": ["ARSYS", "PIENSA"],
                        "customfield_13826": [ '$watchers' ]
                    }
                }'

                echo $data

                local response=$(curl --location --request POST "$JIRAHOST/rest/api/latest/issue" \
                --insecure --silent \
                --header "Authorization: Basic $JIRAAuthorization" \
                --header "Content-Type: application/json" \
                --data "$data")

                echo $response
            fi
        fi
    fi
}