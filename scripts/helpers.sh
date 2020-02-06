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
    printf "$_FONTBOLD_%*s$_FONTDEFAULT_\n" "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
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
    echo ""
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
    printf "➜ $@\n"
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
    printf "${_COLORGREEN_}✔ %s${_COLORDEFAULT_}\n" "$@"
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
    printf "${_COLORRED_}✖ %s${_COLORDEFAULT_}\n" "$@" >&2
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
    printf "${_COLORYELLOW_}➜ %s${_COLORDEFAULT_}\n" "$@"
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

    printlinebreak
    for element in ${array[@]}
    do
    printf "• $element\n"
    done
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

## 
# @description Mata los procesos de SSH agent que haya corriendo
#
# @example
#   killsshagent
#
# @noargs
#
killsshagent () {
    { # try
        kill -9 $(ps aux | grep '/usr/bin/ssh-agent' | awk '{print $1}')
    } || { # catch
        printerror "The process could not be killed"
        return 1
    }
}

## 
# @description Muestra un picker multiselect
#
# @example
#   promptformultiselect results "$(echo ${array[@]})" "panel procws" 
#
# @arg $1 array Variable a la que se devolverá el resultado.
# @arg $2 string String de opciones separadas por espacio.
# @arg $3 string Opcional, String de las opciones seleccionadas por defecto separadas por espacio.
#
promptformultiselect () {
    
    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()   { printf "$ESC[?25h"; }
    cursor_blink_off()  { printf "$ESC[?25l"; }
    cursor_to()         { printf "$ESC[$1;${2:-1}H"; }
    print_inactive()    { printf "$2   $1 "; }
    print_active()      { printf "$2  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()    { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()         {
      local key
      IFS= read -rsn1 key 2>/dev/null >&2
      if [[ $key = ""      ]]; then echo enter; fi;
      if [[ $key = $'\x20' ]]; then echo space; fi;
      if [[ $key = $'\x1b' ]]; then
        read -rsn2 key
        if [[ $key = [A ]]; then echo up;    fi;
        if [[ $key = [B ]]; then echo down;  fi;
      fi 
    }
    toggle_option()    {
      local arr_name=$1
      eval "local arr=(\"\${${arr_name}[@]}\")"
      local option=$2
      local value=${options[$option]}

      if [[ " ${arr[@]} " =~ " ${value} " ]]; then
        for i in ${!arr[@]};do
            if [ "${arr[$i]}" == "$value" ]; then
                unset arr[$i]
            fi 
        done
        arr2=( "${arr[@]}" )
        arr=($(echo ${arr2[*]}| tr " " "\n" | sort -n))
      else
        arr+=( $value )
      fi

      eval $arr_name='("${arr[@]}")'
    }

    local retval=$1
    local options=( $(echo "$2") )
    local defaults

    if [[ -z $3 ]]; then
        defaults=()
    else
        defaults=( $(echo "$3") )
    fi

    local selected=()
    selected+=("${defaults[@]}")

    for ((i=0; i<${#options[@]}; i++)); do
      printf "\n"
    done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - ${#options[@]}))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local active=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for option in "${options[@]}"; do
            local prefix="[ ]"
            if [[ " ${selected[@]} " =~ " ${option} " ]]; then
              prefix="[x]"
            fi

            cursor_to $(($startrow + $idx))
            if [ $idx -eq $active ]; then
                print_active "$option" "$prefix"
            else
                print_inactive "$option" "$prefix"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            space)  toggle_option selected $active;;
            enter)  break;;
            up)     ((active--));
                    if [ $active -lt 0 ]; then active=$((${#options[@]} - 1)); fi;;
            down)   ((active++));
                    if [ $active -ge ${#options[@]} ]; then active=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    eval $retval='("${selected[@]}")'
}