#!/bin/bash

if [[ "${BASH_SOURCE-}" != "$0" ]]; then
    echo "You cannot source this script. Run it as ./$0" >&2
    exit 33
fi

MINICONDA_INSTALL_VERSION="3-py38_4.12.0"

VIRTUALIZE_MINICONDA_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE}" )" &> /dev/null && pwd )

DOWNLOADER_LIST=( curl wget )
DOWNLOADER=""

for p in ${DOWNLOADER_LIST[@]}; do
    #echo "checking for $p"
    if $( which $p 2>&1 > /dev/null ); then
        case $p in
            curl)
                DOWNLOADER="curl -o"
                ;;
            wget)
                DOWNLOADER="wget -O"
                ;;
        esac
	break
    fi
done

if [[ ! $DOWNLOADER ]]; then
    echo "error: could not find a downloader (e.g. curl or wget)"
    exit 33
fi

(
    set -e
    mkdir -p $VIRTUALIZE_MINICONDA_DIR
    cd $VIRTUALIZE_MINICONDA_DIR
    DOWNLOAD_URL="https://repo.anaconda.com/miniconda/Miniconda${MINICONDA_INSTALL_VERSION}-MacOSX-arm64.sh"
    echo url $DOWNLOAD_URL
    $DOWNLOADER miniconda.sh $DOWNLOAD_URL

    bash ./miniconda.sh -b -p miniconda
    rm miniconda.sh

    source ./miniconda/bin/activate
    conda env create --file $VIRTUALIZE_ROOT/environment.yml

    echo ""
    echo "done."
    echo ""
    echo "please ignore the above message about conda activate"
    echo "type 'source ./activate' to activate miniconda for this shell"
    echo ""
)
