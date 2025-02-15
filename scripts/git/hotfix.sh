#!/bin/bash
#
# @file Git/Hotfix (git/hotfix.sh)
# @brief Contiene funciones para realizar la parte GIT de los hotfix

##
# @description Envia un aviso de comienzo de hotfix al chat en los repositorios seleccionados
#
# @example
#   githotfixstartalert
#
# @noargs
#
githotfixstartalert () {
    printtitle "Hotfix start alert"

    local selectedRepositories=()
    private_gitpickpaths selectedRepositories

    private_gitlooppaths "private_githotfixstartalert" "" "$(echo ${selectedRepositories[@]})"
}

##
# @internal
#
# @description Envia un aviso de comienzo de hotfix al chat en un repositorio pasado como parametro
#
# @arg $1 string Ruta al repositorio.
#
private_githotfixstartalert () {
    local path=$1
    local newVersion=$(githotfixnextversion)
    local webhook="$GOOGLECHATWEBHOOKAP2"
    local path=$(basename "`pwd`")
    if [[ " ${COMMONPROJECTS[@]} " =~ " ${path} " ]]; then
        webhook="$GOOGLECHATWEBHOOKCOMMON"
    fi
    printtext "Sending message for $_COLORYELLOW_$path$_COLORDEFAULT_ to Google Chat webhook"
    googlechatwebhookmessage $webhook "Preparando hotfix *$newVersion* de *$path*"
    sleep 1
    printsuccess "Message sent successfully"
}

##
# @internal
#
# @description Devuelve la version para el próximo hotfix en el path actual
#
# @example
#   githotfixnextversion
#
# @noargs
#
githotfixnextversion () {
    local version=$(gitversion) 
    local versionParts=(${version//./ })
    local lastPart=${versionParts[-1]}
    lastPart=$((lastPart + 1))
    unset 'versionParts[${#versionParts[@]}-1]'
    versionParts=( "${versionParts[@]}" $lastPart )
    local newVersion=$(joinby . "${versionParts[@]}")
    echo $newVersion
}

##
# @description Crea un nuevo hotfix a partir de la rama principal
#
# @example
#   #Iniciar hotfix
#   githotfixstartalert
#   githotfixstart
#   
#   #Realizar cambios para el hotfix y actualizar Changelog arriba y abajo
#   git add .
#   git commit -m "Hotfix x.x.x"
#   
#   #Terminar hotfix 
#   githotfixfinish
#   
#   #Desplegar el hotfix
#   ...
#   
#   #Notificar despligue
#   githotfixfinishalert
#
# @noargs
#
githotfixstart () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        local fromBranch=$GITMAINBRANCH
        
        # Comprobamos que la rama origen existe
        local branches=($(git branch | grep "[^* ]+" -Eo))
        if [[ " ${branches[@]} " =~ " ${fromBranch} " ]]; then
            # Vamos a la raiz del repo
            local pwd=$(pwd)
            local gitroot=$(git rev-parse --show-toplevel)
            cd $gitroot

            # Calculamos el nombre para el hotfix a partir del changelog
            local version=$(gitversion)
            local newVersion=$(githotfixnextversion)
            local newBranch="hotfix/$newVersion"

            if ! [[ " ${branches[@]} " =~ " ${newBranch} " ]]; then
                ( # try
                    set -e # Exit if error in any command

                    printtitle "New hotfix from branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_ ($version => $_COLORYELLOW_$newVersion$_COLORDEFAULT_)"
                    
                    printlinebreak
                    printwarning "Remember to pick up TRUNK"
                    printwarning "Remember to update the CHANGELOG (up & down) before finish the hotfix"
                    printlinebreak

                    # Creamos la nueva rama
                    ( set -x; git stash push -m "hotfixstart-$newVersion"; )
                    ( set -x; git checkout $fromBranch; )
                    ( set -x; git pull; )
                    ( set -x; git checkout -b $newBranch; )

                    if git stash list | grep -q "hotfixstart-$newVersion"; then
                        ( set -x; git stash apply stash^{/hotfixstart-$newVersion}; )                                                 
                    else
                        printwarning "No stash for apply"
                    fi

                    printlinebreak
                    printsuccess "Branch $newBranch created successfully"
                    printlinebreak

                    printlinebreak
                    printsuccess "Hotfix $newVersion started successfully"
                    printlinebreak
                    printtext "Use$_FONTBOLD_ githotfixcancel$_FONTDEFAULT_ to cancel the hotfix"
                    printtext "Use$_FONTBOLD_ githotfixfinish$_FONTDEFAULT_ to finalize the hotfix"
                )
                errorCode=$?
                if [ $errorCode -ne 0 ]; then
                    printerror "An error occurred while hotfix $newVersion starts"
                    printseparator
                    printlinebreak
                    return $errorCode
                fi
            else
                printerror "Branch '$newBranch' already exists, do you have hotfix in progress?"
                return 1
            fi

            cd $pwd
        else
            printerror "Origin branch '$fromBranch' no exists"
            return 1
        fi
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}

##
# @description Finaliza el hotfix, creando una tag y eliminando la rama del hotfix
#
# @example
#   githotfixfinish
#
# @noargs
#
githotfixfinish () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        local fromBranch=$GITMAINBRANCH

        # Comprobamos que la rama para mezclar existe
        local branches=($(git branch | grep "[^* ]+" -Eo))
        if [[ " ${branches[@]} " =~ " ${fromBranch} " ]]; then
            # Vamos a la raiz del repo
            local pwd=$(pwd)
            local gitroot=$(git rev-parse --show-toplevel)
            cd $gitroot

            # Calculamos el nombre del hotfix a partir del changelog
            local version=$(gitversion) 
            local newBranch="hotfix/$version"

            if [[ " ${branches[@]} " =~ " ${newBranch} " ]]; then
                ( # try
                    set -e # Exit if error in any command

                    printtitle "Finishing hotfix $_FONTBOLD_$version$_FONTDEFAULT_"

                    ( set -x; git fetch; )
                    ( set -x; git checkout dev; )
                    ( set -x; git pull; )
                    ( set -x; git merge --no-ff $newBranch; )

                    printlinebreak
                    printsuccess "Branch $newBranch merged on branch dev successfully"
                    printlinebreak
                    
                    ( set -x; git checkout $fromBranch; )
                    ( set -x; git pull; )
                    ( set -x; git merge --no-ff $newBranch; )

                    printlinebreak
                    printsuccess "Branch $newBranch merged on branch $fromBranch successfully"
                    printlinebreak

                    # Creamos la nueva tag y borramos la rama
                    ( set -x; git tag $version; )
                    printlinebreak
                    printsuccess "Tag $version created from branch $fromBranch successfully"
                    ( set -x; git branch -d $newBranch; )
                    printlinebreak
                    printsuccess "Branch $newBranch removed successfully"
                    printlinebreak
                    printtext "Hotfix $_FONTBOLD_$version$_FONTDEFAULT_ finished succesfully"
                )
                errorCode=$?
                if [ $errorCode -ne 0 ]; then
                    printerror "An error occurred while finishing hotfix $version"
                    printseparator
                    printlinebreak
                    return $errorCode
                fi
            else
                printerror "Branch '$newBranch' not exists, do you modify CHANGELOG.md file?"
                return 1
            fi

            cd $pwd
        else
            printerror "Merge branch '$fromBranch' no exists"
            return 1
        fi
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}

