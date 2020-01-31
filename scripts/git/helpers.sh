#!/bin/bash
#
# @file Git/Helpers (git/helpers.sh)
# @brief Contiene funciones generales de GIT

## 
# @description Permite acceder rapidamente al directorio que contiene los repositorios GIT
#
# @example
#   cdgit
#
# @noargs
#
cdgit () {
    if [ -z "$1" ]
    then
        printtext "No path supplied going to$_FONTBOLD_ GIT root$_FONTDEFAULT_"
        cd $GITROOT
    else
        cd $GITROOT
        local path="$1/"
        local paths=($(ls -d *))
        
        if (( ${#paths[@]} == 0 )); then
            printerror "No valid paths found"
        else
            if [[ " ${paths[@]} " =~ " ${path} " ]]; then
                printtext "Go into $_FONTBOLD_${path::-1}$_FONTDEFAULT_"
                cd $GITROOT$path
            else
                printtext "Path $_FONTBOLD_${path::-1}$_FONTDEFAULT_ not found"
                printlinebreak
                printtext "Available paths:"
                printarray ${paths[@]}
                printlinebreak
            fi
        fi
    fi
}

## Recorre los paths con repositorios GIT y ejecuta el primer parametro pasandole como primer parametro el path 
## y como segundo parametro opcional el segundo parametro recibido
private_gitlooppaths () {
    local secondArgument=""
    if [ $# -eq 2 ]
    then
    secondArgument=$2
    fi

    local pwd=$(pwd)
    cd $GITROOT
    
    local paths=($(ls -d *))
    local excludePaths=("prueba")

    for path in ${paths[@]} ;
    do
        if ! [[ " ${excludePaths[@]} " =~ " ${path::-1} " ]]; then
            local fullPath="$GITROOT$path"
            if [ -d "${fullPath}" ] ; then
                cd $fullPath
                eval "$1 ${path::-1} $secondArgument"
            fi
        fi
    done

    cd $pwd
}

## Recibe una rama como parametro y hace checkout en todos los repositorios GIT a esa rama
private_gitcheckout () {
    local branch=$2
    local branches=($(git branch | grep "[^* ]+" -Eo))
    local currentBranch=$(gitbranch)

    local resume="$(private_gitresume $1)"
    printtitle "$resume => $_COLORYELLOW_$branch$_COLORDEFAULT_"

    if [[ " ${branches[@]} " =~ " ${branch} " ]]; then
        git checkout $branch
        printtext "Path $_FONTBOLD_$1$_FONTDEFAULT_ on branch $_COLORGREEN_$branch$_COLORDEFAULT_ now"
    else
        printtext "Branch $_COLORGREEN_$branch$_COLORDEFAULT_ not found in $_FONTBOLD_$1$_FONTDEFAULT_"
        printlinebreak
        printtext "Available branchs for $_FONTBOLD_$1$_FONTDEFAULT_:"
        printarray ${branches[@]}
    fi

    printseparator
    printlinebreak
}

## 
# @description Realiza un checkout a una rama local sobre todos los repositorio
#
# @example
#   gitcheckoutall feature/PES
#
# @arg $1 string Nombre de la rama.
#
gitcheckoutall () {
    if [ -z "$1" ]
    then
        printerror "No branch supplied"
    else
        branch=$1

        private_gitlooppaths "private_gitcheckout" $branch 

        printtext "Your environment is on branch $_COLORGREEN_$branch$_COLORDEFAULT_"
    fi
}

## 
# @description Devuelve la version del CHANGELOG para el repositorio actual
#
# @example
#   gitversion
#   1.2.6
#
# @noargs
#
gitversion () {
    local version=("$(grep -r -i -o -m 1 "^## \[[0-9]*\.[0-9]*\.[0-9]*\]" CHANGELOG.md)")
    local version=("$(echo "$version" | grep -o -m 1 "[0-9]*\.[0-9]*\.[0-9]*")")
    echo $version
}

## 
# @description Devuelve la rama del repositorio actual
#
# @example
#   gitbranch
#   feature/PES
#
# @noargs
#
gitbranch () {
    local branch=($(git branch | grep \* | cut -d ' ' -f2))
    echo $branch
}

private_gitresume () {
    local branch=$(gitbranch)
    local version=$(gitversion)

    echo "$_FONTBOLD_$1 ($version)$_FONTDEFAULT_ on branch $_COLORGREEN_$branch$_COLORDEFAULT_"
}

private_gitbranch () {
    local resume=$(private_gitresume $1)
    printtext "Path $resume"
}

## 
# @description Devuelve la rama de todos los repositorios
#
# @example
#   gitbranchall
#
# @noargs
#
gitbranchall () {
    private_gitlooppaths "private_gitbranch"
}

## Hace pull en todos los repositorios GIT
private_gitpull () {
    local resume="$(private_gitresume $1)"
    printtitle "$resume"

    git pull

    printseparator
    printlinebreak
}

## 
# @description Realiza un pull en todos los repositorios
#
# @example
#   gitpullall
#
# @noargs
#
gitpullall () {
    private_gitlooppaths "private_gitpull"

    printsuccess "Your environment is updated"
}


## Devuelve el status en todos los repositorios GIT
private_gitstatus () {
    local resume="$(private_gitresume $1)"
    printtitle "$resume"

    git status

    printseparator
    printlinebreak
}

## 
# @description Muestra el estado de todos los repositorios
#
# @example
#   gitstatusall
#
# @noargs
#
gitstatusall () {
    private_gitlooppaths "private_gitstatus"
}

## Devuelve el log de todos los repositorios GIT
private_gitlog () {
    local resume="$(private_gitresume $1)"
    printtitle "$resume"

    git log --pretty=format:"%Cgreen%an%Creset %C(bold)(%ar):%Creset %s" -n $2

    printseparator
    printlinebreak
}

## 
# @description Muestra el log de todos los repositorios
#
# @example
#   gitlogall 15
#
# @arg $1 int Numero de lineas del log a mostrar.
#
gitlogall () {
    local lines=10
    if [ -z "$1" ]
    then
        printwarning "No lines supplied, showing 10"
    else
        lines=$1
    fi

    private_gitlooppaths "private_gitlog" $lines 
}

## Hace un fetch en todos los repositorios GIT
private_gitfetch () {
    local resume="$(private_gitresume $1)"
    printtitle "$resume"

    git fetch
    printsuccess "$1 is up to date"

    printseparator
    printlinebreak
}

## 
# @description Realiza un fetch en todos los repositorios
#
# @example
#   gitfetchall
#
# @noargs
#
gitfetchall () {
    private_gitlooppaths "private_gitfetch"

    printsuccess "Your environment is up to date"
}