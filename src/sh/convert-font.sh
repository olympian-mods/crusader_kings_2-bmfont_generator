#!/bin/bash

VERSION="1.0.0"
APP_NAME="BMFont Generator: CK2 Converter, ${VERSION}"

function echoAppName() {
    echo "${APP_NAME}"
}

function echoUsage() {
  echo "Usage: $(basename $0) [OPTION] FONTFILE"
  echo "Convert BMFont files for Crusader Kings 2."
  echo ""
  echo "Options:"
  echo "  -v, --version      output version information and exit"
  echo "  -h, --help         display this help and exit"
  echo ""
  echo "FONTFILE is the .fnt font file to be converted."
  echo "In addition to the .fnt file a .tga file is expected in the"
  echo "same directory with the '_0.tga' suffix, e.g. 'my_font_0.tga'."
  echo "The .tga file will be renamed during the process to match the name of the .fnt file."
  echo ""
  echo "Examples:"
  echo "  $(basename $0) /tmp/fonts/century_gothic_bold_18.fnt"
}

ARG1=$1

case "${ARG1}" in
  ""|"-h"|"--help")
    echoUsage
    exit 0
    ;;
  "-v"|"--version")
    echoAppName
    exit 0
  ;;
esac

WORKINGDIR=$(dirname "$(readlink -f "${ARG1}")")
FONT_BASENAME=$(basename "${ARG1}" .fnt)
FONT_FNT=${FONT_BASENAME}.fnt
FONT_TGA=${FONT_BASENAME}_0.tga

pushd "$WORKINGDIR" > /dev/null


if [ ! -f "${FONT_FNT}" ]
  then
    echo "[ERROR] Could not find ${FONT_FNT}!"
    popd > /dev/null
    exit 1
fi

if [ ! -f "${FONT_TGA}" ]
  then
    echo "[ERROR] Could not find ${FONT_TGA}!"
    popd > /dev/null
    exit 1
fi

echo "Converting ${FONT_FNT}..."
sed -i -r -e 's/unicode=0\s*//g' -e 's/\s*outline=0//g' -e 's/\s*chnl=15//g' -e 's/\s*packed=.*//g' -e '3,4d' "${FONT_FNT}"

unix2dos "$FONT_FNT"

echo "Renaming ${FONT_TGA}..."
mv "${FONT_TGA}" "${FONT_BASENAME}.tga"

echo ""
echo "Done!"
popd > /dev/null
