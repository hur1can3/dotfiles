#!/bin/bash
#===================================================================================
#         FILE: bash_functions
#  DESCRIPTION: collection of useful bash functions
# REQUIREMENTS: bash
#       AUTHOR: Matthew Levandowski <levandowski.matthew@gmail.com>
#      VERSION: 2.0
#      CREATED: 12.05.2009 
#     REVISION: 04.02.2013
#===================================================================================

## Template

#===================================================================================   
#         NAME: command
#        USAGE: command [parameter]
#      RETURNS: file operated on
#  DESCRIPTION: does something useful
# REQUIREMENTS: command1 command2
#       AUTHOR: Unknown
#     REVISION: 04.02.2013
#===================================================================================

## Functions

#===================================================================================   
#         NAME: extract
#        USAGE: extract [filename]
#      RETURNS: unzipped folder [filename]
#  DESCRIPTION: extract most popular compressed file formats
# REQUIREMENTS: tar bunzip2 gunzip unrar unzipzip 7z uncompress
#       AUTHOR: Unknown
#     REVISION: 04.02.2013
#===================================================================================
extract () {
	if [ -f "$1" ] ; then
		for i in "$@"
		do
			case "$i" in
				*.tar.bz2)	tar xvjf "$i"	;;
				*.tar.gz)		tar xvzf "$i"	;;
				*.bz2)		bunzip2 "$i"	;;
				*.rar)		unrar x "$i"	;;
				*.gz)		gunzip "$i"	;;
				*.tar)		tar xvf "$i"	;;
				*.tbz2)		tar xvjf "$i"	;;
				*.tgz)		tar xvzf "$i"	;;
				*.zip)		unzip "$i"	;;
				*.Z)		uncompress "$i"	;;
				*.7z)		7z x "$i"		;;
				*)		echo "'$i' cannot be extracted via >extract<" ;;
			esac
		done
	else
		echo "'$i' is not a valid file"
	fi
}

#===================================================================================  
#         NAME: goto
#        USAGE: goto [directory]
#      RETURNS: ---
#  DESCRIPTION: follow copied and moved files to destination directory
# REQUIREMENTS: cd
#       AUTHOR: ---
#     REVISION: 04.02.2013
#===================================================================================
goto() { 
    [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; 
}

#===================================================================================
#         NAME: cpf
#        USAGE: cpf [filename(s)]
#      RETURNS: ---
#  DESCRIPTION: copies file(s) and then follows to files destination
# REQUIREMENTS: cp
#       AUTHOR: ---
#     REVISION: 04.02.2013
#===================================================================================
cpf() { 
    cp "$@" && goto "$_"; 
}

#=================================================================================== 
#         NAME: mvf
#        USAGE: cpf [filename(s)]
#      RETURNS: ---
#  DESCRIPTION: moves file(s) and then follows to destination
# REQUIREMENTS: mv
#       AUTHOR: ---
#     REVISION: 04.02.2013
#===================================================================================
mvf() { 
    mv "$@" && goto "$_"; 
}

#=================================================================================== 
#         NAME: togglecpu
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: toggles between a performance profile and ondemand for cpu 
#               frequency scaling
# REQUIREMENTS: cpufreq
#       AUTHOR: ---
#     REVISION: 04.02.2013
#===================================================================================
function togglecpu () {
    [ "$(cpufreq-info | grep \"ondemand\")" ] && \
    sudo cpufreq-set -g performance || \
    sudo cpufreq-set -g ondemand ; 
}

#=================================================================================== 
#         NAME: dirsize
#        USAGE: dirsize [directory]
#      RETURNS: ---
#  DESCRIPTION: gets the size of a directory
# REQUIREMENTS: ---
#       AUTHOR: ---
#     REVISION: 04.02.2013
#===================================================================================
dirsize ()
{
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
    egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm /tmp/list
}

#===================================================================================   
#         NAME: wiki
#        USAGE: wiki [input query]
#      RETURNS: ---
#  DESCRIPTION: queries wikipedia with input text
# REQUIREMENTS: dig
#       AUTHOR: Unknown
#     REVISION: 04.02.2013
#===================================================================================
wiki() { 
    dig +short txt $1.wp.dg.cx; 
}

#===================================================================================   
#         NAME: manp
#        USAGE: manp [command]
#      RETURNS: ---
#  DESCRIPTION: prints a man page using lpr
# REQUIREMENTS: lpr
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
manp() { 
    man -t "$@" | lpr -pPrinter; 
}

#===================================================================================   
#         NAME: manpdf
#        USAGE: manpdf [command]
#      RETURNS: [command].pdf
#  DESCRIPTION: creates a pdf version of man page
# REQUIREMENTS: ghostscript perl-file-mimeinfo
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
manpdf () { 
    man -t "$@" | ps2pdf - /tmp/manpdf_$1.pdf && xdg-open /tmp/manpdf_$1.pdf ;
}


#===================================================================================   
#         NAME: send
#        USAGE: send [host1] [srcfile] [destfile]
#      RETURNS: ---
#  DESCRIPTION: shortcut for transferring files via scp
# REQUIREMENTS: scp
#       AUTHOR: unknown
#     REVISION: 04.02.2013
#===================================================================================
send () {	
	if [ ! -z "$1" ] && [ -e "$2" ]; then
		LOC="$1"
		shift
		case "$LOC" in
			host1)	scp -r "$@" 192.168.x.x:~/	;;
			host2)	scp -r "$@" 192.168.x.y:~/	;;
		esac
	fi
}

