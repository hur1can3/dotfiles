#!/bin/bash
# sourced by .bashrc

## Functions

#===  FUNCTION  ================================================================
#          NAME:  extract
#   DESCRIPTION:  extract most popular compressed file formats
#    PARAMETERS:  extract [filename]
#===============================================================================
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


# Follow copied and moved files to destination directory
goto() { 
    [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; 
}

cpf() { 
    cp "$@" && goto "$_"; 
}

mvf() { 
    mv "$@" && goto "$_"; 
}

#===  FUNCTION  ================================================================
#          NAME:  togglecpu
#   DESCRIPTION:  toggles between a performance profile and ondemand for cpu 
#		  frequency scaling
#    PARAMETERS:  none
#===============================================================================
function togglecpu () {
    [ "$(cpufreq-info | grep \"ondemand\")" ] && \
    sudo cpufreq-set -g performance || \
    sudo cpufreq-set -g ondemand ; 
}

#===  FUNCTION  ================================================================
#          NAME:  dirsize
#   DESCRIPTION:  gets the size of a directory
#    PARAMETERS:  none
#===============================================================================
dirsize ()
{
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
    egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm /tmp/list
}

# Query wikipedia
wiki() { 
    dig +short txt $1.wp.dg.cx; 
}


# Print man pages 
manp() { 
    man -t "$@" | lpr -pPrinter; 
}

# Create pdf of man page (requires ghostscript & perl-file-mimeinfo)
manpdf () { 
    man -t "$@" | ps2pdf - /tmp/manpdf_$1.pdf && xdg-open /tmp/manpdf_$1.pdf ;
}


#===  FUNCTION  ================================================================
#          NAME:  send
#   DESCRIPTION:  shortcut for transferring files via scp
#    PARAMETERS:  send [host1] [srcfile] [destfile]
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  albumart
#   DESCRIPTION:  grabs the album art for an album from albumart.org
#    PARAMETERS:  albumart [album_name]
#       RETURNS:  [album_name].jpg
#===============================================================================
albumart(){ 
    local y="$@";awk '/View larger image/{gsub(/^.*largeImagePopup\(.|., .*$/,"");print;exit}' <(curl -s 'http://www.albumart.org/index.php?srchkey='${y// /+}'&itempage=1&newsearch=1&searchindex=Music'); 
}


#===  FUNCTION  ================================================================
#          NAME:  sfm
#   DESCRIPTION:  plays a similar artist stream for last.fm with shell-fm
#    PARAMETERS:  sfm [artist]
#===============================================================================
sfm ()
{
    shell-fm -d -i 127.0.0.1 lastfm://artist/$1/similartists
}	# ----------  end of function sfm  ----------



#===  FUNCTION  ================================================================
#          NAME:  ipa
#   DESCRIPTION:  prints the IP Addresses of each attached networking device
#    PARAMETERS:  
#       RETURNS:  
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  or
#   DESCRIPTION:  makes backups of original files
#    PARAMETERS:  or [filename]
#       RETURNS:  [filename.orig]
#===============================================================================
or () {
	if [ -e "$@" ]; then
		for i in "$@"
		do
			cp "$i" "$i".orig
		done
	fi
}

#===  FUNCTION  ================================================================
#          NAME:  lowercase
#   DESCRIPTION:  moves a file or files to lowercase letters 
#    PARAMETERS:  lowercase [filename]
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  ii
#   DESCRIPTION:  get current host related information
#       RETURNS:  hostname users date stats memory ip addresses open connections 
#===============================================================================
# Get current host related info.
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

#===  FUNCTION  ================================================================
#          NAME:  tarbz2d
#   DESCRIPTION:  tarballs and bzip2 a directory
#    PARAMETERS:  tarbz2d [dirname]
#       RETURNS:  [date]-[dirname].tar.bz2
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  targzd
#   DESCRIPTION:  tarballs and gzips a directory
#    PARAMETERS:  targzd [dirname]
#       RETURNS:  [date]-[dirname].tar.gz
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  ltex
#   DESCRIPTION:  convert a latex source file .tex into dvi, ps, pdf, txt files
#    PARAMETERS:  ltex [filename]
#       RETURNS:  [filename].dvi [filename].ps [filename].pdf
#===============================================================================
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
        #latex $FILE.tex && dvipdf $FILE.dvi;
        latex $FILE.tex && dvips -Ppdf -G0 $FILE.dvi -o $FILE.ps && ps2pdf14 $FILE.ps;
        catdvi -e 1 -U $FILE.dvi | sed -re "s/\[U\+2022\]/*/g" | sed -re "s/([^^[:space:]])\s+/\1 /g" > $FILE.txt;
    fi
}



#===  FUNCTION  ================================================================
#          NAME:  defineold
#   DESCRIPTION:  define a word with google using lynx and sed
#    PARAMETERS:  search term in quotes example: defineold "cow"
#       RETURNS:  3 short sentences
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  define
#   DESCRIPTION:  define a word using google and busybox
#    PARAMETERS:  search term in quotes
#        SYNTAX:  define "search phrase"
#       RETURNS:  one page of definitions
#===============================================================================
define ()
{
	wget -q -U busybox -O- "http://www.google.com/search?ie=UTF8&q=define%3A$1" | tr '<' '\n' | sed -n 's/^li>\(.*\)/\1\n/p'

}	# ----------  end of function define  ----------

#===  FUNCTION  ================================================================
#          NAME:  definesay
#   DESCRIPTION:  defines a word or phrase using goole and busybox then speaks it with espeak and sox
#    PARAMETERS:  search term in quotes
#       RETURNS:  one page of definitions
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  definesayold
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#===============================================================================
definesayold () {
	lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${1}&btnG=Google+Search" | grep -m 3 -w "*"  | sed 's/;/ -/g' | cut -d- -f1 > /tmp/templookup.txt
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


#===  FUNCTION  ================================================================
#          NAME:  dsb
#   DESCRIPTION:  The same as the define say function except it uses bing as the
#		  search engine backend.
#    PARAMETERS:  dsb [definition]
#       RETURNS:  3 defintions printed on the terminal
#===============================================================================
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
	
	
# Calculate Stuff on the commandline
calc(){ 
    echo "$*" | bc; 
}

# Pretty-print using enscript
pjet(){ 
    enscript -h -G -fCourier9 "$1"; 
}

# Copy with progress
copy(){ 
    cp -v "$1" "$2"&watch -n 1 'du -h "$1" "$2";printf "%s%%\n" $(echo `du -h "$2"|cut -dG -f1`/0.`du -h "$1"|cut -dG -f1`|bc)'; 
}

# Find a file with a pattern in name:
ff(){ 
    find . -type f -iname '*'$*'*' -ls ; 
}

# Find a file with pattern $1 in name and Execute $2 on it:
fe(){ 
    find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; 
}

# Function that counts recursively number of lines of all files in specified folders
count() { 
    find $@ -type f -exec cat {} + | wc -l; 
}

# combine `mkdir foo && cd foo`  into a single function `mcd foo`
mcd() { 
    [ -n "$1" ] && mkdir -p "$@" && cd "$1"; 
}

# Sort the size usage of a directory tree by gigabytes, kilobytes, megabytes, then bytes.
dh() { 
    du -ch --max-depth=1 "${@-.}"|sort -n ;
}

# Use espeak to say a word or phrase
say() { 
    espeak -v en/en -s 150 -g 0 -k20 -p 0 -l 100 "$1" --stdout | play -V1 -q -t wav -;
}

# Use espeak to read the contents of a text file
rsay() { 
    espeak -f "$1" --stdout | play -V1 -q -t wav -;
}

# password generator
genpass(){ 
    local i x y z h;h=${1:-8};x=({a..z} {A..Z} {0..9});for ((i=0;i<$h;i++));do y=${x[$((RANDOM%${#x[@]}))]};z=$z$y;done;echo $z ; 
}

#===  FUNCTION  ================================================================
#          NAME:  geoip
#   DESCRIPTION:  looks up an ip address and retrieve geological info
#    PARAMETERS:  geoip [ip address] ie 192.168.0.1
#       RETURNS:  location
#===============================================================================
geoip(){ 
    curl -s "http://www.geody.com/geoip.php?ip=${1}" | sed '/^IP:/!d;s/<[^>][^>]*>//g' ; 
}

# geoip alternative
geoipalt() { 
    curl -A "Mozilla/5.0" -s "http://www.geody.com/geoip.php?ip=$1" | grep "^IP.*$1" | html2text; 
}
	 
# Copy structure
structcp() { ( 
    mkdir -pv $2;f="$(realpath "$1")";t="$(realpath "$2")";cd "$f";find * -type d -exec mkdir -pv $t/{} \;); 
}
	 
# Generate random password
randpw() {  
    /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo; 
}
	 
# generate a unique and secure password for every website that you login to
sitepass() { 
    echo -n "$@" |  md5sum | sha1sum | sha224sum | sha256sum | sha384sum | sha512sum | gzip - | strings -n 1 | tr -d "[:space:]"  | tr -s '[:print:]' | tr '!-~' 'P-~!-O' | rev | cut -b 2-11; history -d $(($HISTCMD-1)); 
}
	 
# Create a thumbnail from a video file
thumbnail() { 
    ffmpeg  -itsoffset -20 -i $i -vcodec mjpeg -vframes 1 -an -f rawvideo -s 640x272 ${i%.*}.jpg; 
}
	 
#===  FUNCTION  ================================================================
#          NAME:  tweet
#   DESCRIPTION:  update twitter from commandline via curl
#    PARAMETERS:  tweet [username] ["twitter string"]
#===============================================================================
tweet(){ 
    curl -u "$1" -d status="$2" "http://twitter.com/statuses/update.xml"; 
}

# Create date based backups
backup() { 
    for i in "$@"; 
    do 
        cp -va $i $i.$(date +%Y%m%d-%H%M%S); 
    done 
}

#===  FUNCTION  ================================================================
#          NAME:  shred
#   DESCRIPTION:  permantly delete a file with 17 rewrites of data
#    PARAMETERS:  shred [filename]
#===============================================================================
shred() { 
    shred -u -z -n 17 "$1"; 
}

#===  FUNCTION  ================================================================
#          NAME:  scptun
#   DESCRIPTION:  securely copy files over an ssh tunnel with rsync
#    PARAMETERS:  scptun [password] [username] [host] [src file] [destination]
#===============================================================================
scptun() { 
    sshpass -p "$1" rsync -av -e ssh "$2"@"$3":"$4" /"$5"; 
}

#===  FUNCTION  ================================================================
#          NAME:  tubej
#   DESCRIPTION:  concatenate two avi files into one youtube friendly file
#    PARAMETERS:  tubej [file1].avi [file2].avi [output.avi]
#       RETURNS:  [destination].avi
#===============================================================================
tubej() { 
    mencoder -audiofile input.mp3 -oac copy -ovc lavc -lavcopts vcodec=mpeg4 -ffourcc xvid -vf scale=320:240,harddup "$1" "$2" -o "$3"; 
}


#===  FUNCTION  ================================================================
#          NAME:  pdfo
#   DESCRIPTION:  optimize a pdf file
#    PARAMETERS:  pdfo [input].pdf [output].pdf
#       RETURNS:  [output].pdf
#===============================================================================
pdfo() { 
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$2" "$1"; 
}


# make a thumb %20 the size of a pic
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

# grep by paragraph
grepp() {
    [ $# -ne 2 ] && return 1
    perl -00ne "print if /$1/i" < $2
}


#===  FUNCTION  ================================================================
#          NAME:  pullout
#   DESCRIPTION:  pulls a single file out of a .tar.gz
#    PARAMETERS:  pullout [file] [archive.tar.gz]
#       RETURNS:  [file]
#===============================================================================
pullout() {

    if [ $# -ne 2 ]; then
		echo "need proper arguments:"
		echo "pullout [file] [archive.tar.gz]"
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
 

#===  FUNCTION  ================================================================
#          NAME:  fix
#   DESCRIPTION:  recursively fix dir/file permissions on a given directory
#    PARAMETERS:  fix [dir/file] 
#===============================================================================
fix() {
    if [ -d "$1" ]; then 
        find "$1" -type d -exec chmod 755 {} -type f -exec chmod 644 {} \;
    else
        echo "$1 is not a directory."
    fi
}


#===  FUNCTION  ================================================================
#          NAME:  shot
#   DESCRIPTION:  takes a timestamped screen shot
#    PARAMETERS:  shot [destination]
#       RETURNS:  [destination]/desktop_[date].png
#===============================================================================
shot(){
    local PIC="$1/desktop_$(date +%y%m%d%H%M).png"
    scrot -t 20 -cd 3 $PIC
}


#===  FUNCTION  ================================================================
#          NAME:  rip
#   DESCRIPTION:  rips a standard dvd with handbrake into an x264 mp4
#    PARAMETERS:  rip [dvd drive] [output file]
#       RETURNS:  [output file].mp4 with bitrate 4000 and audio 192 kb
#===============================================================================
rip() {
    handbrake -i $1 -o $2.mp4 -L -U -F -f mp4 -e x264 -b 4000 -B 192
}


#===  FUNCTION  ================================================================
#          NAME:  safeedit
#   DESCRIPTION:  make a backup of a file to [file].backup before editing it
#    PARAMETERS:  safeedit [file]
#===============================================================================
safeedit() {
    cp $1 $1.backup && vim $1
}

#===  FUNCTION  ================================================================
#          NAME:  saveit
#   DESCRIPTION:  saves a file to ~/Temp or $HOME/Temp
#    PARAMETERS:  saveit [file]
#===============================================================================
saveit() {
    cp $1 $HOME/Temp/$1.saved
}


#===  FUNCTION  ================================================================
#          NAME:  switchfile
#   DESCRIPTION:  switch two files (comes in handy)
#    PARAMETERS:  switchfile [file1] [file2]
#===============================================================================
switchfile() {
    mv $1 $1.tmp && mv $2 $1 && mv $1.tmp $2
}

#===  FUNCTION  ================================================================
#          NAME:  trash
#   DESCRIPTION:  move files to trash for deletion
#    PARAMETERS:  trash [file]
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  fixscript
#   DESCRIPTION:  removes control characters from linux typescript or script
#    PARAMETERS:  fixscript [file]
#===============================================================================
fixscript() {
    cat $1 | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > $1-processed
}

#===  FUNCTION  ================================================================
#          NAME:  kerneldepgraph
#   DESCRIPTION:  draws a kernel dependancy graph
#    PARAMETERS:  kerneldepgraph
#===============================================================================
kerneldepgraph() {
lsmod | perl -e 'print "digraph \"lsmod\" {";<>;while(<>){@_=split/\s+/; print "\"$_[0]\" -> \"$_\"\n" for split/,/,$_[3]}print "}"' | dot -Tpng | display -
}

#===  FUNCTION  ================================================================
#          NAME:  iencrypt
#   DESCRIPTION:  encrypt sensitive image using password 
#    PARAMETERS:  iencrypt [password] [image]
#===============================================================================
iencrypt() {
    echo "$1" | convert "$2" -encipher - -depth 8 png24:hidden.png
}

#===  FUNCTION  ================================================================
#          NAME:  idecrypt
#   DESCRIPTION:  decrypt sensitive image using password 
#    PARAMETERS:  idecrypt [password] [image]
#===============================================================================
idecrypt() {
    echo "$1" | convert "$2" -decipher - sensitive.png
}

#===  FUNCTION  ================================================================
#          NAME:  pwgen
#   DESCRIPTION:  Create strong, but easy to remember password 
#    PARAMETERS:  pwgen [simple passphrase] 
#===============================================================================
idecrypt() {
    echo "$1" | md5sum | base64 | cut -c -16
}

#===  FUNCTION  ================================================================
#          NAME:  man2pdf
#   DESCRIPTION:  save man-page as a pdf
#    PARAMETERS:  man2pdf [man command]
#===============================================================================
man2pdf() {
    man -t "$1" | ps2pdf - "$1".pdf
}

#===  FUNCTION  ================================================================
#          NAME:  waterfall
#   DESCRIPTION:  Make some powerful pink noise that sounds like waterfall
#===============================================================================
waterfall() {
    play -c 2 -n synth pinknoise band -n 2500 4000 tremolo 0.03 5 reverb 20 gain -l 6
}

listssh() {
    netstat -atn | grep :22 | grep ESTABLISHED | awk '{print $4}' | sed 's/:22//'
}

#===  FUNCTION  ================================================================
#          NAME:  gencommit
#   DESCRIPTION:  generate a random and/or funny commit message
#===============================================================================
gencommit() {
    curl -s 'http://whatthecommit.com/' | grep '<p>' | cut -c4-
}

#===  FUNCTION  ================================================================
#          NAME:  gitbranches
#   DESCRIPTION:  Show git branches by date - useful for showing active branches
#===============================================================================
gitbranches() {
    for k in `git branch|sed s/^..//`;do echo -e `git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" "$k" --`\\t"$k";done|sort
}

#===  FUNCTION  ================================================================
#          NAME:  gitzip
#   DESCRIPTION:  bash script to zip a folder while ignoring git files and copying it to dropbox
#===============================================================================
gitzip() {
    git archive HEAD | gzip > ~/Dropbox/archive.tar.gz
}

gitstart () { if ! [[ -d "$@" ]]; then mkdir -p "$@" && cd "$@" && git init; else cd "$@" && git init; fi }

whichpkg() { readlink -f "$(which $1)" | xargs --no-run-if-empty dpkg -S; }

genplasma() {
    convert -size 1280x720 plasma:fractal -blur 0x5 -emboss 2 ~/background.png
}


ddpvblock() {
BLOCKSIZE='sude blocokdev --getsize64 $1'
sudo dd if=$1 bs=1MB | pv -s $BLOCKSIZE | gzip -9 > $2.img.gz
}

ddpvunblock() {
#FILESIZE='ls -l $1 | awk '{print $5}''
#sudo gunzip -c $1 | pv -s $FILESIZE | sudo dd of=$2 bs=1MB 
sudo gunzip -c $1 | pv | sudo dd of=$2 bs=1MB 
}

bconv() {
    sudo gunzip -c $1 | qemu-img convert -f raw -O qcow2 alloc.img
}


# Nice mount output
nmount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4="";1') | column -t; }

# Print man pages 
manp() { man -t "$@" | lpr -pPrinter; }

# Create pdf of man page - requires ghostscript and mimeinfo
manpdf() { man -t "$@" | ps2pdf - /tmp/manpdf_$1.pdf && xdg-open /tmp/manpdf_$1.pdf ;}


# edit posts in Octopress
pedit() { find source/_posts/ -name "*$1*" -exec vim {} \; ;}

# External IP
wmip(){ printf "External IP: %s\n" $(curl -s  http://ifconfig.me/) ;}

# Health of RAID array
raid() { awk '/^md/ {printf "%s: ", $1}; /blocks/ {print $NF}' </proc/mdstat ;}

# SSH Keys 
keys() { eval $(ssh-agent) && ssh-add ~/.ssh/{bb,id_*sa} ;}

### Simple notes ------------------------------------------------
n() { 
  local arg files=()
  for arg; do 
      files+=( ~/".notes/$arg" )
  done
  ${EDITOR:-vi} "${files[@]}"; 
}

nls() {
  tree -CR --noreport $HOME/.notes | awk '{ 
    if (NF==1) print $1 
    else if (NF==2) print $2
    else if (NF==3) printf "  %s\n", $3 
  }'
}

# TAB completion for notes
_notes() {
  local files=($HOME/.notes/**/"$2"*)
  [[ -e ${files[0]} ]] && COMPREPLY=( "${files[@]##~/.notes/}" )
}
complete -o default -F _notes n