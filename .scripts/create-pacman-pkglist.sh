#!/bin/sh

# Simply creates a package list at $HOME as `pkglist.txt`

pkglist=$(pacman -Qqne)
pkglist_filepath="$HOME/pkglist.txt"

if [[  -f $pkglist_filepath ]]; then 
    rm "$pkglist_filepath"
fi

touch $pkglist_filepath

echo "$pkglist" >> $pkglist_filepath