#===================================================================================   
#         NAME: albumart
#        USAGE: albumart [album_name]
#      RETURNS: [album_name].jpg
#  DESCRIPTION: grabs the album art for an album from albumart.org
# REQUIREMENTS: awk
#       AUTHOR: unknown
#     REVISION: 04.02.2013
#===================================================================================
albumart(){ 
    local y="$@";awk '/View larger image/{gsub(/^.*largeImagePopup\(.|., .*$/,"");print;exit}' <(curl -s 'http://www.albumart.org/index.php?srchkey='${y// /+}'&itempage=1&newsearch=1&searchindex=Music'); 
}

#===================================================================================   
#         NAME: sfm
#        USAGE: sfm [artist_name]
#      RETURNS: ---
#  DESCRIPTION: plays a similar artist stream for last.fm with shell-fm
# REQUIREMENTS: shell-fm
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
sfm ()
{
    shell-fm -d -i 127.0.0.1 lastfm://artist/$1/similartists
}	


#===================================================================================   
#         NAME: ipa
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: prints the IP Addresses of each attached networking device
# REQUIREMENTS: ifconfig grep
#       AUTHOR: unknown
#     REVISION: 04.02.2013
#===================================================================================
ipa () {
	TMP=`ifconfig eth0 | grep "inet "`
	if [ -n "$TMP" ]; then
		echo -n "eth0 IP:"
		ifconfig eth0 | grep "inet " | cut -d: -f2- | cut -d" " -f1
	fi
	TMP=`ifconfig eth1 | grep "inet "`
	if [ -n "$TMP" ]; then
		echo -n "eth1 IP:"
		ifconfig eth1 | grep "inet " | cut -d: -f2- | cut -d" " -f1
	fi
	TMP=`ifconfig eth2 | grep "inet "`
	if [ -n "$TMP" ]; then
		echo -n "eth2 IP:"
		ifconfig eth2 | grep "inet " | cut -d: -f2- | cut -d" " -f1
	fi
}

#===================================================================================   
#         NAME: or
#        USAGE: or [filename]
#      RETURNS: [filename].orig
#  DESCRIPTION: makes backups of original files
# REQUIREMENTS: cp
#       AUTHOR: unknown
#     REVISION: 04.02.2013
#===================================================================================
or () {
	if [ -e "$@" ]; then
		for i in "$@"
		do
			cp "$i" "$i".orig
		done
	fi
}

#===================================================================================   
#         NAME: lowercase
#        USAGE: lowercase [files]
#      RETURNS: ---
#  DESCRIPTION: moves a file or files to lowercase letters 
# REQUIREMENTS: mv
#       AUTHOR: unknown
#     REVISION: 04.02.2013
#===================================================================================
lowercase() {
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}


#===================================================================================   
#         NAME: ii
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: get current host related information
# REQUIREMENTS: date uptime uname free
#       AUTHOR: unknown
#     REVISION: 04.02.2013
#===================================================================================
ii(){
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    my_ip 2>&- ;
    echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
    echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
    echo -e "\n${RED}Open connections :$NC "; netstat -pan --inet;
    echo
}

#===================================================================================   
#         NAME: tarbz2d
#        USAGE: tarbz2d [dirname]
#      RETURNS: [date]-[dirname].tar.bz2
#  DESCRIPTION: tarballs and bzip2 a directory
# REQUIREMENTS: tar bzip
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
tarbz2d(){ 
    if [ "$1" != "" ]; then
        FOLDER_IN=`echo $1 |sed -e 's/\/$//'`;
        FILE_OUT="$(date +%Y%m%d)-$FOLDER_IN.tar.bz2";
        FOLDER_IN="$FOLDER_IN/";
        echo "Compressing $FOLDER_IN into $FILE_OUT…";
        echo "tar cjf $FILE_OUT $FOLDER_IN";
        tar cjvf "$FILE_OUT" "$FOLDER_IN";
        echo "Done.";
    fi
}

#===================================================================================   
#         NAME: targzd
#        USAGE: targzd [dirname]
#      RETURNS: [date]-[dirname].tar.gz
#  DESCRIPTION: tarballs and gzips a directory
# REQUIREMENTS: tar gzip
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
targzd(){ 
    if [ "$1" != "" ]; then
        FOLDER_IN=`echo $1 |sed -e 's/\/$//'`;
        FILE_OUT="$(date +%Y%m%d)-$FOLDER_IN.tar.gz";
        FOLDER_IN="$FOLDER_IN/";
        echo "Compressing $FOLDER_IN into $FILE_OUT…";
        echo "tar czf $FILE_OUT $FOLDER_IN";
        tar czvf "$FILE_OUT" "$FOLDER_IN";
        echo "Done.";
    fi
}

#===================================================================================   
#         NAME: ltex
#        USAGE: ltex [filename]
#      RETURNS: [filename].dvi [filename].ps [filename].pdf
#  DESCRIPTION: convert a latex source file .tex into dvi, ps, pdf, txt files
# REQUIREMENTS: latex bibtex ps2pdf
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
ltex(){
    if [ "$1" == "" ]; then
        FILE="paper";
    else
        FILE=`echo $1 | sed -e 's/..*//'`;
    fi
    if [ -f $FILE.tex ]; then
        latex $FILE.tex;
        bibtex $FILE.aux;
        makeindex $FILE;
        latex $FILE.tex;
        bibtex $FILE.aux;
        makeindex $FILE;
        latex $FILE.tex && dvipdf $FILE.dvi;
        latex $FILE.tex && dvips -Ppdf -G0 $FILE.dvi -o $FILE.ps && ps2pdf14 $FILE.ps;
        catdvi -e 1 -U $FILE.dvi | sed -re "s/\[U\+2022\]/*/g" | sed -re "s/([^^[:space:]])\s+/\1 /g" > $FILE.txt;
    fi
}


#===================================================================================   
#         NAME: defineold
#        USAGE: defineold [search]
#      RETURNS: ---
#  DESCRIPTION: define a word with google using lynx grep and sed
# REQUIREMENTS: lynx sed grep
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
defineold () {
    lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${1}&btnG=Google+Search" | grep -m 3 -w "*"  | sed 's/;/ -/g' | cut -d- -f1 > /tmp/templookup.txt
    if [[ -s  /tmp/templookup.txt ]] ;then    
        until ! read response
            do
            echo "${response}"
            done < /tmp/templookup.txt
        else
            echo "Sorry $USER, I can't find the term \"${1} \""                
    fi    
    rm -f /tmp/templookup.txt
}

#===================================================================================   
#         NAME: define
#        USAGE: define [search]
#      RETURNS: ---
#  DESCRIPTION: define a word using google and busybox
# REQUIREMENTS: wget busybox sed
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
define ()
{
	wget -q -U busybox -O- "http://www.google.com/search?ie=UTF8&q=define%3A$1" | tr '<' '\n' | sed -n 's/^li>\(.*\)/\1\n/p'

}

#===================================================================================   
#         NAME: definesay
#        USAGE: definesay [search]
#      RETURNS: ---
#  DESCRIPTION: defines a word or phrase using goole and busybox then speaks it with 
#               espeak and sox
# REQUIREMENTS: espeak sox wget busybox sed
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
definesay ()
{
	wget -q -U busybox -O- "http://www.google.com/search?ie=UTF8&q=define%3A$1" | tr '<' '\n' | sed -n 's/^li>\(.*\)/\1\n/p' > /tmp/templookup.txt
	if [[ -s /tmp/templookup.txt ]] ;then
		until ! read response
		do
			echo "${response}"
			espeak -v en/en -s 150 -g 0 -k20 -p 0 -l 100 "${response}" --stdout  | play -V1 -q -t wav -
		done < /tmp/templookup.txt
	else
		echo "Sorry $USER, I cannot find the search term \"${1} \""
	fi
	rm -f /tmp/templookup.txt
}	# ----------  end of function definesay  ----------


#===================================================================================   
#         NAME: dsb
#        USAGE: dsb [search]
#      RETURNS: ---
#  DESCRIPTION: the same as the definesay function except it uses bing as the
#               search engine backend.
# REQUIREMENTS: lynx grep sed espeak play
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
dsb() {
    lynx -dump "http://www.bing.com/search?q=define%3A+${1}&go=&form=QBRE&qs=n&sc=8-11" | grep -m 3 -w "Definition"  | sed 's/;/ -/g' | cut -d- -f1 > /tmp/templookup.txt
        if [[ -s  /tmp/templookup.txt ]] ;then    
            until ! read response
                do
                echo "${response}"
                espeak -v en/en -s 150 -g 0 -k20 -p 0 -l 100 "${response}" --stdout  | play -V1 -q -t wav -
                done < /tmp/templookup.txt
            else
                echo "Sorry $USER, I can't find the term \"${1} \""                
        fi    
    rm -f /tmp/templookup.txt
}
	
#===================================================================================   
#         NAME: calc
#        USAGE: calc [formula]
#      RETURNS: ---
#  DESCRIPTION: calculates stuff on commandline
# REQUIREMENTS: bc
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
calc(){ 
    echo "$*" | bc; 
}

#===================================================================================   
#         NAME: pjet
#        USAGE: pjet [file]
#      RETURNS: ---
#  DESCRIPTION: pretty-print using enscript
# REQUIREMENTS: enscript
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
pjet(){ 
    enscript -h -G -fCourier9 "$1"; 
}

#===================================================================================   
#         NAME: copy
#        USAGE: copy [files]
#      RETURNS: ---
#  DESCRIPTION: copy with a progress bar
# REQUIREMENTS: cp watch cut du
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
copy(){ 
    cp -v "$1" "$2"&watch -n 1 'du -h "$1" "$2";printf "%s%%\n" $(echo `du -h "$2"|cut -dG -f1`/0.`du -h "$1"|cut -dG -f1`|bc)'; 
}

#===================================================================================   
#         NAME: ff
#        USAGE: ff [pattern]
#      RETURNS: ---
#  DESCRIPTION: find a file with a [pattern] in name
# REQUIREMENTS: find ls
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
ff(){ 
    find . -type f -iname '*'$*'*' -ls ; 
}

#===================================================================================   
#         NAME: fe
#        USAGE: fe [pattern] [command]
#      RETURNS: ---
#  DESCRIPTION: find a file with [pattern] in name and Execute [command] on it
# REQUIREMENTS: find exec
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
fe(){ 
    find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; 
}

#===================================================================================   
#         NAME: count
#        USAGE: count [files]
#      RETURNS: ---
#  DESCRIPTION: recursively counts number of lines of all [files] 
# REQUIREMENTS: find cat
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
count() { 
    find $@ -type f -exec cat {} + | wc -l; 
}

#===================================================================================   
#         NAME: mcd
#        USAGE: mcd [file]
#      RETURNS: ---
#  DESCRIPTION: combine mkdir [file] && cd [file] into a single function
# REQUIREMENTS: mkdir cd
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
mcd() { 
    [ -n "$1" ] && mkdir -p "$@" && cd "$1"; 
}

#===================================================================================   
#         NAME: dh
#        USAGE: dh [dir]
#      RETURNS: ---
#  DESCRIPTION: sort the size usage of a directory tree by gigabytes, kilobytes, 
#               megabytes, then bytes.
# REQUIREMENTS: du sort
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
dh() { 
    du -ch --max-depth=1 "${@-.}"|sort -n ;
}

#===================================================================================   
#         NAME: say
#        USAGE: say [phrase]
#      RETURNS: ---
#  DESCRIPTION: use espeak to say a word or phrase
# REQUIREMENTS: espeak play
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
say() { 
    espeak -v en/en -s 150 -g 0 -k20 -p 0 -l 100 "$1" --stdout | play -V1 -q -t wav -;
}

#===================================================================================   
#         NAME: rsay
#        USAGE: rsay [file]
#      RETURNS: ---
#  DESCRIPTION: use espeak to say contents of file
# REQUIREMENTS: espeak play
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
rsay() { 
    espeak -f "$1" --stdout | play -V1 -q -t wav -;
}

#===================================================================================   
#         NAME: genpass
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: psuedo-random password generator
# REQUIREMENTS: ---
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
genpass(){ 
    local i x y z h;h=${1:-8};x=({a..z} {A..Z} {0..9});for ((i=0;i<$h;i++));do y=${x[$((RANDOM%${#x[@]}))]};z=$z$y;done;echo $z ; 
}

#===================================================================================   
#         NAME: geoip
#        USAGE: geoip [ip address] ie 192.168.0.1
#      RETURNS: ---
#  DESCRIPTION: looks up an ip address and retrieve geological info
# REQUIREMENTS: curl sed
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
geoip(){ 
    curl -s "http://www.geody.com/geoip.php?ip=${1}" | sed '/^IP:/!d;s/<[^>][^>]*>//g' ; 
}

#===================================================================================   
#         NAME: geoipalt
#        USAGE: geoipalt [ip address] ie 192.168.0.1
#      RETURNS: ---
#  DESCRIPTION: looks up an ip address and retrieve geological info (alternative)
# REQUIREMENTS: curl grep html2text
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
geoipalt() { 
    curl -A "Mozilla/5.0" -s "http://www.geody.com/geoip.php?ip=$1" | grep "^IP.*$1" | html2text; 
}
	 
#===================================================================================   
#         NAME: structcp
#        USAGE: structcp [dir]
#      RETURNS: ---
#  DESCRIPTION: copy entire folder structure
# REQUIREMENTS: mkdir find cp
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
structcp() { ( 
    mkdir -pv $2;f="$(realpath "$1")";t="$(realpath "$2")";cd "$f";find * -type d -exec mkdir -pv $t/{} \;); 
}
	 
#===================================================================================   
#         NAME: randpw
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: generate a psuedo-random password with /dev/urandom
# REQUIREMENTS: head
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
randpw() {  
    /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo; 
}
	 
#===================================================================================   
#         NAME: sitepass
#        USAGE: sitepass [website url]
#      RETURNS: ---
#  DESCRIPTION: generate a unique secure password for every [website] that you use
# REQUIREMENTS: md5 sha1 gzip tr cut
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
sitepass() { 
    echo -n "$@" |  md5sum | sha1sum | sha224sum | sha256sum | sha384sum | sha512sum | gzip - | strings -n 1 | tr -d "[:space:]"  | tr -s '[:print:]' | tr '!-~' 'P-~!-O' | rev | cut -b 2-11; history -d $(($HISTCMD-1)); 
}
	 
#===================================================================================   
#         NAME: thumbnail
#        USAGE: thumbnail [file]
#      RETURNS: [file].jpg
#  DESCRIPTION: create a thumbnail for a video file using ffmpeg
# REQUIREMENTS: ffmpeg
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
thumbnail() { 
    ffmpeg  -itsoffset -20 -i $i -vcodec mjpeg -vframes 1 -an -f rawvideo -s 640x272 ${i%.*}.jpg; 
}
	 
#===================================================================================   
#         NAME: tweet
#        USAGE: tweet [username] ["twitter string"]
#      RETURNS: ---
#  DESCRIPTION: update twitter from commandline via curl
# REQUIREMENTS: curl
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
tweet(){ 
    curl -u "$1" -d status="$2" "http://twitter.com/statuses/update.xml"; 
}

#===================================================================================   
#         NAME: backup
#        USAGE: backup [files]
#      RETURNS: [files].[date:YearMonthdDay-HourMinSec]
#  DESCRIPTION: create data backup
# REQUIREMENTS: curl
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
backup() { 
    for i in "$@"; 
    do 
        cp -va $i $i.$(date +%Y%m%d-%H%M%S); 
    done 
}

#===================================================================================   
#         NAME: shred
#        USAGE: shred [file]
#      RETURNS: ---
#  DESCRIPTION: permantly delete a file with 17 rewrites of data
# REQUIREMENTS: ---
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
shred() { 
    shred -u -z -n 17 "$1"; 
}


#===================================================================================   
#         NAME: scptun
#        USAGE: scptun [password] [username] [host] [src file] [destination]
#      RETURNS: ---
#  DESCRIPTION: securely copy files over an ssh tunnel with rsync
# REQUIREMENTS: sshpass rsync ssh
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
scptun() { 
    sshpass -p "$1" rsync -av -e ssh "$2"@"$3":"$4" /"$5"; 
}

#===================================================================================   
#         NAME: tubej
#        USAGE: tubej [file1].avi [file2].avi [output.avi]
#      RETURNS: [output]
#  DESCRIPTION: concatenate two avi files into one youtube friendly file
# REQUIREMENTS: mencoder 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
tubej() { 
    mencoder -audiofile input.mp3 -oac copy -ovc lavc -lavcopts vcodec=mpeg4 -ffourcc xvid -vf scale=320:240,harddup "$1" "$2" -o "$3"; 
}

#===================================================================================   
#         NAME: pdfo
#        USAGE: pdfo [input].pdf [output].pdf
#      RETURNS: [output].pdf
#  DESCRIPTION: optimize a pdf file using ghostscript
# REQUIREMENTS: ghostscript 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
pdfo() { 
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$2" "$1"; 
}

#===================================================================================   
#         NAME: thumbit
#        USAGE: thumbit [file]
#      RETURNS: [file].jpg
#  DESCRIPTION: make a thumb 20% the size of a pic
# REQUIREMENTS: mogrify 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
thumbit() {
  if [ -z $1 ]; then
    echo "please supply a file to shrink"
    return 1 
  fi

  case $1 in
    *.jpg)
      thumb=$(echo "$1" | sed s/.jpg/-thumb.jpg/g)
      cp $1 $thumb
      mogrify -resize 20% $thumb
    ;;
    *.jpeg)
      thumb=$(echo "$1" | sed s/.jpeg/-thumb.jpeg/g)
      cp $1 $thumb
      mogrify -resize 20% $thumb
    ;;
    *.png)
      thumb=$(echo "$1" | sed s/.png/-thumb.png/g)
      cp $1 $thumb
      mogrify -resize 20% $thumb
    ;;
    *)
      echo "Image must be .jpg, .jpeg, or .png"
      return 1
    ;;
  esac
}

#===================================================================================   
#         NAME: grepp
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: grep by paragraph
# REQUIREMENTS: perl 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
grepp() {
    [ $# -ne 2 ] && return 1
    perl -00ne "print if /$1/i" < $2
}


#===================================================================================   
#         NAME: pullout
#        USAGE: pullout [file] [archive]
#      RETURNS: [file]
#  DESCRIPTION: pulls a single file out of a compressed file
# REQUIREMENTS: gunzip bunzip2 unrar unzip 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
pullout() {

    if [ $# -ne 2 ]; then
		echo "need proper arguments:"
		echo "pullout [file] [archive]"
    		return 1
	fi
	if [ -f "$2" ] ; then
		for i in "$@"
		do
			case "$i" in
				*.tar.gz)	gunzip < "$i" | tar -xf - $1  ;;
				*.tar.bz2)	bunzip2 < "$i" |tar -xf - $1  ;;
				*.rar)		unrar x - "$i" - $1           ;;
				*.zip)		unzip "$i" - $1               ;;
				*)		echo "'$i' cannot be extracted via >extract<" ;;
			esac
		done
	else
		echo "'$i' is not a valid archive file"
	fi
}
 

