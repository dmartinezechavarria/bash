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
        local path="${1//[\/]}"
        local paths=( $(private_gitpaths) )
        
        if (( ${#paths[@]} == 0 )); then
            printerror "No valid paths found"
            return 1
        else
            if [[ " ${paths[@]} " =~ " ${path} " ]]; then
                printtext "Go into $_FONTBOLD_${path}$_FONTDEFAULT_"
                cd $GITROOT$path
            else
                printtext "Path $_FONTBOLD_${path}$_FONTDEFAULT_ not found"
                printlinebreak
                printtext "Available paths:"
                printarray ${paths[@]}
                printlinebreak
            fi
        fi
    fi
}

# Devuelve los repositorios Git disponibles
private_gitpaths () {
    local pwd=$(pwd)
    local excludePaths=("prueba")
    cd $GITROOT
    echo $(ls -d */ | while read path ; do if ! [[ " ${excludePaths[@]} " =~ " ${path//[\/]} " ]]; then  echo ${path//[\/]} ; fi done;)
    cd $pwd
}

## Recorre los paths con repositorios GIT y ejecuta el primer parametro pasandole como primer parametro el path 
## y como segundo parametro opcional el segundo parametro recibido
private_gitlooppaths () {
    local secondArgument=""
    if [ $# -ge 2 ]
    then
        secondArgument=$2
    fi

    local pwd=$(pwd)
    cd $GITROOT

    local paths=()
    if [[ -z $3 ]]; then
        paths=( $(private_gitpaths) )
    else
        paths=( $(echo "$3") )
    fi

    for path in ${paths[@]} ;
    do
        local fullPath="$GITROOT$path"
        if [ -d "${fullPath}" ] ; then
            cd $fullPath
            eval "$1 ${path} $secondArgument"
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
# @description Realiza un checkout a una rama local sobre los repositorios seleccionados
#
# @example
#   gitcheckout feature/PES all
#
# @arg $1 string Nombre de la rama local.
# @arg $2 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
gitcheckout () {
    if [ -z "$1" ] 
    then
        printerror "No local branch supplied"
        return 1
    else
        local branch=$1

        printtitle "Git checkout to local branch $_COLORGREEN_$branch$_COLORDEFAULT_"

        local selectedRepositories=()
        if [ -z "$2" ] 
        then
            private_gitpickpaths selectedRepositories
        else
            if [ $2 = "all" ]; 
            then
                selectedRepositories=( $(private_gitpaths) )
            fi
        fi

        printlinebreak

        if [ ${#selectedRepositories[@]} -eq 0 ]; then
            printerror "No repositories picked"
        else
            private_gitlooppaths "private_gitcheckout" $branch "$(echo ${selectedRepositories[@]})"
            printtext "Repositories on branch $_COLORGREEN_$branch$_COLORDEFAULT_"
        fi
    fi
}

## Recibe una rama remota como parametro y hace checkout en todos los repositorios GIT a esa rama remota
private_gitcheckoutremote () {
    local branch=$2
    local remotebranch="origin/$branch"
    local branches=($(git branch -a | grep "[^* ]+" -Eo))
    local currentBranch=$(gitbranch)

    local resume="$(private_gitresume $1)"
    printtitle "$resume => $_COLORYELLOW_$branch$_COLORDEFAULT_"

    if [[ " ${branches[@]} " =~ " remotes/${remotebranch} " ]]; then
        git checkout --track $remotebranch
        if [ $? -eq 0 ]; then
            printtext "Path $_FONTBOLD_$1$_FONTDEFAULT_ on branch $_COLORGREEN_$branch$_COLORDEFAULT_ now"
        else
            git checkout $branch
            printtext "Branch $_COLORGREEN_$branch$_COLORDEFAULT_ already exists checkout $_FONTBOLD_$1$_FONTDEFAULT_ to it"
        fi  
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
# @description Realiza un checkout a una rama remota sobre los repositorios seleccionados
#
# @example
#   gitcheckoutremote feature/PES all
#
# @arg $1 string Nombre de la rama local.
# @arg $2 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
gitcheckoutremote () {
    if [ -z "$1" ] 
    then
        printerror "No remote branch supplied"
        return 1
    else
        local branch=$1

        printtitle "Git checkout to remote branch $_COLORGREEN_$branch$_COLORDEFAULT_"

        local selectedRepositories=()
        if [ -z "$2" ] 
        then
            private_gitpickpaths selectedRepositories
        else
            if [ $2 = "all" ]; 
            then
                selectedRepositories=( $(private_gitpaths) )
            fi
        fi

        printlinebreak

        if [ ${#selectedRepositories[@]} -eq 0 ]; then
            printerror "No repositories picked"
        else
            private_gitlooppaths "private_gitcheckoutremote" $branch "$(echo ${selectedRepositories[@]})"
            printtext "Repositories on branch $_COLORGREEN_$branch$_COLORDEFAULT_"
        fi
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

# Muestra el branch y la version del repositorio
private_gitresume () {
    local branch=$(gitbranch)
    local version=$(gitversion)

    echo "$_FONTBOLD_$1 ($version)$_FONTDEFAULT_ on branch $_COLORGREEN_$branch$_COLORDEFAULT_"
}

# Muestra el branch y la version del repositorio
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
# @description Realiza un pull sobre los repositorios seleccionados
#
# @example
#   gitpull all
#
# @arg $1 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
gitpull () {
    printtitle "Git pull"

    local selectedRepositories=()
    if [ -z "$1" ] 
    then
        private_gitpickpaths selectedRepositories
    else
        if [ $1 = "all" ]; 
        then
            selectedRepositories=( $(private_gitpaths) )
        fi
    fi

    printlinebreak

    if [ ${#selectedRepositories[@]} -eq 0 ]; then
        printerror "No repositories picked"
    else
        private_gitlooppaths "private_gitpull" "" "$(echo ${selectedRepositories[@]})"
        printtext "Repositories up to date"
    fi
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
# @description Muestra el estado de los repositorios seleccionados
#
# @example
#   gitstatus all
#
# @arg $1 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
gitstatus () {
    printtitle "Git status"

    local selectedRepositories=()
    if [ -z "$1" ] 
    then
        private_gitpickpaths selectedRepositories
    else
        if [ $1 = "all" ]; 
        then
            selectedRepositories=( $(private_gitpaths) )
        fi
    fi

    printlinebreak

    if [ ${#selectedRepositories[@]} -eq 0 ]; then
        printerror "No repositories picked"
    else
        private_gitlooppaths "private_gitstatus" "" "$(echo ${selectedRepositories[@]})"
    fi
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
# @description Muestra el log de los repositorios seleccionados
#
# @example
#   gitlog all 15
#
# @arg $1 int Numero de lineas del log a mostrar.
# @arg $2 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
gitlog () {
    local lines=10
    if [ -z "$1" ]
    then
        printwarning "No lines supplied, showing 10"
    else
        lines=$1
    fi

    printtitle "Git log ($lines lines)"

    local selectedRepositories=()
    if [ -z "$2" ] 
    then
        private_gitpickpaths selectedRepositories
    else
        if [ $2 = "all" ]; 
        then
            selectedRepositories=( $(private_gitpaths) )
        fi
    fi

    printlinebreak

    if [ ${#selectedRepositories[@]} -eq 0 ]; then
        printerror "No repositories picked"
    else
        private_gitlooppaths "private_gitlog" $lines "$(echo ${selectedRepositories[@]})"
    fi
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
# @description Realiza un fetch en los repositorios seleccionados
#
# @example
#   gitfetch all
#
# @arg $1 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
gitfetch () {
    printtitle "Git fetch"

    local selectedRepositories=()
    if [ -z "$1" ] 
    then
        private_gitpickpaths selectedRepositories
    else
        if [ $1 = "all" ]; 
        then
            selectedRepositories=( $(private_gitpaths) )
        fi
    fi

    printlinebreak

    if [ ${#selectedRepositories[@]} -eq 0 ]; then
        printerror "No repositories picked"
    else
        private_gitlooppaths "private_gitfetch" "" "$(echo ${selectedRepositories[@]})"
        printsuccess "Repositories are up to date"
    fi
}

## 
# @description Muestra un resumen de las ramas con la fecha y autor de su ultimo commit
#
# @example
#   gitbranchages
#
# @noargs
#
gitbranchages () {
    printtitle "Last commit date\t\tAuthor\t\t\tBranch"

    printtext "Local branches"
    git for-each-ref --sort='-committerdate:iso8601' --format='   %(committerdate:iso8601)%09%(committeremail)%09%(refname:short)' refs/heads
    
    printlinebreak
    printtext "Remote branches"
    git for-each-ref --sort='-committerdate:iso8601' --format='   %(committerdate:iso8601)%09%(committeremail)%09%(refname:short)' refs/remotes
}

# Muestra un select para elegir paths de GIT
private_gitpickpaths () {
    local retval=$1
    local paths=( $(private_gitpaths) )

    printtext "Pick repositories with spacebar and confirm with enter"
    printlinebreak

    promptformultiselect results "$(echo ${paths[@]})" #"api_proc panel" 

    eval $retval='("${results[@]}")'
}