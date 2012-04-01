#! /usr/bin/env sh
#
# updateѕ the version string of an application cache manifest.
#
# The version string must have this syntax:
#
#    > # v<number>
#
# Usage:
#   ./updateCacheManifest.sh

# manifest file
MANIFEST="foobar.manifest";

update () {

    local count=$(grep "# v" "${MANIFEST}" | sed 's/# v//g');
    local newcount=$((count + 1))

    sed -i -e"s/# v${count}/# v${newcount}/" "${MANIFEST}";
}

update;

exit;