#===================================================================================   
#         NAME: fix
#        USAGE: fix [file]
#      RETURNS: ---
#  DESCRIPTION: recursively fix dir/file permissions on a given directory
# REQUIREMENTS: find chmod 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
fix() {
    if [ -d "$1" ]; then 
        find "$1" -type d -exec chmod 755 {} -type f -exec chmod 644 {} \;
    else
        echo "$1 is not a directory."
    fi
}

#===================================================================================   
#         NAME: sshot
#        USAGE: sshot [destination]
#      RETURNS: [destination]/ss_[date].png
#  DESCRIPTION: takes a timestamped screen shot
# REQUIREMENTS: scrot
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
sshot(){
    local PIC="$1/ss_$(date +%y%m%d%H%M).png"
    scrot -t 20 -cd 3 $PIC
}


#===================================================================================   
#         NAME: ripdvd
#        USAGE: ripdvd [dvd drive] [output file] [vid bitrate] [audio bitrate]
#      RETURNS: [output file].mp4 with [bitrate] (4000) and [audio] (192kb)
#  DESCRIPTION: rips a standard dvd with handbrake into an x264 mp4
# REQUIREMENTS: handbrake
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
ripdvd() {
    handbrake -i $1 -o $2.mp4 -L -U -F -f mp4 -e x264 -b $3 -B $4
}

