#!/bin/bash
#
# @file Servers/Deploy (servers/deploy.sh)
# @brief Contiene funciones para realizar subidas


##
# @internal
#
# @description Recibe un proyecto y un entorno y realiza un deploy
#
# @arg $1 string Proyecto.
# @arg $2 string Entorno dev/pre/pro.
#
deployproject() {
    local project=$1
    local environment=$2

    echo $project
    echo $environment
    
    : '
    TOKEN=$(curl -s 'https://entorno275.arsysdesarrollo.lan:8082/api/authenticate' \
    -H 'Connection: keep-alive' \
    -H 'Pragma: no-cache' \
    -H 'Cache-Control: no-cache' \
    -H 'sec-ch-ua: "Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.128 Safari/537.36' \
    -H 'Content-Type: application/json;charset=UTF-8' \
    -H 'Origin: https://entorno275.arsysdesarrollo.lan:8082' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Referer: https://entorno275.arsysdesarrollo.lan:8082/' \
    -H 'Accept-Language: es-ES,es;q=0.9,en;q=0.8,gl;q=0.7' \
    -H 'Cookie: io=ciApIyjI6P8eQSo_AAAL' \
    --data-raw '{"user":"master","password":"Plat3ro"}' \
    --compressed \
    --insecure | jq -r '.token')

    curl 'https://entorno275.arsysdesarrollo.lan:8082/api/deploy' \
    -H 'Connection: keep-alive' \
    -H 'Pragma: no-cache' \
    -H 'Cache-Control: no-cache' \
    -H 'sec-ch-ua: "Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'x-access-user: master' \
    -H 'sec-ch-ua-mobile: ?0' \
    -H 'x-access-token: '$TOKEN \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.128 Safari/537.36' \
    -H 'Content-Type: application/json;charset=UTF-8' \
    -H 'Origin: https://entorno275.arsysdesarrollo.lan:8082' \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Referer: https://entorno275.arsysdesarrollo.lan:8082/' \
    -H 'Accept-Language: es-ES,es;q=0.9,en;q=0.8,gl;q=0.7' \
    -H 'Cookie: io=eV3dmAobsEbl4hMfAAAN' \
    --data-raw '{"environment":"dev","user":"master","projects":[{"id":"ap2-ap2-web-tool","name":"ap2-web-tool","deploymentType":"branch","deploymentSource":{"name":"master","hash":""},"roles":{"deploy":["entorno302.arsysdesarrollo.lan"]},"scriptAvailable":true,"script":"default.js"}]}' \
    --compressed \
    --insecure
    '
}
