#! /usr/bin/env sh
#
# downloads the latest picture of a reddpics subreddit
#
# Usage:
#   ./latestRedditpic.sh

# Subreddit
SUB="funny"

# Base URI of reddpics
BASE="http://reddpics.com"

# Uri of the site of which you want to download pictures
URI="${BASE}/r/${SUB}/"

# Path to write the latest file
OUTPUT="/tmp/latest.jpg";

# retrieves the local uri of the latest picture
#
# @outputs local uri of latest picture
getUriLatestPicture () {

    local latest=$(wget -q "${URI}" -O - | tr ">" "\n" | grep '<img src="/' | sed 's/.*src="//g' | sed 's/".*//g' | head -n 1);

    echo "${BASE}${latest}";
}

# gets an image from an uri
#
# @param string uri
# @writes /tmp/latest.jpg
get () {

    local uri="${1}";

    wget -q "${uri}" -O ${OUTPUT};
}

latest=$(getUriLatestPicture);

get "${latest}";

exit;
