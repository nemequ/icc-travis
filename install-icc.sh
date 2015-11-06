#!/bin/sh

# Install Intel Parallel Studio on Travis CI
# https://github.com/nemequ/icc-travis
#
# Originally written for Squash <https://github.com/quixdb/squash> by
# Evan Nemerson.  For documentation, bug reports, support requests,
# etc. please use <https://github.com/nemequ/icc-travis>.
#
# To the extent possible under law, the author(s) of this script have
# waived all copyright and related or neighboring rights to this work.
# See <https://creativecommons.org/publicdomain/zero/1.0/> for
# details.

COMPONENTS_ICC="intel-icc-l-all__x86_64;intel-icc-l-ps-ss__x86_64;intel-icc-l-all-vars__noarch;intel-icc-l-all-common__noarch;intel-icc-l-ps-common__noarch;intel-icc-l-all-devel__x86_64;intel-icc-l-ps-devel__x86_64;intel-icc-l-ps-ss-devel__x86_64"
COMPONENTS_MPI="intel-mpi-rt-core__x86_64;intel-mpi-rt-mic__x86_64;intel-mpi-sdk-core__x86_64;intel-mpi-sdk-mic__x86_64;intel-mpi-psxe__x86_64;intel-mpi-rt-psxe__x86_64"
COMPONENTS_VTUNE="intel-vtune-amplifier-xe-2016-cli__x86_64;intel-vtune-amplifier-xe-2016-common__noarch;intel-vtune-amplifier-xe-2016-cli-common__noarch;intel-vtune-amplifier-xe-2016-collector-64linux__x86_64;intel-vtune-amplifier-xe-2016-sep__noarch;intel-vtune-amplifier-xe-2016-gui-common__noarch;intel-vtune-amplifier-xe-2016-gui__x86_64;intel-vtune-amplifier-xe-2016-common-pset__noarch"
COMPONENTS_INSPECTOR="intel-inspector-xe-2016-cli__x86_64;intel-inspector-xe-2016-cli-common__noarch;intel-inspector-xe-2016-gui-common__noarch;intel-inspector-xe-2016-gui__x86_64;intel-inspector-xe-2016-cli-pset__noarch"
COMPONENTS_ADVISOR="intel-advisor-xe-2016-cli__x86_64;intel-advisor-xe-2016-cli-common__noarch;intel-advisor-xe-2016-gui-common__noarch;intel-advisor-xe-2016-gui__x86_64;intel-advisor-xe-2016-cli-pset__noarch"
COMPONENTS_OPENMP="intel-openmp-l-all__x86_64;intel-openmp-l-ps-mic__x86_64;intel-openmp-l-ps__x86_64;intel-openmp-l-ps-ss__x86_64;intel-openmp-l-all-devel__x86_64;intel-openmp-l-ps-mic-devel__x86_64;intel-openmp-l-ps-devel__x86_64;intel-openmp-l-ps-ss-devel__x86_64"
COMPONENTS_TBB="intel-tbb-libs__noarch;intel-mkl-ps-tbb__x86_64;intel-mkl-ps-tbb-devel__x86_64;intel-mkl-ps-tbb-mic__x86_64;intel-mkl-ps-tbb-mic-devel__x86_64;intel-tbb-source__noarch;intel-tbb-devel__noarch;intel-tbb-common__noarch;intel-tbb-ps-common__noarch;intel-tbb-psxe__noarch"
COMPONENTS_IFORT="intel-ifort-l-ps__x86_64;intel-ifort-l-ps-vars__noarch;intel-ifort-l-ps-common__noarch;intel-ifort-l-ps-devel__x86_64"
COMPONENTS_MKL="intel-mkl__x86_64;intel-mkl-ps__x86_64;intel-mkl-common__noarch;intel-mkl-ps-common__noarch;intel-mkl-devel__x86_64;intel-mkl-ps-mic-devel__x86_64;intel-mkl-ps-f95-devel__x86_64;intel-mkl-gnu-devel__x86_64;intel-mkl-ps-gnu-devel__x86_64;intel-mkl-ps-pgi-devel__x86_64;intel-mkl-sp2dp-devel__x86_64;intel-mkl-ps-cluster-devel__x86_64;intel-mkl-ps-cluster-common__noarch;intel-mkl-ps-f95-common__noarch;intel-mkl-ps-cluster__x86_64;intel-mkl-gnu__x86_64;intel-mkl-ps-gnu__x86_64;intel-mkl-ps-pgi__x86_64;intel-mkl-sp2dp__x86_64;intel-mkl-ps-mic__x86_64;intel-mkl-ps-tbb__x86_64;intel-mkl-ps-tbb-devel__x86_64;intel-mkl-ps-tbb-mic__x86_64;intel-mkl-ps-tbb-mic-devel__x86_64;intel-mkl-psxe__noarch"
COMPONENTS_IPP="intel-ipp-l-common__noarch;intel-ipp-l-ps-common__noarch;intel-ipp-l-st__x86_64;intel-ipp-l-mt__x86_64;intel-ipp-l-st-devel__x86_64;intel-ipp-l-ps-st-devel__x86_64;intel-ipp-l-mt-devel__x86_64;intel-ipp-psxe__noarch"
COMPONENTS_IPP_CRYPTO="intel-crypto-ipp-st-devel__x86_64;intel-crypto-ipp-ps-st-devel__x86_64;intel-crypto-ipp-st__x86_64;intel-crypto-ipp-mt-devel__x86_64;intel-crypto-ipp-mt__x86_64;intel-crypto-ipp-ss-st-devel__x86_64;intel-crypto-ipp-common__noarch"
COMPONENTS_GDB="intel-gdb-gt__x86_64;intel-gdb-gt-src__noarch;intel-gdb-gt-libelfdwarf__x86_64;intel-gdb-gt-devel__x86_64;intel-gdb-gt-common__noarch;intel-gdb-ps-cdt__x86_64;intel-gdb-ps-cdt-source__x86_64;intel-gdb-ps-mic__x86_64;intel-gdb-ps-mpm__x86_64;intel-gdb__x86_64;intel-gdb-source__noarch;intel-gdb-python-source__noarch;intel-gdb-common__noarch;intel-gdb-ps-common__noarch"

