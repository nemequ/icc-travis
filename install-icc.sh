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
TEMPORARY_FILES="/tmp"
COMPONENTS="\"intel-icc-doc__noarch;intel-icc-ps-doc__noarch;intel-icc-ps-ss-doc__noarch;intel-icc-l-all__x86_64;intel-icc-l-ps-ss__x86_64;intel-icc-l-all-vars__noarch;intel-icc-l-all-common__noarch;intel-icc-l-ps-common__noarch;intel-icc-l-all-devel__x86_64;intel-icc-l-ps-devel__x86_64;intel-icc-l-ps-ss-devel__x86_64\""
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

INSTALLER="${TEMPORARY_FILES}/parallel_studio_xe_2016_online.sh"
INSTALLER_URL="http://registrationcenter-download.intel.com/akdlm/irc_nas/7997/parallel_studio_xe_2016_online.sh"
SILENT_CFG="${TEMPORARY_FILES}/silent.cfg"

if [ ! -e "${TEMPORARY_FILES}" ]; then
    echo "${TEMPORARY_FILES} does not exist, creating…"
    sudo mkdir -p "${TEMPORARY_FILES}"
    sudo chown -R "${USER}:${USER}" "${TEMPORARY_FILES}"
fi

if [ ! -e "${DESTINATION}" ]; then
    echo "${DESTINATION} does not exist, creating…"
    sudo mkdir -p "${DESTINATION}"
    sudo chown -R "${USER}:${USER}" "${DESTINATION}"
fi

if [ ! -e "${INSTALLER}" ]; then
	wget -O "${INSTALLER}" "${INSTALLER_URL}" || exit 1
fi
chmod u+x "${INSTALLER}"

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

"${INSTALLER}" \
    -t "${TEMPORARY_FILES}" \
    -s "${SILENT_CFG}" \
    --cli-mode \
    --user-mode &

# So Travis doesn't die in case of a long download
elapsed=0;
while kill -0 $! 2>/dev/null; do
    sleep 1
    elapsed=$(expr $elapsed + 1)
    if [ $(expr $elapsed % 60) -eq 0 ]; then
	echo "Still running... (about $(expr $elapsed / 60) minutes so far)."
    fi
done

ls -lR "${DESTINATION}"
exit 1