#===================================================================================   
#         NAME: saveit
#        USAGE: saveit [file]
#      RETURNS: --
#  DESCRIPTION: saves a file to ~/Temp or $HOME/Temp
# REQUIREMENTS: cp
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
saveit() {
    cp $1 $HOME/Temp/$1.saved
}

#===================================================================================   
#         NAME: switchfile
#        USAGE: switchfile [file1] [file2]
#      RETURNS: --
#  DESCRIPTION: switch two files (comes in handy)
# REQUIREMENTS: mv
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
switchfile() {
    mv $1 $1.tmp && mv $2 $1 && mv $1.tmp $2
}

#===================================================================================   
#         NAME: tash
#        USAGE: trash [files]
#      RETURNS: --
#  DESCRIPTION: moves files to trash for later deletion
# REQUIREMENTS: mv touch
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
trash () {
    for i in "$@"
	do
		DIR=`dirname "$i"`
		if [ "$DIR" == "." ]; then
			if [ -e "$i" ]; then
				mv "$i" ~/.local/share/Trash/files
				touch ~/.local/share/Trash/info/"$i".trashinfo
				echo "[Trash Info]" >> ~/.local/share/Trash/info/"$i".trashinfo
				echo "Path=$PWD/$i" >> ~/.local/share/Trash/info/"$i".trashinfo
				DATE=`date "+%Y-%m-%dT%T"`
				echo "DeletionDate=$DATE" >> ~/.local/share/Trash/info/"$i".trashinfo
			else
				echo "$i" does not exist
			fi
		else
			if [ -e "$i" ]; then
				LEN=`dirname "$i" | wc -m`
				echo $LEN
				(( LEN=$LEN + 1 ))
				echo $LEN
				FILE=`echo "$i" | cut -c "$LEN"-`
				mv "$i" ~/.local/share/Trash/files
				cd `dirname "$i"`
				pwd
				touch ~/.local/share/Trash/info/"$FILE".trashinfo
				echo "[Trash Info]" >> ~/.local/share/Trash/info/"$FILE".trashinfo
				echo "Path=$PWD/$FILE" >> ~/.local/share/Trash/info/"$FILE".trashinfo
				DATE=`date "+%Y-%m-%dT%T"`
				echo "DeletionDate=$DATE" >> ~/.local/share/Trash/info/"$FILE".trashinfo
				cd - >> /dev/null
			else
				echo "$i" does not exist
			fi
		fi
	done
}

