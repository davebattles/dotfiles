#! /bin/bash

# parse arguments
count=${1}
shift


# set user agent, customize this by visiting http://whatsmyuseragent.com/
useragent='Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:31.0) Gecko/20100101 Firefox/31.0'

# construct google link
#link="www.google.com/search?q=${query}\&tbm=isch"  #ORIGINAL SEARCH QUERY

artist=$(mpc current --format %artist%)
album=$(mpc current --format %album%)
mpccurrent="$artist-$album"

link="www.google.com/search?q={${mpccurrent})\&tbm=isch"

# fetch link for download
imagelink=$(wget -e robots=off --user-agent "$useragent" -qO - "$link" | sed 's/</\n</g' | grep '<a href.*\(png\|jpg\|jpeg\)' | sed 's/.*imgurl=\([^&]*\)\&.*/\1/' | head -n $count | tail -n1)
imagelink="${imagelink%\%*}"

# get file extention (.png, .jpg, .jpeg)
ext=$(echo $imagelink | sed "s/.*\(\.[^\.]*\)$/\1/")

# set default save location and file name change this!!
dir="$PWD"
file="${mpccurrent}"

   

# construct image link: add 'echo "${google_image}"'
# after this line for debug output
google_image="${dir}/${file}"


# construct name, append number if file exists
# if [[ -e "${google_image}${ext}" ]] ; then
#    i=0
#    while [[ -e "${google_image}(${i})${ext}" ]] ; do
#        ((i++))
#    done
#    google_image="${google_image}(${i})${ext}"
#else
    google_image="${google_image}.jpg"  # ONLY, it rewrites the image
#fi

# get actual picture and store in google_image.$ext
wget --max-redirect 0 -qO "${google_image}" "${imagelink}"


# successful execution, exit code 0
mpc update
mpc update
mpc update

exit 0
