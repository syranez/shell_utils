#! /usr/bin/env sh
#
# downloads the latest picture of a reddpics subreddit
#
# Usage:
#   ./latestRedditpic.sh

# Uri of the site of which you want to download pictures
URI="http://api.flickr.com/services/feeds/photos_public.gne"

# Path to write the latest file
OUTPUT="/tmp/latest.jpg";

# retrieves the local uri of the latest picture
#
# @outputs local uri of latest picture
getUriLatestPicture () {

    local latest=$(wget -q "${URI}" -O - | tr ">" "\n" | grep '<link rel="enclosure"' | sed 's/.*href="//g' | sed 's/".*//g' | head -n 1);

    echo "${latest}"
}

# gets an image from an uri
#
# @param string uri
# @writes /tmp/latest.jpg
get () {

    local uri="${1}";

    wget -q "${uri}" -O ${OUTPUT};

    return $?;
}

latest=$(getUriLatestPicture);

get "${latest}";

exit $?;
