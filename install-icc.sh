#!/bin/sh

# Install Intel Parallel Studio on Travis CI
# Originally written for Squash <https://github.com/quixdb/squash>
# by Evan Nemerson <evan@nemerson.com>.  For bug reports, please use
# <https://github.com/nemequ/travis-intel>
#
# This script is meant to be used on Travis CI; it hasn't been tested
# anywhere else.
#
# To use it, you must set the INTEL_SERIAL_NUMBER environment variable
# to your serial number.  You should use Travis' support for secure
# environment variables to do this; see
# <http://docs.travis-ci.com/user/encryption-keys/>.

# Default values; these can be changed with command line arguments:
DESTINATION="/opt/intel"
TEMPORARY_FILES="$PWD"
COMPONENTS="DEFAULTS"
PHONE_INTEL="no"

while [ $# != 0 ]; do
    case "$1" in
	"--dest")
	    DESTINATION="$2"; shift
	    ;;
	"--tmpdir")
	    TEMPORARY_FILES="$2"; shift
	    ;;
	"--components")
	    COMPONENTS="$2"; shift
	    ;;
    esac
    shift
done

INSTALLER_NAME=parallel_studio_xe_2016_online.sh

if [ ! -e "${INSTALLER_NAME}" ]; then
	wget -O "${TEMPORARY_FILES}/${INSTALLER_NAME}" \
		http://registrationcenter-download.intel.com/akdlm/irc_nas/7997/parallel_studio_xe_2016_online.sh \
		|| exit 1
fi
chmod u+x "${INSTALLER_NAME}"

SILENT_CFG="${TEMPORARY_FILES}/silent.cfg"
# See https://software.intel.com/en-us/articles/intel-composer-xe-2015-silent-installation-guide
echo "# Generated silent configuration file" > "${SILENT_CFG}"
echo "ACCEPT_EULA=accept" >> "${SILENT_CFG}"
echo "INSTALL_MODE=NONRPM" >> "${SILENT_CFG}"
echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> "${SILENT_CFG}"
echo "PSET_INSTALL_DIR=${DESTINATION}" >> "${SILENT_CFG}"
echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> "${SILENT_CFG}"
echo "COMPONENTS=${COMPONENTS}" >> "${SILENT_CFG}"
echo "PSET_MODE=install" >> "${SILENT_CFG}"
echo "ACTIVATION_SERIAL_NUMBER=${INTEL_SERIAL_NUMBER}" >> "${SILENT_CFG}"
echo "ACTIVATION_TYPE=serial_number" >> "${SILENT_CFG}"
echo "PHONEHOME_SEND_USAGE_DATA=${PHONE_INTEL}" >> "${SILENT_CFG}"

"${TEMPORARY_FILES}/${INSTALLER_NAME}" \
    -t "${TEMPORARY_FILES}" \
    -s "${SILENT_CFG}" \
    --cli-mode &

# So Travis doesn't die in case of a long download
elapsed=0;
while kill -0 $! 2>/dev/null; do
    sleep 1
    elapsed=$(expr $elapsed + 1)
    if [ $(expr $elapsed % 60) -eq 0 ]; then
	echo "Still running... (about $(expr $elapsed / 60) minutes so far)."
    fi
done
