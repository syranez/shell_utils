#!/bin/bash
#
# finds sticky tags in a cvs directory tree
#
# Usage: ./findStickys.sh "$DIR"

set +x

if [ -z $1 ]; then
    echo 'Usage: ./findStickys.sh "$DIR"';
    exit 1;
fi;

# directory to check
FS_DIRECTORY=$1;

# Enthält alle CVS-Verzeichnisse eines unter CVS versionierten Verzeichnisbaumes
#+ @var array
declare -a FS_CVSDIRS;

# findet alle CVS-Verzeichnisse in einem Verzeichnis.
#+ @param Verzeichnis in dem alle CVS-Verzeichnisse entdeckt werden sollen.
findCvsDirs () {

   local i=0;

   if [ -z $1 ]; then
       echo "findCvsDirs: Kein Verzeichnisparameter vorhanden.";
       exit 1;
   fi

   local path=$1;

   for f in $(find $path -type d -name 'CVS'); do
       FS_CVSDIRS[$i]="$f";
       i=$((i+1));
   done;
}

# prüft die CVS-Entries-Datei nach vorhandenen Stickytags
#+ @param Pfad zum CVS-Verzeichnis
checkCvsData () {

   if [ -z $1 ]; then
       echo "checkCvsData: Kein Verzeichnisparameter vorhanden.";
       exit 1;
   fi

   local i="0";
   local path=$1;
   local length=$((${#path} - 4))
   local lines=$(wc -l "$path/Entries" | awk '{print $1}');

   lines=$((lines +1))

   # for every line in the Entriesfile
   for ((i=1; i < $lines; i++)); do 
        local tag=$(getStickyTag $i $path"/Entries");
        local file=$(getFile $i $path"/Entries");

        if [ ! ${#tag} -eq 0 ]; then
            echo "#omg Sticky Tag $tag on file ${path:0:length}/$file";
        fi;
   done;
}

# parses an Entry in a CVS/Entries files and prints the sticky tag marker
#+ @param line
#+ @param path to entry file
#+ @prints sticky tag marker
getStickyTag () {

    printf "%s" $(sed -n "$1p" "$2" | awk 'BEGIN{FS="/"}{print $6}');
}

# parses an Entry in a CVS/Entries files and prints the file name
#+ @param line
#+ @param path to entry file
#+ @prints file name
getFile () {

    printf "%s" $(sed -n "$1p" "$2" | awk 'BEGIN{FS="/"}{print $2}');
}

findCvsDirs "$FS_DIRECTORY";

for ((i=0; i < ${#FS_CVSDIRS[*]}; i++)); do
    checkCvsData "${FS_CVSDIRS[$i]}";
done;

exit 0;
