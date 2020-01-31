#!/bin/bash

DOCPATH="$( cd "$( dirname "$BASH_SOURCE" )" >/dev/null 2>&1 && pwd )"
DOCFILENAME=README.md

source $DOCPATH/../include.sh

printtitle "Bash documentation generator"

printtext "- Removing old documentation..."
rm $DOCPATH/../$DOCFILENAME
printtext "- Generating new documentation..."
cp $DOCPATH/TemplateREADME.md $DOCPATH/../$DOCFILENAME

SCRIPTFILES=($(find $DOCPATH/../scripts -type f -regex "^.*$"))
for file in ${SCRIPTFILES[*]}
do
    printtext "\t* Processing $file..."
    $DOCPATH/shdoc/shdoc < $file >> $DOCPATH/../$DOCFILENAME
done

printtext "- Generating table of contents..."
TOCTITLE=$'# Índice\n\n'
LINEBREAK=$'\n\n\n'
echo "$TOCTITLE$($DOCPATH/generateTOC.sh < $DOCPATH/../$DOCFILENAME)$LINEBREAK" | cat - $DOCPATH/../$DOCFILENAME > temp && mv temp $DOCPATH/../$DOCFILENAME

printlinebreak
printsuccess "Documentation generated"