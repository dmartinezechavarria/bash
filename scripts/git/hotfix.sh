#!/bin/bash
#
# @file Git/Hotfix (git/hotfix.sh)
# @brief Contiene funciones para realizar la parte GIT de los hotfix

##
# @description Crea un nuevo hotfix a partir de una rama y envia un aviso a Rocket.Chat
#
# @example
#   githotfixstart
#
# @arg $1 string Rama de origen para el hotfix, si no se pasa usa master.
#
githotfixstart () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        # Comprobamos si se pasa una rama de origen, si no se usa master
        if [ -z "$1" ]
        then
            fromBranch="master"
        else
            fromBranch=$1
        fi
        
        # Comprobamos que la rama origen existe
        local branches=($(git branch | grep "[^* ]+" -Eo))
        if [[ " ${branches[@]} " =~ " ${fromBranch} " ]]; then
            # Vamos a la raiz del repo
            local pwd=$(pwd)
            local gitroot=$(git rev-parse --show-toplevel)
            cd $gitroot

            # Calculamos el nombre para el hotfix a partir del changelog
            local version=$(gitversion) 
            local versionParts=(${version//./ })
            local lastPart=${versionParts[-1]}
            lastPart=$((lastPart + 1))
            unset 'versionParts[${#versionParts[@]}-1]'
            versionParts=( "${versionParts[@]}" $lastPart )
            local newVersion=$(joinby . "${versionParts[@]}")
            local newBranch="hotfix/$newVersion"

            if ! [[ " ${branches[@]} " =~ " ${newBranch} " ]]; then
                printtitle "New hotfix from branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_ ($version => $_COLORYELLOW_$newVersion$_COLORDEFAULT_)"
                
                printlinebreak
                printwarning "Remember to pick up TRUNK"
                printwarning "Remember to update the CHANGELOG before finishing the hotfix"
                printlinebreak

                # Creamos la nueva rama
                git checkout $fromBranch
                git pull
                git checkout -b $newBranch

                printlinebreak
                printsuccess "Branch $newBranch created successfully"
                printlinebreak

                # Enviamos el mensaje al Rocketchat
                local channel=$ROCKETCHATCHANNELAP2
                local path=$(basename "`pwd`")
                if [[ " ${COMMONPROJECTS[@]} " =~ " ${path} " ]]; then
                    channel=$ROCKETCHATCHANNELCOMMON
                fi
                printtext "Sending message to Rocketchat channel $_FONTBOLD_$channel$_FONTDEFAULT_"
                rocketchatsendmessage $channel "Preparando hotfix *$newVersion* de *$path*"
                printsuccess "Message sent successfully"

                printlinebreak
                printsuccess "Hotfix $newVersion started successfully"
                printlinebreak
                printtext "Use$_FONTBOLD_ githotfixmerge master$_FONTDEFAULT_ to update master branch with hotfix changes"
                printtext "Use$_FONTBOLD_ githotfixmerge dev$_FONTDEFAULT_ to update dev branch with hotfix changes"
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
# @description Mezcla los cambios del hotfix sobre la rama pasada como parametro
#
# @example
#   githotfixmerge dev
#
# @arg $1 string Rama sobre la que mezclar el hotfix.
#
githotfixmerge () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        # Comprobamos si se pasa una rama para mezclar origen
        if [ -z "$1" ]
        then
            printerror "No merge branch provided"
            return 1
        else
            fromBranch=$1

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
                    printtitle "Merge hotfix $_FONTBOLD_$version$_FONTDEFAULT_ on branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_"
                    
                    # Mezclamos sobre la rama
                    git checkout $fromBranch
                    git pull
                    git merge --no-ff $newBranch

                    printlinebreak
                    printsuccess "Branch $newBranch merged on branch $fromBranch successfully"
                    printlinebreak
                    printtext "Use$_FONTBOLD_ githotfixfinish $_FONTDEFAULT_ to finalize the hotfix"
                    
                    printwarning "Remember to merge hotfix changes on master and dev branchs before finalize it."
                else
                    printerror "Branch '$newBranch' not exists, do you modify CHANGELOG.md file?"
                    return 1
                fi

                cd $pwd
            else
                printerror "Merge branch '$fromBranch' no exists"
                return 1
            fi
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
# @arg $1 string Rama sobre la que finalizar el hotfix, si no se pasa usa master.
#
githotfixfinish () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        # Comprobamos si se pasa una rama para mezclar origen, si no se usa master
        if [ -z "$1" ]
        then
            fromBranch="master"
        else
            fromBranch=$1
        fi

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
                
                # Creamos la nueva tag y borramos la rama
                git checkout $fromBranch
                git pull
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
# @description Realiza acciones tras el despliegue de un hotfix (por ejemplo avisar en Rocket.Chat)
#
# @example
#   githotfixdeployed
#
# @noargs
#
githotfixdeployed () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        # Vamos a la raiz del repo
        local pwd=$(pwd)
        local gitroot=$(git rev-parse --show-toplevel)
        cd $gitroot

        # Obtenemos la versión a partir del changelog
        local version=$(gitversion) 
        
        printtitle "Deployed hotfix $_FONTBOLD_$version$_FONTDEFAULT_"

        # Enviamos el mensaje al Rocketchat
        local channel=$ROCKETCHATCHANNELAP2
        local path=$(basename "`pwd`")
        if [[ " ${COMMONPROJECTS[@]} " =~ " ${path} " ]]; then
            channel=$ROCKETCHATCHANNELCOMMON
        fi
        printtext "Sending message to Rocketchat channel $_FONTBOLD_$channel$_FONTDEFAULT_"
        rocketchatsendmessage $channel "Desplegado hotfix *$version* de *$path*"
        printsuccess "Message sent successfully"
        
        printlinebreak
        printtext "Post deployed $_FONTBOLD_$version$_FONTDEFAULT_ finished succesfully"
        
        cd $pwd
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}