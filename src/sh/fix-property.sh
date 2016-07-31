#!/bin/bash

VERSION="1.0.0"
APP_NAME="BMFont Generator: Property Modifier, ${VERSION}"

function echoAppName() {
    echo "${APP_NAME}"
}

function echoUsage() {
  echo "Usage: $(basename "$0") -p PROPERTY -a VALUE"
  echo "Modify BMFont properties"
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
  echo "  $(basename "$0") -p yoffset -a 2 /tmp/fonts/century_gothic_bold_18.fnt"
}

PROPERTY=
ADDVALUE=

while getopts ":p:a:hv" OPTION; do
  case "${OPTION}" in
    p)
	  PROPERTY="${OPTARG}"
	;;
    a)
      ADDVALUE="${OPTARG}"
	;;
	v)
	  echoAppName
	  exit 0
	;;
	h)
	  echoUsage
	  exit 0
	;;
    \?)
	  echo "Unknown option -${OPTARG}!"
	  echo ""
      echoUsage
	  exit 1
	;;
  esac
done

# Shift so arguments after positional options are stored in $1, $2, etc.
shift $((${OPTIND} - 1))


if [ -z "${PROPERTY}" -a -z "${ADDVALUE}" ]
  then
    echoUsage
	exit 1
fi

ARG1=$1
WORKINGDIR=$(dirname "$(readlink -f "${ARG1}")")
FONT_BASENAME=$(basename "${ARG1}" .fnt)
FONT_FNT=${FONT_BASENAME}.fnt

pushd "$WORKINGDIR" > /dev/null

if [ ! -f "${FONT_FNT}" ]
  then
    echo "[ERROR] Could not find ${FONT_FNT}!"
    popd > /dev/null
    exit 1
fi

echo "Modifying ${FONT_FNT}: add \"${ADDVALUE}\" to property \"${PROPERTY}\"..."

sed -i -r 's/(.*yoffset=)([-0-9]+)(.*)/echo "\1$(echo "\2 + 100"|bc)\3"/ge' "${FONT_FNT}"

unix2dos "$FONT_FNT"

echo ""
echo "Done!"
popd > /dev/null
