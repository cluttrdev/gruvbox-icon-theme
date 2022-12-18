#!/usr/bin/env bash

set -eu

INKSCAPE=/usr/bin/inkscape

SOURCEDIR=./

THEMENAME=gruvbox-dark-green
THEMEDIR=../build/$THEMENAME

mkdir -p $THEMEDIR

cat << EOF > $THEMEDIR/index.theme
[Icon Theme]
Name=${THEMENAME}
Comment=A dark gruvbox icon theme with green accent
Inherits=Arc,Adwaita
EOF

declare -a directories=()

for SIZE in 16 22 24 32 48 64 96 128
do

    mkdir -p $THEMEDIR/$SIZE

    for CONTEXT in places 
    do
        directories+=("${SIZE}/${CONTEXT}")

        CURRENT_TARGETDIR=$THEMEDIR/$SIZE/$CONTEXT

        mkdir -p $CURRENT_TARGETDIR

        # create icon index available for export
        $INKSCAPE -S $SOURCEDIR/$CONTEXT.svg \
            | grep -E "_${SIZE}," \
            | sed 's/\,.*$//' \
            > index.tmp

        for OBJECT_ID in $(cat index.tmp)
        do
            ICON_NAME=$(sed "s/\_${SIZE}.*$//" <<< $OBJECT_ID)

            ICON_PATH=$CURRENT_TARGETDIR/$ICON_NAME.png

            if [ -f $ICON_PATH ]
            then
                echo "${ICON_PATH} exusts"
            else
                $INKSCAPE --export-id=$OBJECT_ID \
                    --export-id-only \
                    -o $ICON_PATH \
                    $SOURCEDIR/$CONTEXT.svg
            fi
        done

        cp -r $SOURCEDIR/symlinks/$CONTEXT/* $CURRENT_TARGETDIR/
    done

done

directory_list=$(printf ",%s" "${directories[@]}")
directory_list=${directory_list:1}

cat << EOF >> $THEMEDIR/index.theme

# Directory list
Directories=${directory_list}
EOF

declare -A CONTEXTS=(
    [actions]="Actions"
    [animations]="Animations"
    [apps]="Applications"
    [categories]="Categories"
    [devices]="Devices"
    [emblems]="Emblems"
    [emotes]="Emotes"
    [intl]="International"
    [mimetypes]="MimeTypes"
    [places]="Places"
    [status]="Status"
)

for dir in ${directories[@]}
do
    size=$(cut -d '/' -f1 <<< $dir)
    context=$(cut -d '/' -f2 <<< $dir)

    cat << EOF >> $THEMEDIR/index.theme

[${dir}]
Context=${CONTEXTS[${context}]}
Size=${size}
Type=Fixed
EOF

done