##
# @description Cancela el hotfix y vuelve a la rama principal
#
# @example
#   githotfixcancel
#
# @noargs
#
githotfixcancel () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        local fromBranch=$GITMAINBRANCH

        # Comprobamos que la rama para mezclar existe
        local branches=($(git branch | grep "[^* ]+" -Eo))
        if [[ " ${branches[@]} " =~ " ${fromBranch} " ]]; then
            # Vamos a la raiz del repo
            local pwd=$(pwd)
            local gitroot=$(git rev-parse --show-toplevel)
            cd $gitroot

            # Calculamos el nombre del hotfix a partir del changelog
            local version=$(gitversion)
            local newVersion=$(githotfixnextversion)
            local newBranch="hotfix/$newVersion"

            if [[ " ${branches[@]} " =~ " ${newBranch} " ]]; then
                ( # try
                    set -e # Exit if error in any command

                    printtitle "Canceling hotfix $_FONTBOLD_$newVersion$_FONTDEFAULT_"

                    ( set -x; git checkout $fromBranch; )
                    ( set -x; git branch -d $newBranch; )

                    printlinebreak
                    printsuccess "Branch $newBranch removed successfully"
                    printlinebreak
                    
                    printtext "Hotfix $_FONTBOLD_$newVersion$_FONTDEFAULT_ canceled succesfully"
                )
                errorCode=$?
                if [ $errorCode -ne 0 ]; then
                    printerror "An error occurred while canceling hotfix $newVersion"
                    printseparator
                    printlinebreak
                    return $errorCode
                fi
            else
                printerror "Branch '$newBranch' not exists, do you modify CHANGELOG.md file?"
                return 1
            fi

            cd $pwd
        else
            printerror "Merge branch '$fromBranch' no exists"
            return 1
        fi
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}

##
# @description Envia un aviso de final de hotfix al chat en los repositorios seleccionados
#
# @example
#   githotfixfinishalert
#
# @noargs
#
githotfixfinishalert () {
    printtitle "Hotfix finish alert"

    local selectedRepositories=()
    private_gitpickpaths selectedRepositories

    private_gitlooppaths "private_githotfixfinishalert" "" "$(echo ${selectedRepositories[@]})"
}

##
# @internal
#
# @description Envia un aviso de final de hotfix al chat en un repositorio pasado como parametro
#
# @arg $1 string Ruta al repositorio.
#
private_githotfixfinishalert () {
    local path=$1
    local newVersion=$(gitversion)
    local webhook="$GOOGLECHATWEBHOOKAP2"
    local path=$(basename "`pwd`")
    if [[ " ${COMMONPROJECTS[@]} " =~ " ${path} " ]]; then
        webhook="$GOOGLECHATWEBHOOKCOMMON"
    fi
    printtext "Sending message for $_COLORYELLOW_$path$_COLORDEFAULT_ to Google Chat webhook"
    googlechatwebhookmessage $webhook "Desplegado hotfix *$newVersion* de *$path*"
    sleep 1
    printsuccess "Message sent successfully"
}