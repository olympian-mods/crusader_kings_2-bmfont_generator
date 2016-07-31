#!/bin/bash

VERSION="1.0.0"
APP_NAME="BMFont Generator: Property Modifier, ${VERSION}"

function echoAppName() {
    echo "${APP_NAME}"
}

function echoUsage() {
	local SCRIPTNAME=$(basename "$0")
	echo "NAME"
	echo "       ${SCRIPTNAME} - modifies a property in a BMFont .fnt file."
	echo ""
	echo "SYNOPSIS"
	echo "       ${SCRIPTNAME} -p PROPERTY -a VALUE"
	echo ""
	echo "OPTIONS"
	echo "       -p     specifies the name of the property to be modified"
	echo "       -a     specifies the posotive or negative value to be added to the specified property's value."
	echo "       -v     output version information and exit"
	echo "       -h     display this help and exit"
	echo ""
	echo "EXAMPLES"
	echo "       ${SCRIPTNAME} -p yoffset -a -3 /tmp/fonts/century_gothic_bold_18.fnt"
	echo "              Add \"-3\" to value of property \"yoffset\" in file \"/tmp/fonts/century_gothic_bold_18.fnt\""
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

echo "${FONT_FNT}: adding \"${ADDVALUE}\" to value of property \"${PROPERTY}\"..."

# /e allows you to pass matched part to external command, and do substitution with the execution result. GNU sed only.
sed -i -r 's/(.*'${PROPERTY}'=)([-0-9]+)(.*)/echo "\1$(echo "\2 + '${ADDVALUE}'"|bc)\3"/ge' "${FONT_FNT}"

unix2dos "$FONT_FNT"

echo ""
echo "Done!"
popd > /dev/null