DESTINATION="${HOME}/intel"
TEMPORARY_FILES="/tmp"
PHONE_INTEL="no"
COMPONENTS=""

add_components() {
    if [ ! -z "${COMPONENTS}" ]; then
	COMPONENTS="${COMPONENTS};"
    fi
    COMPONENTS="${COMPONENTS}$1"
}

while [ $# != 0 ]; do
    case "$1" in
	"--dest")
	    DESTINATION="$2"; shift
	    ;;
	"--tmpdir")
	    TEMPORARY_FILES="$2"; shift
	    ;;
	"--components")
	    shift
	    OLD_IFS="${IFS}"
	    IFS=","
	    for component in $1; do
		case "$component" in
		    "icc")
			# Do nothing, we always install icc
			add_components "${COMPONENTS_ICC}"
		        ;;
		    "mpi")
			add_components "${COMPONENTS_MPI}"
			;;
		    "vtune")
			add_components "${COMPONENTS_VTUNE}"
			;;
		    "inspector")
			add_components "${COMPONENTS_INSPECTOR}"
			;;
		    "advisor")
			add_components "${COMPONENTS_ADVISOR}"
			;;
		    "openmp")
			add_components "${COMPONENTS_OPENMP}"
			;;
		    "tbb")
			add_components "${COMPONENTS_TBB}"
			;;
		    "ifort")
			add_components "${COMPONENTS_IFORT}"
			;;
		    "mkl")
			add_components "${COMPONENTS_MKL}"
			;;
		    "ipp")
			add_components "${COMPONENTS_IPP}"
			;;
		    "ipp-crypto")
			add_components "${COMPONENTS_IPP_CRYPTO}"
			;;
		    "gdb")
			add_components "${COMPONENTS_GDB}"
			;;
		    *)
			echo "Unknown component '$component'"
			exit 1
			;;
		esac
	    done
	    IFS="${OLD_IFS}"
	    shift
	    ;;
	*)
	    echo "Unrecognized argument '$1'"
	    exit 1
	    ;;
    esac
    shift
done

if [ -z "${COMPONENTS}" ]; then
    COMPONENTS="${COMPONENTS_ICC}"
fi

INSTALLER="${TEMPORARY_FILES}/parallel_studio_xe_2016_online.sh"
INSTALLER_URL="http://registrationcenter-download.intel.com/akdlm/irc_nas/7997/parallel_studio_xe_2016_online.sh"
SILENT_CFG="${TEMPORARY_FILES}/silent.cfg"
SUCCESS_INDICATOR="${TEMPORARY_FILES}/icc-travis-success"

if [ ! -e "${TEMPORARY_FILES}" ]; then
    echo "${TEMPORARY_FILES} does not exist, creating..."
    mkdir -p "${TEMPORARY_FILES}" || (sudo mkdir -p "${TEMPORARY_FILES}" && sudo chown -R "${USER}:${USER}" "${TEMPORARY_FILES}")
fi

if [ ! -e "${DESTINATION}" ]; then
    echo "${DESTINATION} does not exist, creating..."
    mkdir -p "${DESTINATION}" || (sudo mkdir -p "${DESTINATION}" && sudo chown -R "${USER}:${USER}" "${DESTINATION}")
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

("${INSTALLER}" \
    -t "${TEMPORARY_FILES}" \
    -s "${SILENT_CFG}" \
    --cli-mode \
    --user-mode && \
touch "${SUCCESS_INDICATOR}") &

# So Travis doesn't die in case of a long download/installation.
elapsed=0;
while kill -0 $! 2>/dev/null; do
    sleep 1
    elapsed=$(expr $elapsed + 1)
    if [ $(expr $elapsed % 60) -eq 0 ]; then
	echo "Still running... (about $(expr $elapsed / 60) minutes so far)."
    fi
done

if [ ! -e "${SUCCESS_INDICATOR}" ]; then
    echo "Installation failed."
    exit 1
else
    echo "Installation successful!"
    find "${DESTINATION}" -name 'libintelremotemon.so'
    echo "Done."
fi

# We can't just export a new path since it will not persist to the
# next item in our .travis.yml, and adding a line to ~/.bashrc doesn't
# work either, so we'll just dump a bunch of symlinks in a directory
# which is already in $PATH.
SYMDIR="${HOME}/.local/bin"
if [ ! -e "${SYMDIR}" ]; then
    mkdir -p "${SYMDIR}"
fi
for executable in "${DESTINATION}"/bin/*; do
    WRAPPER="${SYMDIR}"/$(basename "${executable}")
    cat >"${WRAPPER}" <<EOF
#!/bin/sh
LD_LIBRARY_PATH="${DESTINATION}/ism/bin/intel64:\$LD_LIBRARY_PATH" ${executable} "\$@"
EOF
    chmod u+x "${WRAPPER}"
done
