#! /usr/bin/env bash
#
# gets a mp3 file from musicstream.cc
#
# Every music file on musicstream.cc has an id∴
#+  e.g.  "http://www.musicstream.cc/index.php?action=playwinfile&id=2904" => id = 2904
#+
#+ Now use that id as first param to this script:
#+    ./musicstream 2904
#+ and you will get that file.
#
# Have fun.
#

if [[ ! $# -eq 1 ]]; then
    echo "Usage ./musicstream.sh <id>";
    exit 1;
fi

# id of music file
ID=${1};

# outputs the domain of musicstream
#
# @access public
# @output string
# @final
getMusicstreamHost () {

    echo "http://www.musicstream.cc";
}

# get uri of the xml file that describes the music file
#
# @param string Id of music file
# @output uri
# @access private
# @final
getXmlUri () {

    local id="${1}";
    local host=$(getMusicstreamHost);
    local htmlUri="${host}/index.php?action=playwinfile&id=${id}";

    local xmlUri=$(wget -q "${htmlUri}" -O - | grep "templist" | grep "xml" | sed 's/.*file=%2F//g' | sed 's/xml.*//g');

    echo "${xmlUri}";
}

# decodes url encoded characters.
#
# @param string encoded uri
# @output decoded uri
# @access private
# @final
decodeUriComponent () {

    echo $(echo ${1} | sed 's/%3F/\?/g' | sed 's/%3D/\=/g' | sed 's/%26/\&/g')
}

# retrieves the xml file describing a music file.
#
# @param string uri to xml file
# @side XML contains xml file
# @access public
# @final
getXml () {

    local file="${1}";
    local host=$(getMusicstreamHost);
    local htmlUri="${host}/${file}";

    XML=$(wget -q "${htmlUri}" -O -);
}

# outputs the uri to the mp3 file
#
# @access public
# @output uri to mp3 file
# @final
getMp3Uri () {

    local mp3Uri=$(echo "${XML}" | grep "location" | sed 's/.*<location>//g' | sed 's#</location>.*##g')
    echo "${mp3Uri}";
}

# outputs the title of the mp3 file
#
# @access public
# @output tile of mp3 file
# @final
getMp3Title () {

    local title=$(echo "${XML}" | grep "title" | sed 's/.*<title>//g' | sed 's#</title>.*##g')
    echo "${title}"
}

getXml $(decodeUriComponent $(getXmlUri ${ID}));

mp3Uri=$(getMp3Uri);
mp3Title=$(getMp3Title);

wget "${mp3Uri}" -O "${mp3Title}.mp3"
