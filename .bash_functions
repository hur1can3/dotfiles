#!/bin/bash
# sourced by .bashrc

#####################################################
#               BEER-WARE LICENSE
# Matthew Levandowski wrote this file. As long as you
# retain this notice you can do whatever you want 
# with this file and its contents. If we meet some
# day and you think it is worth it, you can buy
# me a beer in return.             - Matt Levandowski
# 01/19/2011            levandowski.matthew@gmail.com
#####################################################


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

#===  FUNCTION  ================================================================
#          NAME:  goto
#   DESCRIPTION:  Follow copied and moved files to destination directory
#    PARAMETERS:  goto [directory_name]
#===============================================================================
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }
goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }

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
wiki() { dig +short txt $1.wp.dg.cx; }


# Print man pages 
manp() { man -t "$@" | lpr -pPrinter; }

# Create pdf of man page (requires ghostscript & perl-file-mimeinfo)
manpdf () { man -t "$@" | ps2pdf - /tmp/manpdf_$1.pdf && xdg-open /tmp/manpdf_$1.pdf ;}


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
albumart(){ local y="$@";awk '/View larger image/{gsub(/^.*largeImagePopup\(.|., .*$/,"");print;exit}' <(curl -s 'http://www.albumart.org/index.php?srchkey='${y// /+}'&itempage=1&newsearch=1&searchindex=Music'); }


#===  FUNCTION  ================================================================
#          NAME:  sfm
#   DESCRIPTION:  plays a similar artist stream for last.fm with shell-fm
#    PARAMETERS:  sfm [artist]
#===============================================================================
sfm ()
{
    shell-fm -d -i 127.0.0.1 lastfm://artist/$1/similartists
}	


#===  FUNCTION  ================================================================
#          NAME:  ipa
#   DESCRIPTION:  prints the IP Addresses of each attached networking device 
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
#   DESCRIPTION:  convert a latex source file .tex into dvi, ps, and pdf files
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
    fi
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

}

#===  FUNCTION  ================================================================
#          NAME:  definesay
#   DESCRIPTION:  defines a word or phrase using goole and busybox then speaks 
#                 it with espeak and sox
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
	
#===  FUNCTION  ================================================================
#          NAME:  calc
#   DESCRIPTION:  Calculate Stuff on the commandline
#===============================================================================
calc(){ echo "$*" | bc; }

#===  FUNCTION  ================================================================
#          NAME:  pjet
#   DESCRIPTION:  Pretty-print using enscript
#===============================================================================
pjet(){ enscript -h -G -fCourier9 "$1"; }

#===  FUNCTION  ================================================================
#          NAME:  copy
#   DESCRIPTION:  copy with a progress bar
#===============================================================================
copy(){ cp -v "$1" "$2"&watch -n 1 'du -h "$1" "$2";printf "%s%%\n" $(echo `du -h "$2"|cut -dG -f1`/0.`du -h "$1"|cut -dG -f1`|bc)'; }

#===  FUNCTION  ================================================================
#          NAME:  ff
#   DESCRIPTION:  find a file witha a pattern in the name
#    PARAMETERS:  ff [filename_search_pattern]
#===============================================================================
ff(){ find . -type f -iname '*'$*'*' -ls ; }

#===  FUNCTION  ================================================================
#          NAME:  fe
#   DESCRIPTION:  find a file witha a pattern in the name and exucte on it
#    PARAMETERS:  fe [filename_search_pattern] [command]
#===============================================================================
fe(){ find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

#===  FUNCTION  ================================================================
#          NAME:  count
#   DESCRIPTION:  recursively counts number of lines of all files in a folder
#    PARAMETERS:  count [folder(s)]
#===============================================================================
count() { find $@ -type f -exec cat {} + | wc -l; }

#===  FUNCTION  ================================================================
#          NAME:  dh
#   DESCRIPTION:  sorts the size of a directory tree by GB, Kb, MB, then bytes
#    PARAMETERS:  dh [directory]
#===============================================================================
dh() { du -ch --max-depth=1 "${@-.}"|sort -n ;}

#===  FUNCTION  ================================================================
#          NAME:  say
#   DESCRIPTION:  use espeak to say the inputed word or phrase
#    PARAMETERS:  say [text_string]
#===============================================================================
say() { espeak -v en/en -s 150 -g 0 -k20 -p 0 -l 100 "$1" --stdout | play -V1 -q -t wav -;}

#===  FUNCTION  ================================================================
#          NAME:  rsay
#   DESCRIPTION:  use espeak to read the contents of a text file
#    PARAMETERS:  rsay [file]
#===============================================================================
rsay() { espeak -f "$1" --stdout | play -V1 -q -t wav -;}

#===  FUNCTION  ================================================================
#          NAME:  genpass
#   DESCRIPTION:  generates an alphanumeric password with given length
#    PARAMETERS:  genpass [length]
#===============================================================================
genpass(){ local i x y z h;h=${1:"$1"};x=({a..z} {A..Z} {0..9});for ((i=0;i<$h;i++));do y=${x[$((RANDOM%${#x[@]}))]};z=$z$y;done;echo $z ; }

#===  FUNCTION  ================================================================
#          NAME:  genpassr
#   DESCRIPTION:  generates an alphanumeric password with given length
#    PARAMETERS:  genpassr [length]
#===============================================================================
genpassr(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-"$1"};echo; }

#===  FUNCTION  ================================================================
#          NAME:  sitepass
#   DESCRIPTION:  generates an unique password for every website that you use
#    PARAMETERS:  sitepass [url]
#===============================================================================
sitepass() { echo -n "$@" |  md5sum | sha1sum | sha224sum | sha256sum | sha384sum | sha512sum | gzip - | strings -n 1 | tr -d "[:space:]"  | tr -s '[:print:]' | tr '!-~' 'P-~!-O' | rev | cut -b 2-11; history -d $(($HISTCMD-1)); }

#===  FUNCTION  ================================================================
#          NAME:  geoip
#   DESCRIPTION:  looks up an ip address and retrieve geological info
#    PARAMETERS:  geoip [ip address] ie 192.168.0.1
#       RETURNS:  location
#===============================================================================
geoip(){ curl -s "http://www.geody.com/geoip.php?ip=${1}" | sed '/^IP:/!d;s/<[^>][^>]*>//g' ; }
	 
#===  FUNCTION  ================================================================
#          NAME:  structcp
#   DESCRIPTION:  copies an entire path structure without copying files
#    PARAMETERS:  structcp [source_path]
#===============================================================================
structcp(){ ( mkdir -pv $2;f="$(realpath "$1")";t="$(realpath "$2")";cd "$f";find * -type d -exec mkdir -pv $t/{} \;); }
	
#===  FUNCTION  ================================================================
#          NAME:  thumbnail
#   DESCRIPTION:  create a thumbnail from a given video file
#    PARAMETERS:  thumbnail [video_file]
#===============================================================================
thumbnail() { ffmpeg  -itsoffset -20 -i $i -vcodec mjpeg -vframes 1 -an -f rawvideo -s 640x272 ${i%.*}.jpg; }
	 
#===  FUNCTION  ================================================================
#          NAME:  tweet
#   DESCRIPTION:  update twitter from commandline via curl
#    PARAMETERS:  tweet [username] ["twitter string"]
#===============================================================================
tweet(){ curl -u "$1" -d status="$2" "http://twitter.com/statuses/update.xml"; }

#===  FUNCTION  ================================================================
#          NAME:  dbackup
#   DESCRIPTION:  create date based backups in form YYYYmmdd-HourMinSecond
#    PARAMETERS:  dbackup [file(s)]
#===============================================================================
dbackup() { for i in "$@"; do cp -va $i $i.$(date +%Y%m%d-%H%M%S); done }

#===  FUNCTION  ================================================================
#          NAME:  shred
#   DESCRIPTION:  permantly delete a file with 17 rewrites of data
#    PARAMETERS:  shred [filename]
#===============================================================================
shred() { shred -u -z -n 17 "$1"; }

#===  FUNCTION  ================================================================
#          NAME:  scptun
#   DESCRIPTION:  securely copy files over an ssh tunnel with rsync
#    PARAMETERS:  scptun [password] [username] [host] [src file] [destination]
#===============================================================================
scptun() { sshpass -p "$1" rsync -av -e ssh "$2"@"$3":"$4" /"$5"; }

#===  FUNCTION  ================================================================
#          NAME:  tubej
#   DESCRIPTION:  concatenate two avi files into one youtube friendly file
#    PARAMETERS:  tubej [file1].avi [file2].avi [output.avi]
#       RETURNS:  [destination].avi
#===============================================================================
tubej() { mencoder -audiofile input.mp3 -oac copy -ovc lavc -lavcopts vcodec=mpeg4 -ffourcc xvid -vf scale=320:240,harddup "$1" "$2" -o "$3"; }

#===  FUNCTION  ================================================================
#          NAME:  pdfo
#   DESCRIPTION:  optimize a pdf file
#    PARAMETERS:  pdfo [input].pdf [output].pdf
#       RETURNS:  [output].pdf
#===============================================================================
pdfo() { gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$2" "$1"; }

#===  FUNCTION  ================================================================
#          NAME:  thumbit
#   DESCRIPTION:  make a thumbnail from a pic that is 20% reduced in size
#    PARAMETERS:  thumbit [file]
#===============================================================================
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

#===  FUNCTION  ================================================================
#          NAME:  grepp
#   DESCRIPTION:  grep by paragraph, i.e. search one paragraph at a time
#    PARAMETERS:  grepp [input]
#===============================================================================
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
#          NAME:  scrld
#   DESCRIPTION:  Take a screenshot of the screen, upload it to ompldr.org and 
#                 put link to the clipboard and to the screenshots.log 
#                 (with a date stamp) in a home directory.
#    PARAMETERS:  srld [-w] for screenshot of current window only
#===============================================================================
scrld() {
if [ "$1" == "w" ]; then
        scrot -u  /tmp/screenshot.png && curl -s -F file1=@/tmp/screenshot.png -F submit="OMPLOAD\!" http://ompldr.org/upload | egrep '(View file: <a href="v([A-Za-z0-9+\/]+)">)' | sed 's/^.*\(http:\/\/.*\)<.*$/\1/' | xsel -b -i && rm -f /tmp/screenshot.png &&  notify-send -t 5000 -i dialog-information  "Screenshot uploaded." "\<a href =\"`xsel -o`\">Url</a> copied to clipboard." && echo "`date`______ `xsel -o`">>~/screenshots.log;
        else
        scrot $1 /tmp/screenshot.png && curl -s -F file1=@/tmp/screenshot.png -F submit="OMPLOAD\!" http://ompldr.org/upload | egrep '(View file: <a href="v([A-Za-z0-9+\/]+)">)' | sed 's/^.*\(http:\/\/.*\)<.*$/\1/' | xsel -b -i && rm -f /tmp/screenshot.png &&  notify-send -t 5000 -i dialog-information  "Screenshot uploaded." "\<a href =\"`xsel -o`\">Url</a> copied to clipboard." && echo "`date`______ `xsel -o`">>~/screenshots.log
        fi
}

#===  FUNCTION  ================================================================
#          NAME:  lottogen
#   DESCRIPTION:  generates number for a lottery ticket
#===============================================================================
lottogen() {
echo $(shuf -n 6 -i 1-49 | sort -n)
}

#===  FUNCTION  ================================================================
#          NAME:  bigones
#   DESCRIPTION:  recursively search for large files in Mb from a directory. 
#    PARAMETERS:  bigones [directory] [size_in_Mb]
#       RETURNS:  shows size and location.
#===============================================================================
bigones() {
find $1 -size +"$2"M -exec du -h {} \;
}

#===  FUNCTION  ================================================================
#          NAME:  rtfm
#   DESCRIPTION:  read the #%$&*@~! manual 
#    PARAMETERS:  rtfm [command]
#===============================================================================
rtfm() { 
help $@ || man $@ || $BROWSER "http://www.google.com/search?q=$@"; 
}

#===  FUNCTION  ================================================================
#          NAME:  wgetol
#   DESCRIPTION:  wget download one page and all it's links for offline viewing
#    PARAMETERS:  wgetol [url]
#===============================================================================
wgetol() {
wget -e robots=off -E -H -k -K -p $1
}

#===  FUNCTION  ================================================================
#          NAME:  fixscript
#   DESCRIPTION:  removes control characters from linux typescript or script
#    PARAMETERS:  fixscript [file]
#===============================================================================
fixscript() {
cat $1 | perl -pe 's/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g' | col -b > $1-processed
}
