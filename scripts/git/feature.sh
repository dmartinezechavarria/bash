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
                    ( # try
                        set -e # Exit if error in any command

                        printtitle "New feature $_COLORYELLOW_$1$_COLORDEFAULT_ from branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_"
                        
                        # Iniciamos la nueva feature
                        local newBranch="feature/$1"
						local stashId=$(date +%s)
						local stashName="featurestart-$1-$stashId"
                        ( set -x; git stash push -m $stashName; )
                        ( set -x; git checkout $fromBranch; )
                        ( set -x; git pull; )
                        ( set -x; git checkout -b $newBranch; )

                        if git stash list | grep -q $stashName; then
                            ( set -x; git stash apply stash^{/featurestart-$1-$stashId}; )                                                 
                        else
                            printwarning "No stash for apply"
                        fi

                        printlinebreak
                        printsuccess "Branch $newBranch created successfully"
                        printlinebreak
                        printsuccess "Feature $1 started successfully"
                        printlinebreak
                        printtext "Use$_FONTBOLD_ gitfeaturecancel $1 $2$_FONTDEFAULT_ to cancel the feature"
                        printtext "Use$_FONTBOLD_ gitfeaturefinish $1 $2$_FONTDEFAULT_ to finalize the feature"
                        printtext "Use$_FONTBOLD_ gitfeatureupdate $1 $2$_FONTDEFAULT_ to update feature from origin branch"
                    )
                    errorCode=$?
                    if [ $errorCode -ne 0 ]; then
                        printerror "An error occurred while start feature $1 from $fromBranch"
                        printseparator
                        printlinebreak
                        return $errorCode
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
                        ( # try
                            set -e # Exit if error in any command

                            printtitle "Finish feature $_COLORYELLOW_$1$_COLORDEFAULT_ into branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_"

                            # Terminamos la feature
                            ( set -x; git checkout $fromBranch; )
                            ( set -x; git pull; )
                            ( set -x; git merge --no-ff $featureBranch; )
                            ( set -x; git branch -d $featureBranch; )

                            printlinebreak
                            printsuccess "Branch $featureBranch removed successfully"
                            printlinebreak
                            printsuccess "Feature $1 finish successfully"
                        )
                        errorCode=$?
                        if [ $errorCode -ne 0 ]; then
                            printerror "An error occurred while finish feature $1 into $fromBranch"
                            printseparator
                            printlinebreak
                            return $errorCode
                        fi
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
                        ( # try
                            set -e # Exit if error in any command

                            printtitle "Update feature $_COLORYELLOW_$1$_COLORDEFAULT_ from branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_"

							local stashId=$(date +%s)
							local stashName="featureupdate-$1-$stashId"
                            ( set -x; git stash push -m $stashName; )
                            ( set -x; git checkout $fromBranch; )
                            ( set -x; git pull; )
                            ( set -x; git checkout $featureBranch; )
                            ( set -x; git merge --no-ff $fromBranch; ) 
                            
                            if git stash list | grep -q $stashName; then
                                ( set -x; git stash apply stash^{/featureupdate-$1-$stashId}; )                                                 
                            else
                                printwarning "No stash for apply"
                            fi

                            printlinebreak
                            printsuccess "Feature $1 updated successfully"
                        )
                        errorCode=$?
                        if [ $errorCode -ne 0 ]; then
                            printerror "An error occurred while update feature $1 from $fromBranch"
                            printseparator
                            printlinebreak
                            return $errorCode
                        fi
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
                ( # try
                    set -e # Exit if error in any command

                    printtitle "Push feature $_COLORYELLOW_$1$_COLORDEFAULT_ to remote $_COLORGREEN_$remote$_COLORDEFAULT_"

                    ( set -x; git checkout $featureBranch; )
                    ( set -x; git push -u $remote $featureBranch; )

                    printlinebreak
                    printsuccess "Feature $1 pushed to $remote successfully"
                )
                errorCode=$?
                if [ $errorCode -ne 0 ]; then
                    printerror "An error occurred while push feature $1 to remote"
                    printseparator
                    printlinebreak
                    return $errorCode
                fi
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

##
# @description Cancelae la feature eliminando la rama y volviendo a la rama origen con los cambios pendientes
#
# @example
#   gitfeaturecancel GPHADPR-2104 dev
#
# @arg $1 string Nombre de la feature.
# @arg $2 string Rama desde la que se inicio la feature.
#
gitfeaturecancel () {
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
                        ( # try
                            set -e # Exit if error in any command

                            printtitle "Cancel feature $_COLORYELLOW_$1$_COLORDEFAULT_ and return to branch $_COLORGREEN_$fromBranch$_COLORDEFAULT_"

                            # Cancelamos la feature
                            ( set -x; git checkout $fromBranch; )
                            ( set -x; git branch -d $featureBranch; )

                            printlinebreak
                            printsuccess "Branch $featureBranch removed successfully"
                            printlinebreak
                            printsuccess "Feature $1 canceled successfully"
                        )
                        errorCode=$?
                        if [ $errorCode -ne 0 ]; then
                            printerror "An error occurred while cancel feature $1 and return to branch $fromBranch"
                            printseparator
                            printlinebreak
                            return $errorCode
                        fi
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