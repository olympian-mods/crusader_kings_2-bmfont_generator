#!/bin/bash

FONT_BASENAME=$1
FONT_FNT=${FONT_BASENAME}.fnt
FONT_TGA=${FONT_BASENAME}_0.tga

if [ ! -f "${FONT_FNT}" ]
  then
    echo "Could not find ${FONT_FNT}!"
	exit 1
fi

if [ ! -f "${FONT_TGA}" ]
  then
    echo "Could not find ${FONT_TGA}!"
	exit 1
fi

echo "Converting ${FONT_FNT}..."
sed -i -r -e 's/unicode=0\s*//g' -e 's/\s*outline=0//g' -e 's/\s*chnl=15//g' -e 's/\s*packed=.*//g' -e '3,4d' "${FONT_FNT}"

unix2dos "$FONT_FNT"

echo "Renaming ${FONT_TGA}..."
mv "${FONT_TGA}" "${FONT_BASENAME}.tga"

echo ""
echo "Done!"