#===================================================================================   
#         NAME: fixscript
#        USAGE: fixscript [file]
#      RETURNS: --
#  DESCRIPTION: removes control characters from linux typescript or script command
# REQUIREMENTS: cat col
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
fixscript() {
    cat $1 | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > $1-processed
}

#===================================================================================   
#         NAME: kerneldpegraph
#        USAGE: ---
#      RETURNS: --
#  DESCRIPTION: draws a kernel dependancy graph
# REQUIREMENTS: perl
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
kerneldepgraph() {
lsmod | perl -e 'print "digraph \"lsmod\" {";<>;while(<>){@_=split/\s+/; print "\"$_[0]\" -> \"$_\"\n" for split/,/,$_[3]}print "}"' | dot -Tpng | display -
}

#===================================================================================   
#         NAME: iencrypt
#        USAGE: iencrypt [password] [image].png
#      RETURNS: [image].png
#  DESCRIPTION: encrypt sensitive image using password 
# REQUIREMENTS: convert
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
iencrypt() {
    echo "$1" | convert "$2" -encipher - -depth 8 png24:hidden.png
}

#===================================================================================   
#         NAME: idecrypt
#        USAGE: idecrypt [password] [image]
#      RETURNS: [image].png
#  DESCRIPTION: decrypt sensitive image using password 
# REQUIREMENTS: convert
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
idecrypt() {
    echo "$1" | convert "$2" -decipher - sensitive.png
}

