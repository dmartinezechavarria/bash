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

##
# @internal
#
# @description Devuelve los repositorios Git disponibles
#
# @noargs
#
private_gitpaths () {
    if [ -z ${GITIGNOREFOLDERS+x} ]; then 
        GITIGNOREFOLDERS=()
    fi
    local pwd=$(pwd)
    cd $GITROOT
    echo $(ls -d */ | while read path ; do if ! [[ " ${GITIGNOREFOLDERS[@]} " =~ " ${path//[\/]} " ]]; then  echo ${path//[\/]} ; fi done;)
    cd $pwd
}

##
# @internal
#
# @description Recorre los paths con repositorios GIT y ejecuta el primer parametro pasandole como primer parametro el path 
# y como segundo parametro opcional el segundo parametro recibido
#
# @arg $1 string Comando a ejecutar.
# @arg $2 string Parámetro opcional a pasar a la llamada.
# @arg $3 array Opcional, lista de repositorios a los que aplicar la llamada.
#
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

##
# @internal
#
# @description Recibe una rama local como parametro y hace checkout de un repositorio a esa rama
#
# @arg $1 string Repositorio.
# @arg $2 string Rama local a la que hacer checkout.
#
private_gitcheckout () {
    local repository=$1
    local branch=$2
    local branches=($(git branch | grep "[^* ]+" -Eo))
    local currentBranch=$(gitbranch)

    ( # try
        set -e # Exit if error in any command

        local resume="$(private_gitresume $repository)"
        printtitle "Merging $_COLORYELLOW_$branch$_COLORDEFAULT_ into $resume"

        if [[ " ${branches[@]} " =~ " ${branch} " ]]; then
            ( set -x; git checkout $branch; )
            printtext "Path $_FONTBOLD_$repository$_FONTDEFAULT_ on branch $_COLORGREEN_$branch$_COLORDEFAULT_ now"
        else
            printtext "Branch $_COLORGREEN_$branch$_COLORDEFAULT_ not found in $_FONTBOLD_$repository$_FONTDEFAULT_"
            printlinebreak
            printtext "Available branchs for $_FONTBOLD_$repository$_FONTDEFAULT_:"
            printarray ${branches[@]}
            exit 1
        fi

        printseparator
        printlinebreak
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while checkout branch $branch in $repository"
        printseparator
        printlinebreak
        return $errorCode
    fi
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
        fi
    fi
}

##
# @internal
#
# @description Realiza un merge --no-ff de la rama pasada como parametro sobre la rama actual
#
# @arg $1 string Repositorio.
# @arg $2 string Rama local a mezclar.
#
private_gitmerge () {
    local repository=$1
    local branch=$2
    local branches=($(git branch | grep "[^* ]+" -Eo))
    local currentBranch=$(gitbranch)

    ( # try
        set -e # Exit if error in any command

        local resume="$(private_gitresume $repository)"
        printtitle "Merging $_COLORYELLOW_$branch$_COLORDEFAULT_ into $resume"

        if [[ " ${branches[@]} " =~ " ${branch} " ]]; then
            ( set -x; git merge --no-ff $branch; )
            printtext "Branch $_COLORGREEN_$branch$_COLORDEFAULT_ merged in $_FONTBOLD_$repository$_FONTDEFAULT_"
        else
            printtext "Branch $_COLORGREEN_$branch$_COLORDEFAULT_ not found in $_FONTBOLD_$repository$_FONTDEFAULT_"
            printlinebreak
            printtext "Available branchs for $_FONTBOLD_$repository$_FONTDEFAULT_:"
            printarray ${branches[@]}
            exit 1
        fi

        printseparator
        printlinebreak
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while merge in $repository"
        printseparator
        printlinebreak
        return $errorCode
    fi
}

## 
# @description Realiza un merge --no-ff de la rama pasada como parametro sobre la rama actual sobre los repositorios seleccionados
#
# @example
#   gitmerge dev all
#
# @arg $1 string Nombre de la rama local a mezclar.
# @arg $2 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
gitmerge () {
    if [ -z "$1" ] 
    then
        printerror "No destiny local branch supplied"
        return 1
    else
        local branch=$1

        printtitle "Git merge branch $_COLORGREEN_$branch$_COLORDEFAULT_"

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
            private_gitlooppaths "private_gitmerge" $branch $mergeBranch "$(echo ${selectedRepositories[@]})"
            printtext "All merges completed"
        fi
    fi
}

##
# @internal
#
# @description Recibe una rama remota como parametro y hace checkout de un repositorio a esa rama
#
# @arg $1 string Repositorio.
# @arg $2 string Rama remota a la que hacer checkout.
#
private_gitcheckoutremote () {
    local repository=$1
    local branch=$2
    local remotebranch="origin/$branch"
    local branches=($(git branch -a | grep "[^* ]+" -Eo))
    local currentBranch=$(gitbranch)

    ( # try
        set -e # Exit if error in any command

        local resume="$(private_gitresume $repository)"
        printtitle "$resume => $_COLORYELLOW_$branch$_COLORDEFAULT_"

        if [[ " ${branches[@]} " =~ " remotes/${remotebranch} " ]]; then
            ( set -x; git checkout --track $remotebranch; )
            
            if [ $? -eq 0 ]; then
                printtext "Path $_FONTBOLD_$repository$_FONTDEFAULT_ on branch $_COLORGREEN_$branch$_COLORDEFAULT_ now"
            else
                ( set -x; git checkout $branch; )
                printtext "Branch $_COLORGREEN_$branch$_COLORDEFAULT_ already exists checkout $_FONTBOLD_$repository$_FONTDEFAULT_ to it"
            fi  
        else
            printtext "Branch $_COLORGREEN_$branch$_COLORDEFAULT_ not found in $_FONTBOLD_$repository$_FONTDEFAULT_"
            printlinebreak
            printtext "Available branchs for $_FONTBOLD_$repository$_FONTDEFAULT_:"
            printarray ${branches[@]}
            exit 1
        fi

        printseparator
        printlinebreak
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while checkout branch $branch in $repository"
        printseparator
        printlinebreak
        return $errorCode
    fi
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

##
# @internal
#
# @description Muestra el branch y la version del repositorio
#
# @arg $1 string Repositorio.
#
private_gitresume () {
    local branch=$(gitbranch 2> /dev/null) 
    local version=$(gitversion 2> /dev/null)

    echo "$_FONTBOLD_$1 ($version)$_FONTDEFAULT_ on branch $_COLORGREEN_$branch$_COLORDEFAULT_"
}

##
# @internal
#
# @description Muestra el branch y la version del repositorio
#
# @arg $1 string Repositorio.
#
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

##
# @internal
#
# @description Hace pull en un repositorio
#
# @arg $1 string Repositorio.
#
private_gitpull () {
    local repository=$1

    ( # try
        set -e # Exit if error in any command

        local resume="$(private_gitresume $repository)"
        printtitle "$resume"

        ( set -x; git pull; )

        printseparator
        printlinebreak
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while pull $repository"
        printseparator
        printlinebreak
        return $errorCode
    fi
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
    fi
}

##
# @internal
#
# @description Devuelve el estado de un repositorio
#
# @arg $1 string Repositorio.
#
private_gitstatus () {
    local repository=$1

    ( # try
        set -e # Exit if error in any command

        local resume="$(private_gitresume $repository)"
        printtitle "$resume"

        git status

        printseparator
        printlinebreak
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while show status for $repository"
        printseparator
        printlinebreak
        return $errorCode
    fi
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

##
# @internal
#
# @description Devuelve el log de un repositorio
#
# @arg $1 string Repositorio.
# @arg $2 int Numero de lineas del log a mostrar.
#
private_gitlog () {
    local repository=$1
    local lines=$2

    ( # try
        set -e # Exit if error in any command

        local resume="$(private_gitresume $repository)"
        printtitle "$resume"

        git log --pretty=format:"%Cgreen%an%Creset %C(bold)(%ar):%Creset %s" -n $lines

        printseparator
        printlinebreak
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while show log for $repository"
        printseparator
        printlinebreak
        return $errorCode
    fi
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

##
# @internal
#
# @description Hace fetch en un repositorio
#
# @arg $1 string Repositorio.
#
private_gitfetch () {
    local repository=$1

    ( # try
        set -e # Exit if error in any command

        local resume="$(private_gitresume $repository)"
        printtitle "$resume"

        ( set -x; git fetch; )
        printsuccess "$repository is up to date"

        printseparator
        printlinebreak
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while fetch $repository"
        printseparator
        printlinebreak
        return $errorCode
    fi
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
    ( # try
        set -e # Exit if error in any command

        printtitle "Last commit date\t\tAuthor\t\t\tBranch"
        
        printtext "Local branches"

        git for-each-ref --sort='-committerdate:iso8601' --format='   %(committerdate:iso8601)%09%(committeremail)%09%(refname:short)' refs/heads

        printlinebreak

        printtext "Remote branches"

        git for-each-ref --sort='-committerdate:iso8601' --format='   %(committerdate:iso8601)%09%(committeremail)%09%(refname:short)' refs/remotes 
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while getting branches"
        return $errorCode
    fi
}

##
# @internal
#
# @description Muestra un select para elegir paths de GIT
#
# @noargs
#
private_gitpickpaths () {
    local retval=$1
    local paths=( $(private_gitpaths) )

    printtext "Pick repositories with spacebar and confirm with enter"
    printlinebreak

    promptformultiselect results "$(echo ${paths[@]})" #"api_proc panel" 

    eval $retval='("${results[@]}")'
}

##
# @internal
#
# @description Recibe una rama como parametro y la elimina (local y remota)
#
# @arg $1 string Repositorio.
# @arg $2 string Rama local a eliminar.
#
private_gitbranchremove () {
    local branch=$2

    ( # try
        set -e # Exit if error in any command

        printtext "Removing $_COLORYELLOW_$branch$_COLORDEFAULT_ on $_FONTBOLD_$1$_FONTDEFAULT_"

        ( set -x; git branch -D $branch; git push origin --delete $branch; )

        printsuccess "Removed $branch on $1"
        printlinebreak
    )
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        printerror "An error occurred while remove branch $branch"
        printlinebreak
        return $errorCode
    fi
}

## 
# @description Elimina una rama (local y remota) en los repositorios seleccionados
#
# @example
#   gitbranchremove feature/PES all
#
# @arg $1 string Nombre de la rama.
# @arg $2 string Opcional, si se pasa el valor all se aplica a todos los repositorios, si no se permite elegir.
#
gitbranchremove () {
    if [ -z "$1" ] 
    then
        printerror "No branch supplied"
        return 1
    else
        local branch=$1

        printtitle "Git remove branch $_COLORGREEN_$branch$_COLORDEFAULT_"
        printlinebreak
        printwarning "WARNING: This process cannot be undone."
        printlinebreak

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
            private_gitlooppaths "private_gitbranchremove" $branch "$(echo ${selectedRepositories[@]})"
        fi
    fi
}