#!/bin/bash
#
# @file Helpers (helpers.sh)
# @brief Contiene funciones generales para bash que utilizan el resto de scripts

## 
# @description Dibuja un separador del ancho del terminal
#
# @example
#   printseparator
#
# @noargs
#
printseparator () {
    printf "$_FONTBOLD_%*s$_FONTDEFAULT_\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' - >&2
}

## 
# @description Realiza un salto de linea
#
# @example
#   printlinebreak
#
# @noargs
#
printlinebreak () {
    echo "" >&2
}

## 
# @description Escribe un mensaje
#
# @example
#   printtext "Mensaje normalucho"
#
# @arg $1 string Mensaje.
#
printtext () {
    echo -e $1 >&2
}

## 
# @description Escribe un mensaje de exito
#
# @example
#   printsuccess "Mensaje de exito"
#
# @arg $1 string Mensaje.
#
printsuccess () {
    printtext "$_BACKGROUNDGREEN_$_COLORWHITE_ $1 $_COLORDEFAULT_$_BACKGROUNDDEFAULT_"
}

## 
# @description Escribe un mensaje de error
#
# @example
#   printerror "Mensaje de error"
#
# @arg $1 string Mensaje.
#
printerror () {
    printtext "$_BACKGROUNDRED_$_COLORWHITE_ $1 $_COLORDEFAULT_$_BACKGROUNDDEFAULT_"
}

## 
# @description Escribe un mensaje de alerta
#
# @example
#   printwarning "Mensaje de alerta"
#
# @arg $1 string Mensaje.
#
printwarning () {
    printtext "$_BACKGROUNDYELLOW_$_COLORBLACK_ $1 $_COLORDEFAULT_$_BACKGROUNDDEFAULT_"
}

## 
# @description Muestra un array
#
# @example
#   printarray 1 2 3
#
# @arg $@ any Elementos del array.
#
printarray () {
    array=("$@")
    printf '%s\n' "${array[@]}"
    printlinebreak
}

## 
# @description Muestra una representacion de debug de un array
#
# @example
#   debugarray 1 2 3
#
# @arg $@ any Elementos del array.
#
debugarray () {
    array=("$@")
    printf '%s, ' "array(${array[@]})"
    printlinebreak
}

## 
# @description Concatena elementos pasados como parametros o elemento de un array separados por un caracter
#
# @example
#   joinby . 1 2 3
#   1.2.3
#
# @arg $1 string Separador.
# @arg $@ any Elementos a unir.
#
joinby () { 
    local IFS="$1";
    shift;
    echo "$*";
}

## 
# @description Escribe un titulo
#
# @example
#   printtitle "Texto del titulo"
#
# @arg $1 string Texto del titulo.
#
printtitle () {
    printseparator
    #local titleLength=${#1}
    #local realColumns=`expr ${COLUMNS:-$(tput cols)} - $titleLength`
    #printf "$_FONTBOLD_$1%*s$_FONTDEFAULT_\n" "$realColumns" '' | tr ' ' - >&2
    printtext "$_FONTBOLD_ $1$_FONTDEFAULT_"
    printseparator
}