#===================================================================================   
#         NAME: waterfall
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: make some powerful pink noise that sounds like waterfall
# REQUIREMENTS: play
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
waterfall() {
    play -c 2 -n synth pinknoise band -n 2500 4000 tremolo 0.03 5 reverb 20 gain -l 6
}

#===================================================================================   
#         NAME: listssh
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: list all open ssh connections
# REQUIREMENTS: netstat grep awk sed
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
listssh() {
    netstat -atn | grep :22 | grep ESTABLISHED | awk '{print $4}' | sed 's/:22//'
}

#===================================================================================   
#         NAME: gencommit
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: generate a random and/or funny commit messag
# REQUIREMENTS: curl grep cut
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
gencommit() {
    curl -s 'http://whatthecommit.com/' | grep '<p>' | cut -c4-
}

#===================================================================================   
#         NAME: gitbranches
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: show git branches by date - useful for showing active branches
# REQUIREMENTS: git sed
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
gitbranches() {
    for k in `git branch|sed s/^..//`;do echo -e `git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" "$k" --`\\t"$k";done|sort
}

#===================================================================================   
#         NAME: gitzip
#        USAGE: gitzip [files]
#      RETURNS: ---
#  DESCRIPTION: zip a folder while ignoring git files and copying it to dropbox
# REQUIREMENTS: git gzip dropbox
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
gitzip() {
    git archive HEAD | gzip > ~/Dropbox/archive.tar.gz
}

