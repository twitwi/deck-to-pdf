#!/bin/bash

/etc/init.d/cups start

function pdf--smaller() {
    if test $# -gt 1 ; then
        local mode
        mode=/ebook
        test $# -gt 2 && mode=/$3
        gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=$mode -dUseCIEColor=true -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$2" "$1"
        du -sh "$2" "$1"
        #/printer
        #/ebook
        #/screen
    else
        echo "expects 2/3 parameters: in out [mode]. mode is in printer,ebook,screen (default ebook)"
    fi
}

url="$1"
_url="$1"
shift
out="$1"
_out="$1"
shift

if test -d "/custom-data"; then
    if test -f "/custom-data/$url"; then
        url=$(readlink -f "/custom-data/$url")
    fi
    out="/custom-data/$out"
    # customize defaults
    sed -i -e 's@1280x720@801x601@g' -e 's@default: 1000,@default: 250,@g' decktape.js
fi

# Actually run decktape
export CUPS_SERVER=
xvfb-run ../slimerjs-master/src/slimerjs decktape.js "$url" "$out" "$@" | tee logs
cat logs | grep 'DO: ' | sed 's@.*DO: @@g' | bash
ls "$out"

# do post-processing to improve pdf size and have a 6-slide version
(cd $(dirname "$out") && pdfjam-slides6up --pdfauthor 'Rémi Emonet' --frame true --suffix 2x3 --paper a4paper --no-landscape "$out")

pdf--smaller "$out" "${out%.pdf}-smaller.pdf"
pdf--smaller "${out%.pdf}-2x3.pdf" "${out%.pdf}-2x3-smaller.pdf"
#du -sh "$out" "${out%.pdf}-2x3.pdf" "${out%.pdf}-smaller.pdf" "${out%.pdf}-2x3-smaller.pdf"

cd /custom-data && chown $(stat -c '%u:%g' .) "$out" "${out%.pdf}-2x3.pdf" "${out%.pdf}-smaller.pdf" "${out%.pdf}-2x3-smaller.pdf"
