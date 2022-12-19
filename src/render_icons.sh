#!/usr/bin/env bash

set -eu

INKSCAPE=/usr/bin/inkscape

SOURCEDIR=./

THEMENAME=gruvbox-dark-green
THEMEDIR=../build/$THEMENAME

# --------
# create temporary directory
TEMPDIR=$(mktemp -d)

# check if temp dir exists
if [[ ! "$TEMPDIR" || ! -d "$TEMPDIR" ]]
then
    echo "Temporary working directory could not be created"
    exit 1
fi

# cleanup temp dir on exit
trap "rm -rf ${TEMPDIR}" EXIT
# --------

# get color variables
source $SOURCEDIR/colors.sh

# create context source files from templates
for context in places
do
    # substitute placeholders in template files with env variables
    cat $SOURCEDIR/$context.svg.in | envsubst > $TEMPDIR/$context.svg
done

# create output directory
mkdir -p $THEMEDIR

cat << EOF > $THEMEDIR/index.theme
[Icon Theme]
Name=${THEMENAME}
Comment=A dark gruvbox icon theme with green accent
Inherits=Arc,Adwaita
EOF

declare -a directories=()

for size in 16 22 24 32 48 64 96 128
do

    mkdir -p $THEMEDIR/$size

    for context in places 
    do
        directories+=("${size}/${context}")

        CURRENT_TARGETDIR=$THEMEDIR/$size/$context

        mkdir -p $CURRENT_TARGETDIR

        # create icon index available for export
        $INKSCAPE -S $SOURCEDIR/$context.svg \
            | grep -E "_${size}," \
            | sed 's/\,.*$//' \
            > index.tmp

        for OBJECT_ID in $(cat index.tmp)
        do
            ICON_NAME=$(sed "s/\_${size}.*$//" <<< $OBJECT_ID)

            ICON_PATH=$CURRENT_TARGETDIR/$ICON_NAME.png

            if [ -f $ICON_PATH ]
            then
                echo "${ICON_PATH} exusts"
            else
                $INKSCAPE --export-id=$OBJECT_ID \
                    --export-id-only \
                    -o $ICON_PATH \
                    $SOURCEDIR/$context.svg
            fi
        done

        cp -r $SOURCEDIR/symlinks/$context/* $CURRENT_TARGETDIR/
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