#===================================================================================   
#         NAME: gitstart
#        USAGE: gitstart [name]
#      RETURNS: ---
#  DESCRIPTION: start a git repository in folder
# REQUIREMENTS: git 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
gitstart () { if ! [[ -d "$@" ]]; then mkdir -p "$@" && cd "$@" && git init; else cd "$@" && git init; fi }

#===================================================================================   
#         NAME: whichpkg
#        USAGE: whichpkg [file]
#      RETURNS: ---
#  DESCRIPTION: find out what debian package a file belongs to
# REQUIREMENTS: readlink dpkg xargs 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
whichpkg() { readlink -f "$(which $1)" | xargs --no-run-if-empty dpkg -S; }

#===================================================================================   
#         NAME: genplasma
#        USAGE: ---
#      RETURNS: background.png
#  DESCRIPTION: generate a plasma-like wallpaper image
# REQUIREMENTS: convert 
#       AUTHOR: unkown
#     REVISION: 04.02.2013
#===================================================================================
genplasma() {
    convert -size 1280x720 plasma:fractal -blur 0x5 -emboss 2 background.png
}

#===================================================================================   
#         NAME: ddbackup
#        USAGE: ddbackup [/dev/device] [filename]
#      RETURNS: [filename].img.gz
#  DESCRIPTION: backs up a block device using dd and compress it
# REQUIREMENTS: dd gzip pv
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
ddbackup() {
    BLOCKSIZE='sudo blockdev --getsize64 $1' 
    sudo dd if=$1 bs=4096 | pv -s $BLOCKSIZE | gzip -9 > $2.img.gz
}

#BLOCKSIZE='sudo blockdev --getsize64 /dev/sdc'
#sudo dd if=/dev/sdc bs=4096 | pv -s $BLOCKSIZE | sudo dd bs=4096 of=~/USB_BLACK_BACKUP.IMG

#===================================================================================   
#         NAME: ddrestore
#        USAGE: ddrestore [filename] [/dev/device] 
#      RETURNS: ---
#  DESCRIPTION: restores a dd backup to a block device
# REQUIREMENTS: dd gunzip pv
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
ddrestore() {
    FILESIZE=`ls -l $1 | awk '{print $5}'`
    sudo gunzip -c $1 | pv -s $FILESIZE | sudo dd of=$2 bs=4096 
}

