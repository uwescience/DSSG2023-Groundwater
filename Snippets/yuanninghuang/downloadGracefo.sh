#!/bin/bash

GREP_OPTIONS=''

cookiejar=$(mktemp cookies.XXXXXXXXXX)
netrc=$(mktemp netrc.XXXXXXXXXX)
chmod 0600 "$cookiejar" "$netrc"
function finish {
  rm -rf "$cookiejar" "$netrc"
}

trap finish EXIT
WGETRC="$wgetrc"

prompt_credentials() {
    echo "Enter your Earthdata Login or other provider supplied credentials"
    read -p "Username (violethuang): " username
    username=${username:-violethuang}
    read -s -p "Password: " password
    echo "machine urs.earthdata.nasa.gov login $username password $password" >> $netrc
    echo
}

exit_with_error() {
    echo
    echo "Unable to Retrieve Data"
    echo
    echo $1
    echo
    echo "https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018152-2018181_GRFO_UTCSR_BA01_0601_LND_v04.nc"
    echo
    exit 1
}

prompt_credentials
  detect_app_approval() {
    approved=`curl -s -b "$cookiejar" -c "$cookiejar" -L --max-redirs 5 --netrc-file "$netrc" https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018152-2018181_GRFO_UTCSR_BA01_0601_LND_v04.nc -w '\n%{http_code}' | tail  -1`
    if [ "$approved" -ne "200" ] && [ "$approved" -ne "301" ] && [ "$approved" -ne "302" ]; then
        # User didn't approve the app. Direct users to approve the app in URS
        exit_with_error "Please ensure that you have authorized the remote application by visiting the link below "
    fi
}

setup_auth_curl() {
    # Firstly, check if it require URS authentication
    status=$(curl -s -z "$(date)" -w '\n%{http_code}' https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018152-2018181_GRFO_UTCSR_BA01_0601_LND_v04.nc | tail -1)
    if [[ "$status" -ne "200" && "$status" -ne "304" ]]; then
        # URS authentication is required. Now further check if the application/remote service is approved.
        detect_app_approval
    fi
}

setup_auth_wget() {
    # The safest way to auth via curl is netrc. Note: there's no checking or feedback
    # if login is unsuccessful
    touch ~/.netrc
    chmod 0600 ~/.netrc
    credentials=$(grep 'machine urs.earthdata.nasa.gov' ~/.netrc)
    if [ -z "$credentials" ]; then
        cat "$netrc" >> ~/.netrc
    fi
}

fetch_urls() {
  if command -v curl >/dev/null 2>&1; then
      setup_auth_curl
      while read -r line; do
        # Get everything after the last '/'
        filename="${line##*/}"

        # Strip everything after '?'
        stripped_query_params="${filename%%\?*}"

        curl -f -b "$cookiejar" -c "$cookiejar" -L --netrc-file "$netrc" -g -o $stripped_query_params -- $line && echo || exit_with_error "Command failed with error. Please retrieve the data manually."
      done;
  elif command -v wget >/dev/null 2>&1; then
      # We can't use wget to poke provider server to get info whether or not URS was integrated without download at least one of the files.
      echo
      echo "WARNING: Can't find curl, use wget instead."
      echo "WARNING: Script may not correctly identify Earthdata Login integrations."
      echo
      setup_auth_wget
      while read -r line; do
        # Get everything after the last '/'
        filename="${line##*/}"

        # Strip everything after '?'
        stripped_query_params="${filename%%\?*}"

        wget --load-cookies "$cookiejar" --save-cookies "$cookiejar" --output-document $stripped_query_params --keep-session-cookies -- $line && echo || exit_with_error "Command failed with error. Please retrieve the data manually."
      done;
  else
      exit_with_error "Error: Could not find a command-line downloader.  Please install curl or wget"
  fi
}

fetch_urls <<'EDSCEOF'
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018152-2018181_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018152-2018181_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018152-2018181_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018182-2018199_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018182-2018199_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018182-2018199_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018295-2018313_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018295-2018313_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018295-2018313_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018305-2018334_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018305-2018334_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018305-2018334_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018335-2018365_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018335-2018365_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2018335-2018365_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019001-2019031_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019001-2019031_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019001-2019031_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019026-2019065_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019026-2019065_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019026-2019065_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019060-2019090_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019060-2019090_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019060-2019090_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019091-2019120_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019091-2019120_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019091-2019120_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019121-2019151_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019121-2019151_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019121-2019151_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019152-2019181_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019152-2019181_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019152-2019181_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019182-2019212_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019182-2019212_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019182-2019212_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019213-2019243_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019213-2019243_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019213-2019243_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019244-2019273_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019244-2019273_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019244-2019273_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019274-2019304_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019274-2019304_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019274-2019304_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019305-2019334_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019305-2019334_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019305-2019334_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019335-2019365_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019335-2019365_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2019335-2019365_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020001-2020031_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020001-2020031_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020001-2020031_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020032-2020060_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020032-2020060_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020032-2020060_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020061-2020091_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020061-2020091_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020061-2020091_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020092-2020121_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020092-2020121_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020092-2020121_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020122-2020152_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020122-2020152_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020122-2020152_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020153-2020182_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020153-2020182_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020153-2020182_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020183-2020213_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020183-2020213_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020183-2020213_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020214-2020244_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020214-2020244_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020214-2020244_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020245-2020274_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020245-2020274_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020245-2020274_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020275-2020305_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020275-2020305_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020275-2020305_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020306-2020335_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020306-2020335_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020306-2020335_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020336-2020366_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020336-2020366_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2020336-2020366_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021001-2021031_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021001-2021031_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021001-2021031_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021032-2021059_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021032-2021059_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021032-2021059_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021060-2021090_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021060-2021090_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021060-2021090_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021091-2021120_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021091-2021120_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021091-2021120_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021121-2021151_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021121-2021151_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021121-2021151_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021152-2021181_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021152-2021181_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021152-2021181_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021182-2021212_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021182-2021212_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021182-2021212_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021213-2021243_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021213-2021243_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021213-2021243_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021244-2021273_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021244-2021273_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021244-2021273_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021274-2021304_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021274-2021304_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021274-2021304_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021305-2021334_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021305-2021334_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021305-2021334_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021335-2021365_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021335-2021365_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2021335-2021365_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022001-2022031_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022001-2022031_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022001-2022031_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022032-2022059_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022032-2022059_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022032-2022059_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022060-2022090_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022060-2022090_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022060-2022090_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022091-2022120_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022091-2022120_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022091-2022120_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022121-2022151_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022121-2022151_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022121-2022151_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022152-2022181_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022152-2022181_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022152-2022181_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022182-2022212_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022182-2022212_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022182-2022212_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022213-2022243_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022213-2022243_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022213-2022243_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022244-2022273_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022244-2022273_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022244-2022273_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022274-2022304_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022274-2022304_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022274-2022304_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022305-2022334_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022305-2022334_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022305-2022334_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022335-2022365_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022335-2022365_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2022335-2022365_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023001-2023031_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023001-2023031_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023001-2023031_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023032-2023059_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023032-2023059_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023032-2023059_GRFO_UTCSR_BA01_0601_LND_v04.txt
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023060-2023090_GRFO_UTCSR_BA01_0601_LND_v04.nc
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023060-2023090_GRFO_UTCSR_BA01_0601_LND_v04.tif
https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-public/TELLUS_GRFO_L3_CSR_RL06.1_LND_v04/GRD-3_2023060-2023090_GRFO_UTCSR_BA01_0601_LND_v04.txt
EDSCEOF