#! /usr/bin/env sh
#
# adds a X mode for HP2229h und switches the output.
#
# Usage:
#   ./hp2229h.sh extern|laptop

if [ -z "$1" ]; then
    echo "Usage: ./hp2229h.sh extern|laptop"
    exit 1;
fi;

# add the mode for HP2229h
#
init () {

    xrandr --newmode "1680x1050_60.00"  147.14  1680 1784 1968 2256  1050 1051 1054 1087 -HSync +Vsync
    xrandr --addmode VGA1 1680x1050_60.00
}

# switch to HP2229h
#
extern () {

    xrandr --output VGA1 --mode 1680x1050_60.00 --output LVDS1 --off
}

# switch to LVDS
#
laptop () {

    xrandr --output VGA1 --off --output LVDS1 --auto
}

case "$1" in
    "extern")
        init;
        extern;
        ;;
    "laptop")
        laptop;
        ;;
esac;
