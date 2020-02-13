#!/bin/bash
#
# @file Git/Release (git/release.sh)
# @brief Contiene funciones para realizar la parte GIT de las releases

##
# @description Envia un aviso de comienzo de release a Rocket.Chat en los repositorios seleccionados
#
# @example
#   gitreleasestartalert
#
# @noargs
#
gitreleasestartalert () {
    printtitle "Release start alert"

    local selectedRepositories=()
    private_gitpickpaths selectedRepositories

    private_gitlooppaths "private_gitreleasestartalert" "" "$(echo ${selectedRepositories[@]})"
}

##
# @internal
#
# @description Envia un aviso de comienzo de release a Rocket.Chat en un repositorio pasado como parametro
#
# @arg $1 string Ruta al repositorio.
#
private_gitreleasestartalert () {
    local path=$1
    local newVersion=$(gitreleasenextversion)
    local channel=$ROCKETCHATCHANNELAP2
    local path=$(basename "`pwd`")
    if [[ " ${COMMONPROJECTS[@]} " =~ " ${path} " ]]; then
        channel=$ROCKETCHATCHANNELCOMMON
    fi
    printtext "Sending message for $_COLORYELLOW_$path$_COLORDEFAULT_ to Rocket.Chat channel $_FONTBOLD_$channel$_FONTDEFAULT_"
    rocketchatsendmessage $channel "Preparando release *$newVersion* de *$path*"
    printsuccess "Message sent successfully"
}

##
# @internal
#
# @description Devuelve la version para la proxima release en el path actual
#
# @example
#   gitreleasenextversion
#
# @noargs
#
gitreleasenextversion () {
    local version=$(gitversion)
    local versionParts=(${version//./ })
    local firstPart=${versionParts[0]}
    local middlePart=${versionParts[1]}
    local lastPart="0"
    middlePart=$((middlePart + 1))
    unset 'versionParts[${#versionParts[@]}-1]'
    versionParts=( $firstPart $middlePart $lastPart )
    local newVersion=$(joinby . "${versionParts[@]}")
    echo $newVersion
}

##
# @description Crea una nueva release a partir de dev
#
# @example
#   #Iniciar release
#   gitreleasestartalert
#   gitreleasestart
#   
#   #Actualizar Changelog arriba y abajo
#   git add .
#   git commit -m "Release changelog"
#   
#   #Terminar release 
#   gitreleasefinish
#   
#   #Desplegar la release
#   ...
#   
#   #Notificar despligue
#   gitreleasefinishalert
#
# @noargs
#
gitreleasestart () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        local fromBranch="dev"

        # Comprobamos que la rama origen existe
        local branches=($(git branch | grep "[^* ]+" -Eo))
        if [[ " ${branches[@]} " =~ " ${fromBranch} " ]]; then
            # Vamos a la raiz del repo
            local pwd=$(pwd)
            local gitroot=$(git rev-parse --show-toplevel)
            cd $gitroot

            # Calculamos el nombre para la release a partir del changelog
            local version=$(gitversion) 
            local newVersion=$(gitreleasenextversion)
            local newBranch="release/$newVersion"

            if ! [[ " ${branches[@]} " =~ " ${newBranch} " ]]; then
                printtitle "New release from branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_ ($version => $_COLORYELLOW_$newVersion$_COLORDEFAULT_)"
                
                printlinebreak
                printwarning "Remember to pick up TRUNK"
                printwarning "Remember to update the CHANGELOG (up & down) before finish the release"
                printlinebreak

                # Creamos la nueva rama
                git stash
                git checkout $fromBranch
                git pull
                git checkout -b $newBranch
                git stash apply

                printlinebreak
                printsuccess "Branch $newBranch created successfully"
                printlinebreak

                printlinebreak
                printsuccess "Release $newVersion started successfully"
                printlinebreak
                printtext "Use$_FONTBOLD_ gitreleasefinish$_FONTDEFAULT_ to finalize the release"
            else
                printerror "Branch '$newBranch' already exists, do you have release in progress?"
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
# @description Finaliza la release, creando una tag y eliminando la rama de la release
#
# @example
#   gitreleasefinish
#
# @noargs
#
gitreleasefinish () {
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

            # Calculamos el nombre de la rama a partir del changelog
            local version=$(gitversion) 
            local newBranch="release/$version"

            if [[ " ${branches[@]} " =~ " ${newBranch} " ]]; then
                printtitle "Finishing release $_FONTBOLD_$version$_FONTDEFAULT_"

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
                printtext "Release$_FONTBOLD_ $version $_FONTDEFAULT_ finished succesfully"
            else
                printerror "Branch '$newBranch' not exists, do you modify CHANGELOG.md file?"
                return 1
            fi

            cd $pwd
        else
            printerror "Release branch '$fromBranch' no exists"
            return 1
        fi
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}

##
# @description Envia un aviso de final de release a Rocket.Chat en los repositorios seleccionados
#
# @example
#   gitreleasefinishalert
#
# @noargs
#
gitreleasefinishalert () {
    printtitle "Release finish alert"

    local selectedRepositories=()
    private_gitpickpaths selectedRepositories

    private_gitlooppaths "private_gitreleasefinishalert" "" "$(echo ${selectedRepositories[@]})"
}

##
# @internal
#
# @description Envia un aviso de final de release a Rocket.Chat en un repositorio pasado como parametro
#
# @arg $1 string Ruta al repositorio.
#
private_gitreleasefinishalert () {
    local path=$1
    local newVersion=$(gitversion)
    local channel=$ROCKETCHATCHANNELAP2
    local path=$(basename "`pwd`")
    if [[ " ${COMMONPROJECTS[@]} " =~ " ${path} " ]]; then
        channel=$ROCKETCHATCHANNELCOMMON
    fi
    printtext "Sending message for $_COLORYELLOW_$path$_COLORDEFAULT_ to Rocket.Chat channel $_FONTBOLD_$channel$_FONTDEFAULT_"
    rocketchatsendmessage $channel "Desplegada release *$newVersion* de *$path*"
    printsuccess "Message sent successfully"
}