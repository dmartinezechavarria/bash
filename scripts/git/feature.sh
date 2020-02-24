#!/bin/bash
#
# @file Git/Feature (git/feature.sh)
# @brief Contiene funciones para realizar la parte GIT de las features

##
# @description Crea una nueva feature a partir de una rama
#
# @example
#   #Iniciar feature
#   gitfeaturestart GPHADPR-2104 dev
#   
#   #Opcionalmente nos traemos los cambios de dev a la feature cuando queramos
#   gitfeatureupdate GPHADPR-2104 dev 
#   
#   #Realizar cambios de la feature y actualizar Changelog
#   git add .
#   git commit -m "GPHADPR-2104 - ...."
#   
#   #Terminar feature 
#   gitfeaturefinish GPHADPR-2104 dev
#
# @arg $1 string Nombre para la feature, se generara la rama feature/nombre.
# @arg $2 string Rama local de origen para la feature.
#
gitfeaturestart () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        # Comprobamos que se pasa un nombre para la feature
        if [ -z "$1" ]
        then
            printerror "No feature name provided"
            return 1
        else
            # Comprobamos si se pasa una rama de origen
            if [ -z "$2" ]
            then
                printerror "No origin branch provided"
                return 1
            else
                fromBranch=$2

                # Comprobamos que la rama origen existe
                local branches=($(git branch | grep "[^* ]+" -Eo))
                if [[ " ${branches[@]} " =~ " ${fromBranch} " ]]; then
                    printtitle "New feature $_COLORYELLOW_$1$_COLORDEFAULT_ from branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_"
                    
                    # Iniciamos la nueva feature
                    local newBranch="feature/$1"
                    git stash
                    git checkout $fromBranch
                    git pull
                    git checkout -b $newBranch
                    git stash apply

                    printlinebreak
                    printsuccess "Branch $newBranch created successfully"
                    printlinebreak
                    printsuccess "Feature $1 started successfully"
                    printlinebreak
                    printtext "Use$_FONTBOLD_ gitfeaturefinish $1 $2$_FONTDEFAULT_ to finalize the feature"
                    printtext "Use$_FONTBOLD_ gitfeatureupdate $1 $2$_FONTDEFAULT_ to update feature from origin branch"
                else
                    printerror "Origin branch '$fromBranch' no exists"
                    return 1
                fi
            fi
        fi
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}

##
# @description Finaliza una feature mezclandola con la rama recibida
# Una vez terminada elimina la rama feature/xxx
#
# @example
#   gitfeaturefinish GPHADPR-2104 dev
#
# @arg $1 string Nombre de la feature.
# @arg $2 string Rama sobre la que finalizar la feature.
#
gitfeaturefinish () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        # Comprobamos que se pasa un nombre para la feature
        if [ -z "$1" ]
        then
            printerror "No feature name provided"
            return 1
        else
            # Comprobamos si se pasa una rama de destino
            if [ -z "$2" ]
            then
                printerror "No destiny branch provided"
                return 1
            else
                fromBranch=$2

                # Comprobamos que la rama origen existe
                local branches=($(git branch | grep "[^* ]+" -Eo))
                if [[ " ${branches[@]} " =~ " ${fromBranch} " ]]; then
                    # Comprobamos que la rama feature existe
                    local featureBranch="feature/$1"
                    if [[ " ${branches[@]} " =~ " ${featureBranch} " ]]; then
                        printtitle "Finish feature $_COLORYELLOW_$1$_COLORDEFAULT_ into branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_"

                        # Terminamos la feature
                        git checkout $fromBranch
                        git pull
                        git merge --no-ff $featureBranch
                        git branch -d $featureBranch

                        printlinebreak
                        printsuccess "Branch $featureBranch removed successfully"
                        printlinebreak
                        printsuccess "Feature $1 finish successfully"
                    else
                        printerror "Feature '$1' no exists"
                        return 1
                    fi
                else
                    printerror "Origin branch '$fromBranch' no exists"
                    return 1
                fi
            fi
        fi
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}

##
# @description Se trae los cambios de la rama recibida a la feature
#
# @example
#   gitfeatureupdate GPHADPR-2104 dev
#
# @arg $1 string Nombre de la feature.
# @arg $2 string Rama desde la que actualizar la feature.
#
gitfeatureupdate () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        # Comprobamos que se pasa un nombre para la feature
        if [ -z "$1" ]
        then
            printerror "No feature name provided"
            return 1
        else
            # Comprobamos si se pasa una rama de origen
            if [ -z "$2" ]
            then
                printerror "No origin branch provided"
                return 1
            else
                fromBranch=$2

                # Comprobamos que la rama origen existe
                local branches=($(git branch | grep "[^* ]+" -Eo))
                if [[ " ${branches[@]} " =~ " ${fromBranch} " ]]; then
                    # Comprobamos que la rama feature existe
                    local featureBranch="feature/$1"
                    if [[ " ${branches[@]} " =~ " ${featureBranch} " ]]; then
                        printtitle "Update feature $_COLORYELLOW_$1$_COLORDEFAULT_ from branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_"

                        git stash
                        git checkout $fromBranch
                        git pull
                        git checkout $featureBranch
                        git merge --no-ff $fromBranch
                        git stash apply

                        printlinebreak
                        printsuccess "Feature $1 updated successfully"
                    else
                        printerror "Feature '$1' no exists"
                        return 1
                    fi
                else
                    printerror "Origin branch '$fromBranch' no exists"
                    return 1
                fi
            fi
        fi
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}

##
# @description Convierte la rama de la feature en una rama remota para trabajar con otras personas
#
# @example
#   gitfeatureremote GPHADPR-2104
#
# @arg $1 string Nombre de la feature.
#
gitfeatureremote () {
    inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"

    # Comprobamos que estamos en un repo GIT
    if [ "$inside_git_repo" ]; then
        # Comprobamos que se pasa un nombre para la feature
        if [ -z "$1" ]
        then
            printerror "No feature name provided"
            return 1
        else
            # Comprobamos que la rama feature existe
            local branches=($(git branch | grep "[^* ]+" -Eo))
            local featureBranch="feature/$1"
            local remote="origin"
            if [[ " ${branches[@]} " =~ " ${featureBranch} " ]]; then
                printtitle "Push feature $_COLORYELLOW_$1$_COLORDEFAULT_ to remote $_COLORGREEN_$remote$_COLORDEFAULT_"

                git checkout $featureBranch
                git push -u $remote $featureBranch

                printlinebreak
                printsuccess "Feature $1 pushed to $remote successfully"
            else
                printerror "Feature '$1' no exists"
                return 1
            fi
        fi
    else
        printerror "Not a git repository (or any of the parent directories)"
        return 1
    fi
}