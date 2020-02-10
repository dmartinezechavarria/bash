#!/bin/bash
#
# @file Git/Hotfix (git/hotfix.sh)
# @brief Contiene funciones para realizar la parte GIT de los hotfix

##
# @description Envia un aviso de comienzo de hotfix a Rocket.Chat en los repositorios seleccionados
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
# @description Envia un aviso de comienzo de hotfix a Rocket.Chat en un repositorio pasado como parametro
#
# @arg $1 string Ruta al repositorio.
#
private_githotfixstartalert () {
    local path=$1
    local newVersion=$(githotfixnextversion)
    local channel=$ROCKETCHATCHANNELAP2
    local path=$(basename "`pwd`")
    if [[ " ${COMMONPROJECTS[@]} " =~ " ${path} " ]]; then
        channel=$ROCKETCHATCHANNELCOMMON
    fi
    printtext "Sending message for $_COLORYELLOW_$path$_COLORDEFAULT_ to Rocket.Chat channel $_FONTBOLD_$channel$_FONTDEFAULT_"
    rocketchatsendmessage $channel "Preparando hotfix *$newVersion* de *$path*"
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
# @description Crea un nuevo hotfix a partir de una rama y envia un aviso a Rocket.Chat
#
# @example
#   #Iniciar hotfix
#   githotfixstartalert
#   githotfixstart
#   
#   #Realizar cambios para el hotfix y actualizar Changelog arriba y abajo
#   git add .
#   git commit -m "Release changelog"
#   
#   #Terminar hotfix 
#   gitreleasefinish
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
        local fromBranch="master"
        
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
                printtitle "New hotfix from branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_ ($version => $_COLORYELLOW_$newVersion$_COLORDEFAULT_)"
                
                printlinebreak
                printwarning "Remember to pick up TRUNK"
                printwarning "Remember to update the CHANGELOG (up & down) before finish the hotfix"
                printlinebreak

                # Creamos la nueva rama
                git checkout $fromBranch
                git pull
                git checkout -b $newBranch

                printlinebreak
                printsuccess "Branch $newBranch created successfully"
                printlinebreak

                printlinebreak
                printsuccess "Hotfix $newVersion started successfully"
                printlinebreak
                printtext "Use$_FONTBOLD_ githotfixfinish$_FONTDEFAULT_ to finalize the hotfix"
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
        local fromBranch="master"

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
                printtitle "Finishing hotfix $_FONTBOLD_$version$_FONTDEFAULT_"

                git fetch
                git checkout dev
                git pull
                git merge --no-ff $newBranch

                printlinebreak
                printsuccess "Branch $newBranch merged on branch dev successfully"
                printlinebreak
                
                git checkout $fromBranch
                git pull
                git merge --no-ff $newBranch

                printlinebreak
                printsuccess "Branch $newBranch merged on branch $fromBranch successfully"
                printlinebreak

                # Creamos la nueva tag y borramos la rama
                git tag $version
                printlinebreak
                printsuccess "Tag $version created from branch $fromBranch successfully"
                git branch -d $newBranch
                printlinebreak
                printsuccess "Branch $newBranch removed successfully"
                printlinebreak
                printtext "Hotfix$_FONTBOLD_ $version $_FONTDEFAULT_ finished succesfully"
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
# @description Envia un aviso de final de hotfix a Rocket.Chat en los repositorios seleccionados
#
# @example
#   githotfixfinishalert
#
# @noargs
#
githotfixfinishalert () {
    printtitle "Release finish alert"

    local selectedRepositories=()
    private_gitpickpaths selectedRepositories

    private_gitlooppaths "private_gitreleasefinishalert" "" "$(echo ${selectedRepositories[@]})"
}

##
# @internal
#
# @description Envia un aviso de final de hotfix a Rocket.Chat en un repositorio pasado como parametro
#
# @arg $1 string Ruta al repositorio.
#
private_githotfixfinishalert () {
    local path=$1
    local newVersion=$(gitversion)
    local channel=$ROCKETCHATCHANNELAP2
    local path=$(basename "`pwd`")
    if [[ " ${COMMONPROJECTS[@]} " =~ " ${path} " ]]; then
        channel=$ROCKETCHATCHANNELCOMMON
    fi
    printtext "Sending message for $_COLORYELLOW_$path$_COLORDEFAULT_ to Rocket.Chat channel $_FONTBOLD_$channel$_FONTDEFAULT_"
    rocketchatsendmessage $channel "Desplegado hotfix *$newVersion* de *$path*"
    printsuccess "Message sent successfully"
}