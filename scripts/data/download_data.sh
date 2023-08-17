
##GRACE 

#!/bin/bash

# Define variables for start and end dates
start_date="2002-04-04T00:00:00Z"
end_date="2023-09-01T00:00:00Z"

# Run the podaac-data-subscriber command with the specified dates
# Note this assumes that you are executing the shell script from the first level of your repository 
podaac-data-subscriber -c TELLUS_GRAC-GRFO_MASCON_CRI_GRID_RL06.1_V3 -d /data/TELLUS_GRAC-GRFO_MASCON_CRI_GRID_RL06.1_V3 --start-date "$start_date" --end-date "$end_date"


##GLDAS

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
    read -p "Username (asetia): " username
    username=${username:-asetia}
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
    echo "https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2023/GLDAS_NOAH025_M.A202303.021.nc4"
    echo
    exit 1
}

prompt_credentials
  detect_app_approval() {
    approved=`curl -s -b "$cookiejar" -c "$cookiejar" -L --max-redirs 5 --netrc-file "$netrc" https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2023/GLDAS_NOAH025_M.A202303.021.nc4 -w '\n%{http_code}' | tail  -1`
    if [ "$approved" -ne "200" ] && [ "$approved" -ne "301" ] && [ "$approved" -ne "302" ]; then
        # User didn't approve the app. Direct users to approve the app in URS
        exit_with_error "Please ensure that you have authorized the remote application by visiting the link below "
    fi
}

setup_auth_curl() {
    # Firstly, check if it require URS authentication
    status=$(curl -s -z "$(date)" -w '\n%{http_code}' https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2023/GLDAS_NOAH025_M.A202303.021.nc4 | tail -1)
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
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2023/GLDAS_NOAH025_M.A202303.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2023/GLDAS_NOAH025_M.A202302.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2023/GLDAS_NOAH025_M.A202301.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202212.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202211.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202210.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202209.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202208.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202207.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202206.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202205.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202204.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202203.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202202.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2022/GLDAS_NOAH025_M.A202201.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202112.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202111.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202110.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202109.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202108.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202107.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202106.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202105.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202104.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202103.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202102.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2021/GLDAS_NOAH025_M.A202101.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202012.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202011.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202010.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202009.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202008.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202007.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202006.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202005.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202004.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202003.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202002.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2020/GLDAS_NOAH025_M.A202001.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201912.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201911.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201910.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201909.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201908.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201907.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201906.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201905.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201904.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201903.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201902.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2019/GLDAS_NOAH025_M.A201901.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201812.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201811.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201810.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201809.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201808.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201807.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201806.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201805.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201804.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201803.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201802.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2018/GLDAS_NOAH025_M.A201801.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201712.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201711.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201710.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201709.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201708.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201707.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201706.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201705.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201704.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201703.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201702.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2017/GLDAS_NOAH025_M.A201701.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201612.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201611.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201610.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201609.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201608.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201607.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201606.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201605.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201604.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201603.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201602.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2016/GLDAS_NOAH025_M.A201601.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201512.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201511.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201510.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201509.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201508.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201507.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201506.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201505.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201504.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201503.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201502.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2015/GLDAS_NOAH025_M.A201501.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201412.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201411.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201410.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201409.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201408.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201407.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201406.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201405.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201404.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201403.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201402.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2014/GLDAS_NOAH025_M.A201401.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201312.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201311.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201310.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201309.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201308.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201307.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201306.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201305.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201304.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201303.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201302.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2013/GLDAS_NOAH025_M.A201301.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201212.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201211.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201210.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201209.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201208.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201207.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201206.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201205.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201204.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201203.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201202.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2012/GLDAS_NOAH025_M.A201201.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201112.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201111.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201110.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201109.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201108.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201107.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201106.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201105.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201104.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201103.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201102.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2011/GLDAS_NOAH025_M.A201101.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201012.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201011.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201010.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201009.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201008.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201007.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201006.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201005.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201004.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201003.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201002.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2010/GLDAS_NOAH025_M.A201001.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200912.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200911.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200910.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200909.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200908.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200907.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200906.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200905.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200904.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200903.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200902.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2009/GLDAS_NOAH025_M.A200901.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200812.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200811.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200810.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200809.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200808.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200807.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200806.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200805.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200804.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200803.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200802.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2008/GLDAS_NOAH025_M.A200801.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200712.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200711.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200710.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200709.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200708.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200707.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200706.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200705.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200704.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200703.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200702.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2007/GLDAS_NOAH025_M.A200701.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200612.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200611.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200610.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200609.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200608.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200607.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200606.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200605.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200604.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200603.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200602.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2006/GLDAS_NOAH025_M.A200601.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200512.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200511.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200510.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200509.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200508.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200507.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200506.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200505.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200504.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200503.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200502.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2005/GLDAS_NOAH025_M.A200501.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200412.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200411.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200410.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200409.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200408.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200407.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200406.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200405.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200404.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200403.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200402.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2004/GLDAS_NOAH025_M.A200401.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200312.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200311.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200310.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200309.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200308.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200307.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200306.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200305.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200304.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200303.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200302.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2003/GLDAS_NOAH025_M.A200301.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200212.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200211.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200210.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200209.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200208.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200207.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200206.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200205.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200204.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200203.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200202.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2002/GLDAS_NOAH025_M.A200201.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200112.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200111.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200110.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200109.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200108.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200107.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200106.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200105.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200104.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200103.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200102.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2001/GLDAS_NOAH025_M.A200101.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200012.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200011.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200010.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200009.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200008.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200007.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200006.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200005.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200004.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200003.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200002.021.nc4
https://data.gesdisc.earthdata.nasa.gov/data/GLDAS/GLDAS_NOAH025_M.2.1/2000/GLDAS_NOAH025_M.A200001.021.nc4
EDSCEOF
