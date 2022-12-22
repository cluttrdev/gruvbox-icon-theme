#!/usr/bin/env bash

set -eu
set -o pipefail

INKSCAPE=/usr/bin/inkscape

DIR=$(dirname "${BASH_SOURCE[0]}")

# --------
# default options
SOURCEDIR=${DIR}
BUILDDIR=${DIR}/../build

PALETTEMODE=dark
PALETTEACCENT=green

optstring="s:b:m:c:"
while getopts ${optstring} arg; do
    case ${arg} in
		s) # source dir
			;;
		b) # build dir
			;;
        m) # palette mode
            if grep -qw "${OPTARG}" <<< "dark light"; then
                PALETTEMODE=${OPTARG}
            else
                echo "Invalid palette mode: ${OPTARG}"
                exit 1
            fi
            ;;
        c) # accent color
            if grep -qw "${OPTARG}" <<< "red green yellow blue purple aqua orange"; then
                PALETTEACCENT=${OPTARG}
            else
                echo "Invalid accent color: ${OPTARG}"
                exit 1
            fi
            ;;
    esac
done

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
export PALETTE_MODE=${PALETTEMODE}
export PALETTE_ACCENT=${PALETTEACCENT}

source $SOURCEDIR/colors.sh

declare -a CONTEXTS=(mimetypes places)

# create context source files from templates
for context in ${CONTEXTS[@]}
do
    # substitute placeholders in template files with env variables
    cat $SOURCEDIR/templates/$context.svg.in | envsubst > $TEMPDIR/$context.svg
done

# create output directory
THEMENAME=gruvbox-${PALETTEMODE}-${PALETTEACCENT}
THEMEDIR=$BUILDDIR/$THEMENAME

mkdir -p $THEMEDIR

declare -a directories=()

for size in 16 22 24 32 48 64 96 128
do

    mkdir -p $THEMEDIR/$size

    for context in ${CONTEXTS[@]}
    do
        directories+=("${size}/${context}")

        CURRENT_TARGETDIR=$THEMEDIR/$size/$context

        mkdir -p $CURRENT_TARGETDIR

        # create icon index available for export
        $INKSCAPE -S $TEMPDIR/$context.svg \
            | grep -E "_${size}," \
            | sed 's/\,.*$//' \
            > $TEMPDIR/index.tmp

        for OBJECT_ID in $(cat $TEMPDIR/index.tmp)
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
                    $TEMPDIR/$context.svg
            fi
        done

        if [ -d $SOURCEDIR/symlinks/$context ]
        then
            cp -r $SOURCEDIR/symlinks/$context/* $CURRENT_TARGETDIR/
        fi
    done

done

# set up theme file header
cat << EOF > $THEMEDIR/index.theme
[Icon Theme]
Name=${THEMENAME}
Comment=An icon theme following the gruvbox palette in ${PALETTEMODE} mode with ${PALETTEACCENT} accent color.
Inherits=Arc,Adwaita
EOF

directory_list=$(printf ",%s" "${directories[@]}")
directory_list=${directory_list:1}

cat << EOF >> $THEMEDIR/index.theme

# Directory list
Directories=${directory_list}
EOF

declare -A CONTEXTS_MAP=(
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
Context=${CONTEXTS_MAP[${context}]}
Size=${size}
Type=Fixed
EOF

done