#===================================================================================   
#         NAME: bconv
#        USAGE: bconv [file]
#      RETURNS: qemu-img
#  DESCRIPTION: unzips and converts an img to a qemu img
# REQUIREMENTS: gunzip qemu
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
bconv() {
    sudo gunzip -c $1 | qemu-img convert -f raw -O qcow2 alloc.img
}

#===================================================================================   
#         NAME: nmount
#        USAGE: nmount [/dev/device] 
#      RETURNS: ---
#  DESCRIPTION: nice mount of device
# REQUIREMENTS: mount awk column
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
nmount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4="";1') | column -t; }

#===================================================================================   
#         NAME: wmip
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: gets your external ip address using curl
# REQUIREMENTS: curl
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
wmip(){ printf "External IP: %s\n" $(curl -s  http://ifconfig.me/) ;}


#===================================================================================   
#         NAME: raid
#        USAGE: raid [devices]
#      RETURNS: ---
#  DESCRIPTION: check the health of a RAID array
# REQUIREMENTS: awk
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
raid() { awk '/^md/ {printf "%s: ", $1}; /blocks/ {print $NF}' </proc/mdstat ;}

#===================================================================================   
#         NAME: keys
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: add ssh keys to ssh-agent
# REQUIREMENTS: ssh-agent
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
keys() { eval $(ssh-agent) && ssh-add ~/.ssh/{bb,id_*sa} ;}

#===================================================================================   
#         NAME: hex2dec
#        USAGE: hex2dec [decimal #]
#      RETURNS: ---
#  DESCRIPTION: convert a hex # to decimal (base 10) on commandline
# REQUIREMENTS: bc
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
hex2dec(){
  echo "ibase=16; $@"|bc
}

#===================================================================================   
#         NAME: dec2hex
#        USAGE: dec2hex [hex #]
#      RETURNS: ---
#  DESCRIPTION: convert a  decimal (base 10) to hex (base 16) on commandline
# REQUIREMENTS: bc
#       AUTHOR: hur1can3
#     REVISION: 04.02.2013
#===================================================================================
dec2hex(){
  echo "obase=16; $@"|bc
}

#===================================================================================   
#         NAME: countsheep
#        USAGE: countsheep [# of sheep]
#      RETURNS: ---
#  DESCRIPTION: hypnosis / sleep inducer
# REQUIREMENTS: espeak sleep seq
#       AUTHOR: knoppix5
#     REVISION: 2013-01-25 06:55:35
#===================================================================================
countsheep(){
    for count in $(seq 2 1001); do espeak "$count sheeps";sleep 2;done
}

#===================================================================================   
#         NAME: cropimgs
#        USAGE: cropimgs [files] [width] [height]
#      RETURNS: ---
#  DESCRIPTION: batch crop images with imagemagick
# REQUIREMENTS: imagemagick
#       AUTHOR: michelsberg
#     REVISION: 2013-01-25 06:55:35
#===================================================================================
crompimgs(){
    mogrify -crop $2x$3+0+0 $1
}


#===================================================================================   
#         NAME: webcamshot
#        USAGE: webcamshot [resolution]
#      RETURNS: webcam-$(date +%m_%d_%Y_%H_%M).jpeg
#  DESCRIPTION: This command takes a 1280x1024 p picture from the webcam.
#               If prefer it smaller, try changing the -s parameter: 
#               qqvga is the tiniest, vga is 640x480, svga is 800x600 and so on.
# REQUIREMENTS: ls grep
#       AUTHOR: MarxBro
#     REVISION: 2013-01-17 11:37:09
#===================================================================================
webcamshot(){
    read && ffmpeg -y -r 1 -t 3 -f video4linux2 -vframes 1 -s sxga -i /dev/video0 ~/webcam-$(date +%m_%d_%Y_%H_%M).jpeg
}

#===================================================================================   
#         NAME: pshr
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: Find processes utilizing high memory in human readable format
# REQUIREMENTS: ps awk
#       AUTHOR: rockon
#     REVISION: 2012-11-27 04:29:08
#===================================================================================
pshr(){
    ps -eo size,pid,user,command --sort -size |awk '{hr[1024**2]="GB";hr[1024]="MB";for (x=1024**3; x>=1024; x/=1024){if ($1>=x){printf ("%-6.2f %s ", $1/x, hr[x]);break}}}{printf ("%-6s %-10s ", $2, $3)}{for (x=4;x<=NF;x++){printf ("%s ",$x)} print ("\n")}'
}

#===================================================================================   
#         NAME: pacdu
#        USAGE: ---
#      RETURNS: ---
#  DESCRIPTION: Arch Linux pacman sort installed packages by size
# REQUIREMENTS: pacman grep cut paste awk
#       AUTHOR: GetterNoCheddar
#     REVISION: 2012-11-20 03:40:55
#===================================================================================
pacdu() {
    pacman -Qi | grep 'Name\|Size\|Description' | cut -d: -f2 | paste  - - - | awk -F'\t' '{ print $2, "\t", $1, "\t", $3 }' | sort -rn
}
