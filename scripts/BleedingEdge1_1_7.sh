#!/bin/bash
#
#BleedingEdge.sh for Ubuntu Copyright (C) 2009-2011 Paul Fedele
#Works only with zenity and notify-osd Installed!
#
#To use this script graphically, make it executable (Right Click File, Permissions, Select Execute Checkbox)
#then double click the file and select "Run in Terminal"
#
#To use this script from the command prompt type "chmod u+x PATH/BleedingEdge_VERSION.sh" where PATH is the location of the script and VERSION is the appropriate version of the script
#
#Inquiries can be sent to fedele at rocketmail dot com
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#http://www.gnu.org/licenses/gpl-3.0.html
#
#This script adds software from repositories which are not under its control.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#No Warranty or guarantee of suitability exists for this software
#Use at your own risk. The author is not responsible if your system breaks.
#
#You should have received a copy of the GNU General Public License
#along with this program. If not, see <http://www.gnu.org/licenses/>.
#Adobe Flash, Adobe Reader, Arthos, Avant, Blueman, Boxee, Cairo Dock, Cinelerra, CLI Companion, Dock Bar X, Dolphin, Drop Box, Enlightenment, Epidermis, FileZilla FTP, FreeTux TV, GetDeb, gImageReader, Gnome, GmapCatcher, Google Chrome, Google Earth, Google Picasa, Google Talk, Gtalx, GUFW, Hulu, Java, K3B, KDE, Lucidor, Libre Office, Linux, Mono, Mozilla Firefox, Mplayer, Octoshape, Open Office, OpenShot, Pandora, PDF, Pithos, PlayDeb, PlayOnLinux, Prey, Pulse, Remobo IPN, Sbackup, Skype, Ubuntu, Ubuntu Tweak, VirtualBox, VLC, Wii, Wine, and Xine are trademarks of their respective owners.  No endorsement by any trademark holder is stated or implied.
VERSION="1_1_7"
DISTROBUTION="maverick"
RED="\033[0;31m"
BLUE="\033[0;34m"
GREEN="\033[1;32m"
ENDCOLOR="\033[0m"
ARCHITECTURE=`uname -m`
ON_USER=`whoami`
CODENAME=$(lsb_release -cs)
RESTART="NO"
UPDATEREQUIRED="NO"
function BluemanPrep()
{
	if [ -f /etc/apt/sources.list.d/blueman.list ]
	then
		echo -e $GREEN"*Blueman Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Blueman Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding the Blueman Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding the Blueman Repository"
		echo "deb http://ppa.launchpad.net/blueman/ppa/ubuntu $CODENAME main" > ./blueman.list
		sudo mv ./blueman.list /etc/apt/sources.list.d/blueman.list
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 951DC1E2
	fi
	UPDATEREQUIRED="YES"
	return
}
function BoxeePrep()
{
	if [ -f /etc/apt/sources.list.d/boxee.list ]
	then
		echo -e $GREEN"*Boxee Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Boxee Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding the Boxee Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding the Boxee Repository"
		echo "deb http://apt.boxee.tv/ $CODENAME main" > ./boxee.list
		sudo mv ./boxee.list /etc/apt/sources.list.d/boxee.list
	fi
	UPDATEREQUIRED="YES"
	return
}
function CairoPrep()
{
	if [ -f /etc/apt/sources.list.d/cairo.list ]
	then
		echo -e $GREEN"*Cairo Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Cairo Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding the Cairo Dock Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding the Cairo Dock Repository"
		echo "deb http://repository.cairo-dock.org/ubuntu $CODENAME cairo-dock" > ./cairo.list
		echo "deb http://repository.glx-dock.org/ubuntu $CODENAME cairo-dock ## Cairo-Dock-Stable" > ./cairo.list 
		sudo mv ./cairo.list /etc/apt/sources.list.d/cairo.list
		wget http://repository.glx-dock.org/cairo-dock.gpg -O- | sudo apt-key add -
	fi
	UPDATEREQUIRED="YES"

	return
}
function CompanionPrep()
{
	if [ -f /etc/apt/sources.list.d/clicompanion-devs-clicompanion-nightlies-$CODENAME.list ]
	then
		echo -e $GREEN"*CLI Companion Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "CLI Companion Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The CLI Companion Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The CLI Companion Repository"
		sudo add-apt-repository ppa:clicompanion-devs/clicompanion-nightlies
	fi
	UPDATEREQUIRED="YES"
	return
}
function DockBarXPrep()
{
	if [ -f /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list ]
	then
		echo -e $GREEN"*DockBarX Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "DockBarX Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The DockBarX Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The DockBarX Repository"
		sudo add-apt-repository ppa:nilarimogard/webupd8
	fi
	UPDATEREQUIRED="YES"
	return
}
function DolphinPrep()
{
	if [ -f /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list ]
	then
		echo -e $GREEN"*Dolphin Wii Emulator Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Dolhpin Wii Emulator Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Dolhpin Wii Emulator Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Dolhpiin Wii Emulator Repository"
		sudo add-apt-repository ppa:glennric/dolphin-emu
	fi
	UPDATEREQUIRED="YES"
	return
}
function DropboxPrep()
{
#	if [ -f /etc/apt/sources.list.d/dropbox.list ]
#		then
#			echo -e $GREEN"*DropBox Repository Found*"$ENDCOLOR
#			/usr/bin/notify-send "DropBox Repository Found"
#		else
#		echo "=================================================="
#			echo -e $BLUE"Adding DropBox Repository"$ENDCOLOR
#			/usr/bin/notify-send "Adding DropBox Repository"echo "deb http://archive.getdeb.net/ubuntu maverick-getdeb games" > playdeb.list
#			sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
#			sudo echo "deb http://linux.dropbox.com/ubuntu $CODENAME main" > ./dropbox.list
#			sudo mv ./dropbox.list /etc/apt/sources.list.d/dropbox.list
#	fi
#	UPDATEREQUIRED="YES"
	return
}
function EnlightenmentPrep()
{
	if [ -f /etc/apt/sources.list.d/enlightenment.list ]
	then
		echo -e $GREEN"*Enlightenment Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Enlightenment Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Enlightenment Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Enlightenment Repository"
		sudo echo "deb http://packages.enlightenment.org/ubuntu $CODENAME main extras" > ./enlightenment.list
		sudo mv ./enlightenment.list /etc/apt/sources.list.d/enlightenment.list
		sudo wget http://packages.enlightenment.org/repo.key -O- | sudo apt-key add -
	fi
	UPDATEREQUIRED="YES"
	return
}
function FirefoxPrep()
{
	if [ -f /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-$CODENAME.list ]
	then
		echo -e $GREEN"*Firefox Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Firefox Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Firefox Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Firefox Repository"
		sudo add-apt-repository ppa:mozillateam/firefox-stable
		#sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa
	fi
	UPDATEREQUIRED="YES"
	return
}
function FlashPrep()
{
	if [ $ARCHITECTURE = "i686" ]
	then
		if [ -f /etc/apt/sources.list.d/partner.list ]
		then
			echo -e $GREEN"*Ubuntu Partner Repository Found*"$ENDCOLOR
			/usr/bin/notify-send "Ubuntu Partner Repository Found"
		else
			echo "=================================================="
			echo -e $BLUE"Adding Ubuntu Partner Repository"$ENDCOLOR
			/usr/bin/notify-send "Adding Ubuntu Partner Repository"
			sudo echo "deb http://archive.canonical.com/ubuntu $CODENAME partner" > ./partner.list
			sudo echo "deb-src http://archive.canonical.com/ubuntu $CODENAME partner" >> ./partner.list
			sudo mv ./partner.list /etc/apt/sources.list.d/partner.list
		fi
		UPDATEREQUIRED="YES"
	fi
	return
}
function GetdebPrep()
{
	if [ -f /etc/apt/sources.list.d/getdeb.list ]
	then
		echo -e $GREEN"*Getdeb Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Getdeb Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding Getdeb Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding Getdeb Repository"
		sudo echo "deb http://archive.getdeb.net/ubuntu $CODENAME-getdeb apps" > ./getdeb.list
		sudo echo "deb http://archive.getdeb.net/ubuntu $CODENAME-getdeb games" >> ./getdeb.list
		sudo mv ./getdeb.list /etc/apt/sources.list.d/getdeb.list
		wget -q -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
	fi
	UPDATEREQUIRED="YES"
		echo -e $BLUE"After this program completes you may add additional software from your package manager or www.getdeb.net"$ENDCOLOR
		/usr/bin/notify-send "After this program completes you may add additional software from your package manager or www.getdeb.net"
	return
}
function gImageReaderPrep()
{
		if [ -f /etc/apt/sources.list.d/alex-p-notesalexp-maverick.list ]
		then
			echo -e $GREEN"*gImageReader Repository Found*"$ENDCOLOR
			/usr/bin/notify-send "gImageReader Repository Found"
		else
			echo "=================================================="
			echo -e $BLUE"Adding The gImageReader Repository"$ENDCOLOR
			/usr/bin/notify-send "Adding The gImageReader Repository"
			sudo add-apt-repository ppa:alex-p/notesalexp
		fi
		UPDATEREQUIRED="YES"
	return
}
function PicasaPrep()
{
		if [ -f /etc/apt/sources.list.d/picasa.list ]
		then
			echo -e $GREEN"*Picasa Repository Found*"$ENDCOLOR
			/usr/bin/notify-send "Picasa Repository Found"
		else
			echo "=================================================="
			echo -e $BLUE"Adding The Picasa Repository"$ENDCOLOR
			/usr/bin/notify-send "Adding The Picasa Repository"
			sudo echo "deb http://dl.google.com/linux/deb/ stable non-free" > ./picasa.list
			sudo mv ./picasa.list /etc/apt/sources.list.d/picasa.list
			sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
		fi
		UPDATEREQUIRED="YES"
	return
}
function KDEPrep()
{
	if [ -f /etc/apt/sources.list.d/kde35.list ]
	then
		echo -e $GREEN"*KDE 3.5 Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "KDE 3.5 Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The KDE 3.5 Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The KDE 3.5 Repository"
		sudo echo "deb http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity/ubuntu $CODENAME main" > ./kde35.list
		sudo echo "deb-src http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity/ubuntu $CODENAME main" >> ./kde35.list
		sudo echo "deb http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity-builddeps/ubuntu $CODENAME main" >> ./kde35.list
		sudo echo "deb-src http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity-builddeps/ubuntu $CODENAME main" >> ./kde35.list
		sudo mv ./kde35.list /etc/apt/sources.list.d/kde35.list
		sudo apt-key adv --keyserver keyserver.quickbuild.pearsoncomputing.net --recv-keys 2B8638D0
	fi
	UPDATEREQUIRED="YES"
	return
}
function KDE46Prep()
{
	if [ -f /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list ]
	then
		echo -e $GREEN"*KDE 4.6 Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "KDE 4.6 Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The KDE 4.6 Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The KDE 4.6 Repository"
		sudo add-apt-repository ppa:kubuntu-ppa/backports
	fi
	UPDATEREQUIRED="YES"
	return
}
function FontsPrep()
{
	if [ -f /etc/apt/sources.list.d/medibuntu.list ]
	then
		echo -e $GREEN"*Medibuntu Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Medibuntu Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Medibuntu Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Medibuntu Repository"
		sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$CODENAME.list && sudo apt-get --quiet update && sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2EBC26B60C5A2783
	fi
	UPDATEREQUIRED="YES"
	return
}
function LibrePrep()
{
	if [ -f /etc/apt/sources.list.d/libreoffice-ppa-$CODENAME.list ]
	then
		echo -e $GREEN"*Libre Office Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Libre Office Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Libre Office Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Libre Office Repository"
		sudo add-apt-repository ppa:libreoffice/ppa
	fi
	UPDATEREQUIRED="YES"
	return
}
function OpenShotPrep()
{
	if [ -f /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list ]
	then
		echo -e $GREEN"*OpenShot Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "OpenShot Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The OpenShot Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The OpenShot Repository"
		sudo add-apt-repository ppa:jonoomph/openshot-edge
	fi
	UPDATEREQUIRED="YES"
	return
}
function PithosPrep()
{
	if [ -f /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list ]
	then
		echo -e $GREEN"*Pithos Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Pithos Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Pithos Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Pithos Repository"
		sudo add-apt-repository ppa:kevin-mehall/pithos-daily
	fi
	UPDATEREQUIRED="YES"
	return
}
function RepositoriesPrep()
{
		echo "=================================================="
		echo -e $BLUE"Opening your local package manager to add more repositories"$ENDCOLOR
		/usr/bin/notify-send "Opening your local package manager to add more repositories"
		sudo software-properties-gtk
	return
}
function RestrictedPrep()
{
	if [ -f /etc/apt/sources.list.d/medibuntu.list ]
	then
		echo -e $GREEN"*Medibuntu Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Medibuntu Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Medibuntu Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Medibuntu Repository"
		sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$CODENAME.list && sudo apt-get --quiet update && sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring
		wget -q http://medibuntu.sos-sts.com/repo/medibuntu-key.gpg -O- | sudo apt-key add -
	fi
	echo "=================================================="
	echo -e $BLUE"Adding The VLC Repository"$ENDCOLOR
	/usr/bin/notify-send "Adding The VLC Repository"
	sudo add-apt-repository ppa:ferramroberto/vlc
	sudo add-apt-repository ppa:freetuxtv/freetuxtv
	sudo add-apt-repository ppa:exaile-devel/ppa
	UPDATEREQUIRED="YES"
	return
}
function SkypePrep()
{
	if [ -f /etc/apt/sources.list.d/medibuntu.list ]
	then
		echo -e $GREEN"*Medibuntu Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Medibuntu Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding The Medibuntu Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding The Medibuntu Repository"
		sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$CODENAME.list && sudo apt-get --quiet update && sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2EBC26B60C5A2783
	fi
	UPDATEREQUIRED="YES"
	return
}
function TweakPrep()
{
	if [ -f /etc/apt/sources.list.d/tweak.list ]
	then
		echo -e $GREEN"*Tweak Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Tweak Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding the Ubuntu Tweak Repository"$ENDCOLOR
		/usr/bin/notify-send "Adding the Ubuntu Tweak Repository"
		sudo echo "deb http://ppa.launchpad.net/tualatrix/ppa/ubuntu $CODENAME main" > ./tweak.list
		sudo echo "deb-src http://ppa.launchpad.net/tualatrix/ppa/ubuntu $CODENAME main" >> ./tweak.list
		sudo mv ./tweak.list /etc/apt/sources.list.d/tweak.list
		sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 6AF0E1940624A220
	fi
	UPDATEREQUIRED="YES"
	return
}
#function VirtualBoxPrep()
#{
#	if [ -f /etc/apt/sources.list.d/virtualbox.list ]
#	then
#		echo -e $GREEN"*VirtualBox Repository Found*"$ENDCOLOR
#		/usr/bin/notify-send "VirtualBox Repository Found"
#	else
#		echo "=================================================="
#		echo -e $BLUE"Adding the VirtualBox Repository"$ENDCOLOR
#		/usr/bin/notify-send "Adding the VirtualBox Repository"
#		sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian $CODENAME contrib"
#		wget http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
#	fi
#	UPDATEREQUIRED="YES"
#	return
#}
function WinePrep()
{
	if [ -f /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list ]
	then
		echo -e $GREEN"*Wine Repository Found*"$ENDCOLOR
		/usr/bin/notify-send "Wine Repository Found"
	else
		echo "=================================================="
		echo -e $BLUE"Adding the Wine PPA"$ENDCOLOR
		/usr/bin/notify-send "Adding the Wine PPA"
		sudo add-apt-repository ppa:alexandre-montplaisir/winepulse
	fi
	UPDATEREQUIRED="YES"
	return
}
function Hardware()
{
	echo "=================================================="
	echo -e $RED"Proprietary Hardware Installation..."$ENDCOLOR
	/usr/bin/notify-send "Proprietary Hardware Installation..."
	sudo apt-get -y install linux-firmware-nonfree
	jockey-gtk
	RESTART="YES"
	return
}
function Accelerate()
{
	ACCEL=$(cat /etc/rc.local | grep "mkdir -p /dev/cgroup/cpu")
	if [ $? = 0 ]
	then
		echo -e $RED"=================================================="$ENDCOLOR
		echo -e $RED"Acceleration Has Already Been Applied!"$ENDCOLOR
		/usr/bin/notify-send "Acceleration Has Already Been Applied!"
	else
		echo -e $BLUE"=================================================="$ENDCOLOR
		echo -e $BLUE"Applying Acceleration by Modifying Task Scheduling."$ENDCOLOR
		/usr/bin/notify-send "Applying Acceleration by Modifying Task Scheduling."
		cat /etc/rc.local | grep -v "exit 0" > ./rc.local
		echo "mkdir -p /dev/cgroup/cpu" >> ./rc.local
		echo "mount -t cgroup cgroup /dev/cgroup/cpu -o cpu" >> ./rc.local
		echo "mkdir -m 0777 /dev/cgroup/cpu/user" >> ./rc.local
		echo "echo \"/usr/local/sbin/cgroup_clean\" > /dev/cgroup/cpu/release_agent" >> ./rc.local
		echo "exit 0" >> ./rc.local
		sudo mv ./rc.local /etc/rc.local
		sudo chmod +x /etc/rc.local
		echo "if [ \"\$PS1\" ] ; then" >> ~/.bashrc
		echo "   mkdir -m 0700 /dev/cgroup/cpu/user/\$\$" >> ~/.bashrc
		echo "   echo \$\$ > /dev/cgroup/cpu/user/\$\$/tasks" >> ~/.bashrc
		echo "   echo \"1\" > /dev/cgroup/cpu/user/\$\$/notify_on_release" >> ~/.bashrc
		echo "fi" >> ~/.bashrc
		if [ -f /usr/local/sbin/cgroup_clean ]
		then
			cp /usr/local/sbin/cgroup_clean ./cgroup_clean
		else
			touch ./cgroup_clean
		fi
		echo "#!/bin/sh" >> ./cgroup_clean
		echo "rmdir /dev/cgroup/cpu/\$*" >> ./cgroup_clean
		sudo mv ./cgroup_clean /usr/local/sbin/cgroup_clean
		sudo chmod +x /usr/local/sbin/cgroup_clean
		echo -e $BLUE"Acceleration will occur at next restart."$ENDCOLOR
		/usr/bin/notify-send "Acceleration will occur at next restart."
		RESTART="YES"
	fi
	return
}
function Acrobat()
{
	echo "=================================================="
	echo -e $RED"Installing Adobe Acrobat Reader"$ENDCOLOR
	/usr/bin/notify-send "Installing Adobe Acrobat Reader"
	/usr/bin/notify-send "Displaying Adobe end user license agreements.  Opening Firefox"
	firefox http://www.adobe.com/products/eulas/&
	zenity --question --text="Do you agree to the terms of end user license agreement (EULA) of Adobe Acrobat Reader?"
	if [ $? == 0 ]
	then
		/usr/bin/notify-send "Installing Adobe Acrobat Reader"
		wget http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.4.0/enu/AdbeRdr9.4-1_i486linux_enu.bin
		chmod a+x ./AdbeRdr*	
		sudo ./AdbeRdr*
		rm ./AdbeRdr*
	fi
	return
}
function Artha()
{
	echo "=================================================="
	echo -e $RED"Installing Artha Dictionary"$ENDCOLOR
	/usr/bin/notify-send "Installing Artha Dictionary"
	sudo apt-get -y install wordnet
	if [ $ARCHITECTURE = "i686" ]
	then
		wget http://downloads.sourceforge.net/project/artha/artha/1.0.2/artha_1.0.2-1_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget http://downloads.sourceforge.net/project/artha/artha/1.0.2/artha_1.0.2-1_amd64.deb
	fi
	sudo dpkg -i ./artha*
	rm ./artha*
	return
}
function Blueman()
{
	echo "=================================================="
	echo -e $RED"Installing Bluetooth Manager"$ENDCOLOR
	/usr/bin/notify-send "Installing Bluetooth Manager"
	sudo apt-get -y install blueman
	return
}
function Boxee()
{
	echo "=================================================="
	/usr/bin/notify-send "Displaying Boxee terms of use and privacy policy.  Starting Firefox"
	firefox http://www.boxee.tv/tou http://www.boxee.tv/privacy&
	zenity --question --text="Do you agree to the terms of use and privacy policy of Boxee?"
	if [ $? == 0 ]
	then
		echo -e $RED"Installing Boxee Internet TV"$ENDCOLOR
		/usr/bin/notify-send "Installing Boxee Internet TV"
		sudo apt-get --force-yes -y install boxee
		y=$(dpkg -l | grep firefox | awk 'NR>0{ print $2; exit }')
		if [ $y = "firefox" ]
		then
			/usr/bin/notify-send "You will have to create an account in order to use Boxee.  Starting Firefox"
			firefox http://www.boxee.tv/signup/?download=ubuntu&
		fi
	fi
	return
}
function Cairo()
{
		echo "=================================================="
		echo -e $RED"Installing Cairo Dock"$ENDCOLOR
		/usr/bin/notify-send "Installing Cairo Dock"
		sudo apt-get -y install cairo-dock cairo-dock-plug-ins
	return
}
function Cinelerra()
{
	echo "=================================================="
	echo -e $RED"Installing Cinelerra video editor (From Source)"$ENDCOLOR
	/usr/bin/notify-send "Installing Cinelerra video editor (From Source)"
	echo -e $RED"This May Take a While..."$ENDCOLOR
	/usr/bin/notify-send "This May Take a While..."
	sudo apt-get -y install git-core build-essential autoconf automake1.9 libtool nasm yasm gettext xorg-dev libasound2-dev libogg-dev libvorbis-dev libtheora-dev libopenexr-dev libdv4-dev libpng12-dev libjpeg62-dev libx264-dev uuid-dev mjpegtools libmjpegtools-dev libfftw3-dev liba52-0.7.4-dev libmp3lame0 libmp3lame-dev libsndfile1-dev libfaac-dev libfaad-dev libesd0-dev libavc1394-dev libraw1394-dev libiec61883-dev libtiff4-dev libxxf86vm-dev libglu1-mesa-dev
	git clone git://git.cinelerra.org/j6t/cinelerra.git cinelerra-cv
	cd cinelerra-cv
	if [ $ARCHITECTURE = "i686" ]
	then
		./autogen.sh
		./configure --with-buildinfo=git/recompile --enable-mmx --without-pic
		make
		sudo make install
		sudo ldconfig
		cp /etc/sysctl.conf ./sysctl.conf
		echo "kernel/shmmax=0x7fffffff" >> ./sysctl.conf
		sudo mv ./sysctl.conf /etc/sysctl.conf
		sudo sysctl -p
		cd ..
		echo "=================================================="
		echo -e $RED"Creating Cinelerra Desktop Icon"$ENDCOLOR
		/usr/bin/notify-send "Creating Cinelerra Desktop Icon"
		echo "#!/usr/bin/env xdg-open" > ~/Desktop/Cinelerra.desktop
		echo "[Desktop Entry]" >> ~/Desktop/Cinelerra.desktop
		echo "Version=1.0" >> ~/Desktop/Cinelerra.desktop
		echo "Type=Application" >> ~/Desktop/Cinelerra.desktop
		echo "Terminal=false" >> ~/Desktop/Cinelerra.desktop
		echo "Icon[en_US]=cinelerra" >> ~/Desktop/Cinelerra.desktop
		echo "Name[en_US]=Cinelerra" >> ~/Desktop/Cinelerra.desktop
		echo "Exec=cinelerra" >> ~/Desktop/Cinelerra.desktop
		echo "Comment[en_US]=Video Editor" >> ~/Desktop/Cinelerra.desktop
		echo "Name=Cinelerra" >> ~/Desktop/Cinelerra.desktop
		echo "Comment=Video Editor" >> ~/Desktop/Cinelerra.desktop
		echo "Icon=cinelerra" >> ~/Desktop/Cinelerra.desktop
		chmod a+x ~/Desktop/Cinelerra.desktop
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
	echo -e $RED"Sorry - Cinelerra Installation not yet implemented for x86_64"$ENDCOLOR
	/usr/bin/notify-send "Sorry - Cinelerra Installation not yet implemented for x86_64"
#		sudo ./autogen.sh
#		sudo ./configure
#		CHANGE A VARIABLE IN A MAKE FILE (WHICH DOESN'T SEEM TO EXIST)
#		sudo make
#		sudo make install
	fi
	return
}
function Companion()
{
	echo "=================================================="
	echo -e $RED"Installing CLI Companion"$ENDCOLOR
	/usr/bin/notify-send "Installing CLI Companion"
	sudo apt-get -y install clicompanion
	return
}
function Beep()
{
	echo "=================================================="
	echo -e $RED"Disabling System Beep"$ENDCOLOR
	/usr/bin/notify-send "Disabling System Beep"
	if [ -f /etc/modprobe.d/blacklist ]
	then
		cp /etc/modprobe.d/blacklist ./blacklist
		echo blacklist pcspkr >> ./blacklist
	else
		echo blacklist pcspkr > ./blacklist
	fi
	sudo mv ./blacklist /etc/modprobe.d/blacklist
	return
}
function DockBarX()
{
	echo "=================================================="
	echo -e $RED"Installing DockBarX and Avant Window Navigator"$ENDCOLOR
	/usr/bin/notify-send "Installing DockBarX and Avant Window Navigator"
	sudo apt-get -y install dockbarx dockbarx-themes-extra awn-applet-dockbarx
	return
}
function Dolphin()
{
	echo "=================================================="
	echo -e $RED"Installing Dolphin Wii Emulator"$ENDCOLOR
	/usr/bin/notify-send "Installing Dolphin Wii Emulator"
	sudo apt-get -y install dolphin-emu
	return
}
function Dropbox()
{
	echo "=================================================="
	echo -e $RED"Installing Dropbox"$ENDCOLOR
	/usr/bin/notify-send "Installing Dropbox"
#	sudo apt-get -y install nautilus-dropbox
	if [ $ARCHITECTURE = "i686" ]
	then
		wget http://linux.dropbox.com/packages/nautilus-dropbox_0.6.7_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget http://linux.dropbox.com/packages/nautilus-dropbox_0.6.7_amd64.deb
	fi
	sudo dpkg -i ./nautilus-dropbox*
	rm ./nautilus-dropbox*
	echo -e $RED"Installing Dropbox Icons"$ENDCOLOR
	/usr/bin/notify-send "Installing Dropbox Icons"
	wget http://dl.dropbox.com/u/209989/mono-icons/dropbox-icons-mono_0.2_all.deb
	sudo dpkg -i ./dropbox-icons*
	rm ./dropbox-icons*
	return
}
function Sound()
{
	echo "=================================================="
	echo -e $RED"Enabling 5.1 Playback and Adding Audio Tools"$ENDCOLOR
	/usr/bin/notify-send "Enabling 5.1 Playback and Adding Audio Tools"
	sudo apt-get -y install audacity soundconverter
	sudo perl -pi -w -e 's/\; default-sample-channels \= 2/default-sample-channels \= 6/g;' /etc/pulse/daemon.conf
	return
}
function Enlightenment()
{
	echo "=================================================="
	echo -e $RED"Installing Enlightenment"$ENDCOLOR
	/usr/bin/notify-send "Installing Enlightenment"
	sudo apt-get -y install e17
	return
}
function Epidermis()
{
	echo "=================================================="
	echo -e $RED"Installing Epidermis"$ENDCOLOR
	/usr/bin/notify-send "Installing Epidermis"
	wget http://launchpad.net/epidermis/0.x/0.5.2/+download/epidermis_0.5.2-1_all.deb
	sudo apt-get -y install libblas3gf libgfortran3 liblapack3gf python-numpy
	sudo dpkg -i ./epidermis*
	rm ./epidermis*
	return
}
function FileZilla()
{
	echo "=================================================="
	echo -e $RED"Installing FileZilla FTP"$ENDCOLOR
	/usr/bin/notify-send "Installing FileZilla FTP"
	sudo apt-get -y install filezilla
	return
}
function Firefox()
{
	echo "=================================================="
	echo -e $RED"Installing Firefox 4"$ENDCOLOR
	/usr/bin/notify-send "Installing Firefox 4"
	sudo apt-get -y install firefox ubufox
	return
}
function Flash()
{
	echo "=================================================="
	echo -e $RED"Installing Adobe Flash Player"$ENDCOLOR
	/usr/bin/notify-send "Installing Adobe Flash Player"
	/usr/bin/notify-send "Displaying Adobe end user license agreements.  Opening Firefox"
	firefox http://www.adobe.com/products/eulas/&
	zenity --question --text="Do you agree to the terms of end user license agreement (EULA) of Adobe Flash Player?"
	if [ $? == 0 ]
	then
		if [ $ARCHITECTURE = "i686" ]
		then
			sudo apt-get -y install flashplugin-installer
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget http://download.macromedia.com/pub/labs/flashplayer10/flashplayer10_2_p3_64bit_linux_111710.tar.gz
			tar xzf flashplayer10*
			sudo cp ./libflashplayer.so /usr/lib/adobe-flashplugin/libflashplayer.so
			sudo cp ./libflashplayer.so /usr/lib/flashplugin-installer/libflashplayer.so
			sudo cp ./libflashplayer.so /usr/lib/browser-plugins/libflashplayer.so
			rm ./libflashplayer.so
			rm ./flashplayer10*
		fi
	fi
	return
}
function gImageReader()
{
	echo "=================================================="
	echo -e $RED"Installing gImageReader"$ENDCOLOR
	/usr/bin/notify-send "Installing gImageReader"
	sudo apt-get install tesseract-ocr tesseract-ocr-eng python-enchant python-enchant
	wget http://downloads.sourceforge.net/project/gimagereader/0.9/gimagereader_0.9-1_all.deb
	sudo dpkg -i ./gimagereader*
	rm ./gimagereader*
	return
}
function GMapCatcher()
{
	echo "=================================================="
	echo -e $RED"Installing GMapCatcher"$ENDCOLOR
	/usr/bin/notify-send "Installing GMapCatcher"
	wget http://gmapcatcher.googlecode.com/files/mapcatcher_0.7.5.0-1_all.deb
	sudo dpkg -i ./mapcatcher*
	rm ./mapcatcher*
	return
}
function Chrome()
{
	echo "=================================================="
	echo -e $RED"Installing Google Chrome"$ENDCOLOR
	CHROMEINSTALLED=$(dpkg -l | grep google-chrome-beta | awk '{print $2}')
	if  [ $CHROMEINSTALLED = "google-chrome-beta" ]
	then
		zenity --question --text="Google Chrome Stable conflicts with Google Chrome Beta.  Do you wish to replace the beta version with the stable?"
		if [ $? == 0 ]
		then
			echo -e $RED"Google Chrome Beta will be removed during this installation."$ENDCOLOR
		else
			return
		fi
	fi

	/usr/bin/notify-send "Displaying Google Chrome terms of service and privacy policy.  Starting Firefox"
	firefox http://www.google.com/chrome/intl/en/eula_text.html http://www.google.com/chrome/intl/en/privacy.html?platform=linux&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Google Chrome?"
	if [ $? == 0 ]
	then
		/usr/bin/notify-send "Installing Google Chrome"
		if [ $ARCHITECTURE = "i686" ]
		then
			wget http://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget http://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		fi
		sudo apt-get -f remove google-chrome-beta
		sudo dpkg -i ./google-chrome*
		rm ./google-chrome*
		echo "Acquire::http::Pipeline-Depth "0";" | sudo tee -a /etc/apt/apt.conf.d/90localsettings
	fi
	return
}
function Chrome_BETA()
{
	echo "=================================================="
	echo -e $RED"Installing Google Chrome_BETA"$ENDCOLOR
	CHROMEINSTALLED=$(dpkg -l | grep google-chrome-stable | awk '{print $2}')
	if  [ $CHROMEINSTALLED = "google-chrome-stable" ]
	then
		zenity --question --text="Google Chrome Beta conflicts with Google Chrome Stable.  Do you wish to replace the stable version with the beta?"
		if [ $? == 0 ]
		then
			echo -e $RED"Google Chrome Stable will be removed during this installation."$ENDCOLOR
		else
			return
		fi
	fi
	/usr/bin/notify-send "Displaying Google Chrome Beta terms of service and privacy policy.  Starting Firefox"
	firefox http://www.google.com/chrome/intl/en/eula_text.html http://www.google.com/chrome/intl/en/privacy.html&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Google Chrome Beta?"
	if [ $? == 0 ]
	then
		/usr/bin/notify-send "Installing Google Chrome Beta"
		if [ $ARCHITECTURE = "i686" ]
		then
			wget http://dl.google.com/linux/direct/google-chrome-beta_current_i386.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget http://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb
		fi
		sudo apt-get -f remove google-chrome-stable
		sudo dpkg -i ./google-chrome*
		rm ./google-chrome*
		echo "Acquire::http::Pipeline-Depth "0";" | sudo tee -a /etc/apt/apt.conf.d/90localsettings
	fi
	return
}
function Earth()
{
	echo "=================================================="
	echo -e $RED"Installing Google Earth"$ENDCOLOR
	/usr/bin/notify-send "Installing Google Earth"
	/usr/bin/notify-send "Displaying Google Earth terms of service and privacy policy.  Starting Firefox"
	firefox http://www.google.com/intl/en/help/terms_maps_earth.html http://www.google.com/privacy.html&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Google Earth?"
	if [ $? == 0 ]
	then
		wget http://dl.google.com/earth/client/current/GoogleEarthLinux.bin
		sudo chmod a+x ./GoogleEarthLinux.bin
		./GoogleEarthLinux.bin --target GoogleEarthFixed
		mv ./GoogleEarthFixed/setup.data/bin/Linux/x86/setup.gtk ./GoogleEarthFixed/setup.data/bin/Linux/x86/setup.gtk2
		sudo ./GoogleEarthFixed/setup.sh
		rm ./GoogleEarthLinux.bin
		rm -Rf ./GoogleEarthFixed
	fi
	return
}
function Picasa()
{
	echo "=================================================="
	echo -e $RED"Installing Google Picasa"$ENDCOLOR
	/usr/bin/notify-send "Installing Google Picasa"
	/usr/bin/notify-send "Displaying Google Picasa terms.  Starting Firefox"
	firefox http://picasa.google.com/terms.html&
	zenity --question --text="Do you agree to the terms of Google Picasa?"
	if [ $? == 0 ]
	then
		sudo apt-get install picasa
	fi
	return
}
function Voice()
{
	echo "=================================================="
	echo -e $RED"Installing Google Voice and Video Chat Plugin"$ENDCOLOR
	/usr/bin/notify-send "Displaying Google Voice and Video Chat Plugin terms of service and privacy policy.  Starting Firefox"
	firefox http://www.google.com/talk/intl/en/terms.html http://www.google.com/talk/intl/en/privacy.html&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Google Voice and Video Chat Plugin?"
	if [ $? == 0 ]
	then
		/usr/bin/notify-send "Installing Google Voice and Video Chat Plugin"
		if [ $ARCHITECTURE = "i686" ]
		then
			wget http://dl.google.com/linux/direct/google-talkplugin_current_i386.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget http://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb
		fi
		sudo dpkg -i ./google-talkplugin*
		rm ./google-talkplugin*
	fi
	return
}
function GtalX()
{
	echo "=================================================="
	echo -e $RED"Installing GtalX"$ENDCOLOR
	/usr/bin/notify-send "Installing GtalX"
	if [ $ARCHITECTURE = "i686" ]
	then
		wget http://sites.google.com/site/jozsefbekes/Home/gtalx/gtalx_0.0.5_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget http://sites.google.com/site/jozsefbekes/Home/gtalx/gtalx_0.0.5_amd64.deb
	fi
	sudo apt-get install libqt4-gui libmediastreamer0 libortp8
	sudo dpkg -i ./gtalx*
	rm ./gtalx*
	return
}
function GUFW()
{
	echo "=================================================="
	echo -e $RED"Installing GUFW"$ENDCOLOR
	/usr/bin/notify-send "Installing GUFW"
	sudo apt-get -y install gufw
	sudo ufw enable
	echo -e $RED"To modify firewall settings click on System->Administration->Firewall configuration"$ENDCOLOR
	/usr/bin/notify-send "To modify firewall settings click on System->Administration->Firewall configuration"
	return
}
function Hulu()
{
	echo "=================================================="
	echo -e $RED"Installing Hulu"$ENDCOLOR
	/usr/bin/notify-send "Installing Hulu"
	/usr/bin/notify-send "Displaying Hulu terms of service and privacy policy.  Starting Firefox"
	firefox http://www.hulu.com/terms http://www.hulu.com/privacy&
	zenity --question --text="Do you agree to the terms of service and privacy policy of Hulu?"
	if [ $? == 0 ]
	then
		if [ $ARCHITECTURE = "i686" ]
		then
			wget http://download.hulu.com/huludesktop_i386.deb
		fi
		if [ $ARCHITECTURE = "x86_64" ]
		then
			wget http://download.hulu.com/huludesktop_amd64.deb
		fi
		sudo dpkg -i ./huludesktop*
		rm ./huludesktop*
		cat ~/.huludesktop | sed 's/adobe-flashplugin/flashplugin-installer/g' > ./huluconfig
		mv ./huluconfig ~/.huludesktop
	fi
	return
}
function Java()
{
	echo "=================================================="
	echo -e $RED"Installing Java 6"$ENDCOLOR
	/usr/bin/notify-send "Installing Java 6"
	sudo apt-get -y install sun-java6-jre sun-java6-plugin
	return
}
function Burner()
{
	echo "=================================================="
	echo -e $RED"Installing K3B"$ENDCOLOR
	/usr/bin/notify-send "Installing K3B"
	sudo apt-get -y install k3b
	return
}
function KDE()
{
	echo "=================================================="
	echo -e $RED"Installing KDE 3.5"$ENDCOLOR
	/usr/bin/notify-send "Installing KDE 3.5"
	sudo apt-get -y install kubuntu-desktop-kde3
	return
}
function KDE46()
{
	echo "=================================================="
	echo -e $RED"Installing KDE 4.6"$ENDCOLOR
	/usr/bin/notify-send "Installing KDE 4.6"
	sudo apt-get -y install kubuntu-desktop
	return
}
function Libre()
{
	echo "=================================================="
	echo -e $RED"Removing Open Office"$ENDCOLOR
	/usr/bin/notify-send "Removing Open Office"
	sudo apt-get -y purge openoffice*.*
	echo -e $RED"Installing Libre Office and Extensions"$ENDCOLOR
	/usr/bin/notify-send "Installing Libre Office and Extensions"
	sudo apt-get install -y libreoffice libreoffice-gnome
	wget http://openatd.svn.wordpress.org/atd-openoffice/release/atd-openoffice-0.3.oxt
	if [ $ARCHITECTURE = "i686" ]
	then
		wget http://extensions.services.openoffice.org/e-files/874/29/oracle-pdfimport.oxt
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget http://extensions.services.openoffice.org/e-files/874/30/oracle-pdfimport.oxt
	fi
	libreoffice ./atd-openoffice-0.3.oxt ./oracle-pdfimport.oxt
        read -sn 1 -p "Waiting for LibreOffice extension installation. Press any key to continue…
"
	rm ./atd-openoffice*
	rm ./oracle-pdfimport*
	return
}
function Lucidor()
{
	echo "=================================================="
	echo -e $RED"Installing Lucidor E-Book Reader"$ENDCOLOR
	/usr/bin/notify-send "Installing Lucidor E-Book Reader"
	wget http://lucidor.org/lucidor/lucidor_0.9.3-1_all.deb
	sudo dpkg -i lucidor*
	rm ./lucidor*
	return
}
function Restricted()
{
	echo "=================================================="
	echo -e $RED"Installing Media Players, Codecs & Restricted Extras"$ENDCOLOR
	/usr/bin/notify-send "Installing Restricted Extras & Codecs"
	if [ $ARCHITECTURE = "i686" ]
	then
		sudo apt-get --force-yes install ubuntu-restricted-extras non-free-codecs libdvdcss2 && sudo apt-get -y install w32codecs libdvdcss2 freepats app-install-data-medibuntu apport-hooks-medibuntu vlc vlc-plugin-pulse gxine libvlc5 libvlccore4 vlc-data libxine1 libxine1-bin libxine1-console libxine1-ffmpeg libxine1-misc-plugins libxine1-plugins libxine1-x mplayer smplayer minitube miro mencoder gthumb mozilla-plugin-vlc freetuxtv totem-plugins-extra exaile
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		sudo apt-get --force-yes install ubuntu-restricted-extras non-free-codecs libdvdcss2 && sudo apt-get -y install w64codecs libdvdcss2 freepats app-install-data-medibuntu apport-hooks-medibuntu vlc vlc-plugin-pulse gxine libvlc5 libvlccore4 vlc-data libxine1 libxine1-bin libxine1-console libxine1-ffmpeg libxine1-misc-plugins libxine1-plugins libxine1-x mplayer smplayer minitube miro mencoder gthumb mozilla-plugin-vlc freetuxtv totem totem-common totem-mozilla totem-plugins-extra exaile
	fi
	mkdir -p ~/.local/share/totem/plugins/airplay
	git clone http://git.sukimashita.com/totem-plugin-airplay.git
	mv totem-plugin-airplay/* ~/.local/share/totem/plugins/airplay/
	rm -rf ./totem-plugin-airplay
	echo -e $RED"Airplay support can be enabled in Totem (Movie Player) under the Edit -> Plugins... menu"$ENDCOLOR
	/usr/bin/notify-send "Airplay support can be enabled in Totem (Movie Player) under the Edit -> Plugins... menu"
	return
}
function Move()
{
	echo "=================================================="
	echo -e $RED"Moving Window Buttons to the Right"$ENDCOLOR
	/usr/bin/notify-send "Moving Window Buttons to the Right"
	sudo -u $ON_USER "DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS gconftool-2 --type string --set /apps/metacity/general/button_layout ":minimize,maximize,close"
	return
}
function Fonts()
{
	echo "=================================================="
	echo -e $RED"Installing MS Fonts and NTFS Support"$ENDCOLOR
	/usr/bin/notify-send "Installing MS Fonts and NTFS Support"
	sudo apt-get -y --force-yes install ttf-mscorefonts-installer ntfsprogs gparted app-install-data-medibuntu apport-hooks-medibuntu && sudo fc-cache -fv
	return
}
function Octoshape()
{
	echo "=================================================="
	echo -e $RED"Installing Octoshape"$ENDCOLOR
	/usr/bin/notify-send "Installing Octoshape"
	if [ -e /usr/lib/libcrypto.so.0.9.8 ]
	then
		echo -e $GREEN"libssl0.9.8 (libcrypto) Verified"$ENDCOLOR
	else
		echo -e $RED"libssl0.9.8 (libcrypto) is needed for Octoshape to run properly.  Installing libssl0.9.8 (libcrypto) "$ENDCOLOR
		sudo apt-get -y install libssl0.9.8
	fi
	if [ -e /usr/bin/mplayer ]
	then
		echo -e $GREEN"mplayer Verified"$ENDCOLOR
	else
		echo -e $RED"mplayer is needed for Octoshape to run properly.  Installing mplayer "$ENDCOLOR
		sudo apt-get -y install mplayer
	fi
	wget http://www.octoshape.com/files/octosetup-linux_i386.bin
	mv ./octosetup-linux_i386.bin ~/octosetup-linux_i386.bin
	cd ~
	chmod a+x ~/octosetup-linux_i386.bin
	~/octosetup-linux_i386.bin
	rm ~/octosetup-linux_i386.bin
	echo "=================================================="
	echo -e $RED"Creating Desktop Icon"$ENDCOLOR
	rm ~/Desktop/Octoshape.sh
	echo "URL=\$(zenity --entry --title=\"Octoshape\" --text=\"Enter a URL:\")" > ~/Desktop/Octoshape.sh
	echo -e "echo -e \"Opening \$URL\"" >> ~/Desktop/Octoshape.sh
	echo -e "/usr/bin/notify-send \"Opening \$URL\"" >> ~/Desktop/Octoshape.sh
	echo -e "~/octoshape/OctoshapeClient -url:\$URL" >> ~/Desktop/Octoshape.sh
	chmod a+x ~/Desktop/Octoshape.sh
	return
}
function OpenShot()
{
	echo "=================================================="
	echo -e $RED"Installing OpenShot"$ENDCOLOR
	/usr/bin/notify-send "Installing OpenShot"
	sudo apt-get --force-yes install openshot melt libmlt2
	return
}
function Pithos()
{
	echo "=================================================="
	echo -e $RED"Installing Pithos"$ENDCOLOR
	/usr/bin/notify-send "Installing Pithos"
	sudo apt-get --force-yes install pithos
	return
}
function Prey()
{
	echo "=================================================="
	echo -e $RED"Installing Prey"$ENDCOLOR
	/usr/bin/notify-send "Installing Prey"
	sudo apt-get -y install scrot streamer libio-socket-ssl-perl libnet-ssleay-perl mpg123 festival traceroute
	wget http://preyproject.com/releases/0.5.1/prey_0.5.1-ubuntu2_all.deb
	sudo dpkg -i prey*
	rm ./prey*
	return
}
function Remobo()
{
	echo "=================================================="
	echo -e $RED"Installing Remobo IPN"$ENDCOLOR
	/usr/bin/notify-send "Installing Remobo IPN"
	if [ $ARCHITECTURE = "i686" ]
	then
		wget http://www.remobo.com/dl.php?p=debs/i386/remobo_0.40.10-1_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget http://www.remobo.com/dl.php?p=debs/x86_64/remobo_0.40.10-1_x86_64.deb
	fi
	sudo dpkg -i remobo*
	rm ./remobo*
	return
}
function SBackup()
{
	echo "=================================================="
	echo -e $RED"Installing SBackup"$ENDCOLOR
	/usr/bin/notify-send "Installing SBackup"
	sudo apt-get -y install sbackup
	return
}
function Skype()
{
	echo "=================================================="
	echo -e $RED"Installing Skype"$ENDCOLOR
	/usr/bin/notify-send "Installing Skype"
	sudo apt-get -y install skype app-install-data-medibuntu apport-hooks-medibuntu
	return
}
function Terminal()
{
	echo "=================================================="
	echo -e $RED"Installing Terminal from Gnome Right Click"$ENDCOLOR
	/usr/bin/notify-send "Installing Terminal from Gnome Right Click"
	sudo apt-get -y install nautilus-open-terminal
	return
}
function Tweak()
{
	echo "=================================================="
	echo -e $RED"Installing Ubuntu Tweak"$ENDCOLOR
	/usr/bin/notify-send "Installing Ubuntu Tweak"
	sudo apt-get -y install ubuntu-tweak
	return
}
function VirtualBox()
{
	echo "=================================================="
	echo -e $RED"Installing VirtualBox"$ENDCOLOR
	/usr/bin/notify-send "Installing VirtualBox"
#	sudo apt-get -y install virtualbox-4.0
	if [ $ARCHITECTURE = "i686" ]
	then
		wget http://download.virtualbox.org/virtualbox/4.0.4/virtualbox-4.0_4.0.4-70112~Ubuntu~maverick_i386.deb
	fi
	if [ $ARCHITECTURE = "x86_64" ]
	then
		wget http://download.virtualbox.org/virtualbox/4.0.4/virtualbox-4.0_4.0.4-70112~Ubuntu~maverick_amd64.deb
	fi
	sudo apt-get -y install libqt4-network libqt4-opengl libqtcore4 libqtgui4 libsdl-ttf2.0-0 libaudio2 libmng1 libqt4-dbus libqt4-xml
	sudo dpkg -i virtualbox*
	rm ./virtualbox*
	RESTART="YES"
	echo "=================================================="
	echo -e $RED"Downloading VirtualBox Extensions"$ENDCOLOR
	/usr/bin/notify-send "Downloading VirtualBox Extensions"
	wget http://download.virtualbox.org/virtualbox/4.0.4/Oracle_VM_VirtualBox_Extension_Pack-4.0.4-70112.vbox-extpack
	echo "=================================================="
	sudo /etc/init.d/vboxdrv.dpkg-new setup
	virtualbox&
	echo -e $RED"Starting VirtualBox"$ENDCOLOR
	/usr/bin/notify-send "Starting VirtualBox"
	echo -e $RED"To Add Extensions, Select File -> Preferences -> Extensions, Click on the blue diamond and select the file"$ENDCOLOR
	/usr/bin/notify-send "To Add Extensions, Select File -> Preferences -> Extensions, Click on the blue diamond and select the file"
	read -sn 1 -p "Press any key to continue…"
	return
}
function Mono()
{
	echo "=================================================="
	echo -e $RED"Uninstalling Mono"$ENDCOLOR
	/usr/bin/notify-send "Uninstalling Mono..."
	sudo apt-get purge cli-common mono-runtime libmono*
	echo "Package: cli-common mono-runtime" > ./preferences
	echo "Pin: version *" >> ./preferences
	echo "Pin-Priority: -100" >> ./preferences
	sudo mv ./preferences /etc/apt/preferences
	return
}
function Wine()
{
	echo "=================================================="
	echo -e $RED"Installing Wine with Pulse Patch"$ENDCOLOR
	/usr/bin/notify-send "Installing Wine with Pulse Patch"
	sudo apt-get -y install wine
	return
}
echo -e  $GREEN"BleedingEdge for Ubuntu version $VERSION\n\nCopyright 2009-2011 Paul Fedele.\n\nGPLv3 Licensed.\n\nRun this script in a terminal.\n\nThis script adds software from sources which are not under its control.\n\nNo warranty or guarantee of suitability exists for this software.\n\nUse at your own risk.\n\n"$ENDCOLOR
if [ $CODENAME != $DISTROBUTION ]
then
	echo -e  $RED"Sorry, you are using Ubuntu $CODENAME.  Only Ubuntu $DISTROBUTION is supported.  Program Terminated"$ENDCOLOR
	/usr/bin/notify-send "Sorry, you are using Ubuntu $CODENAME.  Only Ubuntu $DISTROBUTION is supported.  Program Terminated"
	exit 1
fi
if [ $ARCHITECTURE != "i686" ]
then
	if [ $ARCHITECTURE != "x86_64" ]
	then
       	echo -e  $RED"Sorry, only i686 and x86_64 architectures are supported."$ENDCOLOR
	exit 1
	fi
fi
while ps -U root -u root u | grep "synaptic" | grep -v grep > /dev/null;
       do 
       echo -e $RED"Installation can't continue. Please close Synaptic first then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done
while ps -e | grep "update-manager" | grep -v grep > /dev/null;
       do
       echo -e $RED"Installation can't continue. Please close Update Manager first then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done
while ps -U root -u root u | grep "software-center" | grep -v grep > /dev/null;
       do 
       echo -e $RED"Installation can't continue. Please close Software Center first then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done 
while ps -U root -u root u | grep "apt-get" | grep -v grep > /dev/null;
       do
       echo -e $RED"Installation can't continue. Please wait for apt-get to finish running, or terminate the process, then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done       
while ps -U root -u root u | grep "dpkg" | grep -v grep > /dev/null;
       do 
       echo -e $RED"Installation can't continue. Wait for dpkg to finish running, or exit it, then try again."$ENDCOLOR
       read -sn 1 -p "Press any key to continue…
"
done       
TESTCONNECTION=`wget --tries=3 --timeout=15 www.google.com -O /tmp/testinternet &>/dev/null 2>&1`
if [ $? != 0 ]
then
	echo -e $RED"You are not connected to the Internet. Please check your Internet connection and try again."$ENDCOLOR
else
	echo -e $GREEN"Internet Connection Verified"$ENDCOLOR
fi
if [ -e /usr/bin/wget ]
then
	echo -e $GREEN"Wget Verified"$ENDCOLOR
else
	echo -e $RED"Wget is needed for this script to run properly.  Installing wget"$ENDCOLOR
	sudo apt-get -y install wget
fi
if [ -e /usr/bin/zenity ]
then
	echo -e $GREEN"Zenity Verified"$ENDCOLOR
else
	echo -e $RED"Zenity is needed for this script to run properly.  Installing Zenity"$ENDCOLOR
	sudo apt-get -y install zenity
fi
if [ -e /usr/bin/notify-send ]
then
	echo -e  $GREEN"Notify-osd Verified"$ENDCOLOR
else
	echo -e  $RED"notify-osd is needed for this script to run properly.  Installing notify-osd"$ENDCOLOR
	sudo apt-get -y install notify-osd libnotify-bin
fi
echo -e  $BLUE"Checking for Latest Version"$ENDCOLOR
wget http://sourceforge.net/projects/bleedingedge/files/index.html
LATEST=$(cat ./index.html | grep Click | head -n 2 | tail -n 1 | awk '{sub("title=\"Click to download BleedingEdge", ""); sub(".sh\"", ""); print $1}')
rm ./index.html
if [ $VERSION = $LATEST ]
then
	echo -e  $GREEN"Latest Version Verified"$ENDCOLOR
else
	echo -e  $RED"BleedingEdge Version $VERSION is obsolete.  Latest version available is $LATEST"$ENDCOLOR
	zenity --question --text="You are using BleedingEdge $VERSION .\n\nThe latest version available is $LATEST .\n\nDo you wish to download version $LATEST ?"
	if [ $? == 0 ]
	then
		wget http://downloads.sourceforge.net/project/bleedingedge/BleedingEdge$LATEST.sh
		chmod u+x ./BleedingEdge$LATEST.sh
        	exec ./BleedingEdge$LATEST.sh&
		exit 0
	fi
fi
zenity --question --text="BleedingEdge for Ubuntu version $VERSION\n\nCopyright 2009-2011 Paul Fedele.\n\nGPLv3 Licensed.\n\nRun this script in a terminal.\n\nThis script adds software from sources which are not under its control.\n\nNo warranty or guarantee of suitability exists for this software.\n\nUse at your own risk.\n\nAre you sure you wish to proceed?"
if [ $? == 1 ]
then
	/usr/bin/notify-send "Program Terminated"
	exit 0
fi
/usr/bin/notify-send "Making sure that packages are up to date before installing anything."
zenity --question --text="Updates may be required before continuing\n\nDo you wish to update?"
if [ $? == 0 ]
then
	sudo apt-get update
	zenity --info --text="If the update software pops up, use it before continuing with this script."
fi
ans=$(zenity  --list  --width=600 --height=670 --text "BleedingEdge Ubuntu $CODENAME Installations and Modifications" --checklist  --column "Select" --column "Options" FALSE "Accelerate (Task Scheduler)" FALSE "Acrobat Reader" FALSE "Additional Repositories" FALSE "Artha Dictionary" FALSE "Blueman Bluetooth Manager" FALSE "Boxee Internet TV" FALSE "Cairo Dock" FALSE "Cinelerra video editor (From Source)" FALSE "CLI Companion" FALSE "Disable Annoying System Beep" FALSE "DockBarX and Avant Window Navigator" FALSE "Dolphin Wii Emulator" FALSE "Dropbox" FALSE "Enable 5.1 Sound and Audio Tools" FALSE "Enlightenment E17" FALSE "Epidermis" FALSE "FileZilla FTP" FALSE "Firefox 4" FALSE "Flash Player" FALSE "Getdeb & Playdeb Repos" FALSE "gImageReader (OCR)" FALSE "GMapCatcher" FALSE "Google Chrome 10" FALSE "Google Earth" FALSE "Google Picasa" FALSE "Google Voice and Video Chat Plugin" FALSE "GtalX" FALSE "GUFW Firewall" FALSE "Hulu - Flash Required" FALSE "Java 6" FALSE "K3B CD and DVD Burner" FALSE "KDE 3.5" FALSE "KDE 4.6" FALSE "Libre Office with PDF and Grammar Extensions (Remove Open Office)" FALSE "Lucidor E-book Reader" FALSE "Media Players, Codecs, and Restricted Extras" FALSE "Move window buttons to the right" FALSE "MS Core Fonts & NTFS" FALSE "Octoshape Player" FALSE "OpenShot Video Editor" FALSE "Pithos (Pandora App)" FALSE "Prey PC Tracker" FALSE "Proprietary Hardware Drivers" FALSE "Remobo IPN" FALSE "SBackup" FALSE "Skype" FALSE "Terminal from Gnome Right Click" FALSE "Ubuntu Tweak" FALSE "VirtualBox 4.0" FALSE "Wine with Pulse Patch" FALSE "Uninstall Mono" --separator=":")
if [ $? == 1 ]
then
	/usr/bin/notify-send "Program Terminated"
	exit 0
fi
arr=$(echo $ans | tr "\:" "\n")
clear
for x in $arr
do
	if [ $x = "Blueman" ]
	then
		BluemanPrep
	fi
	if [ $x = "Boxee" ]
	then
		BoxeePrep
	fi
	if [ $x = "Cairo" ]
	then
		CairoPrep
	fi
	if [ $x = "Companion" ]
	then
		CompanionPrep
	fi
	if [ $x = "DockBarX" ]
	then
		DockBarXPrep
	fi
	if [ $x = "Dolphin" ]
	then
		DolphinPrep
	fi
	if [ $x = "DropBox" ]
	then
		DropBoxPrep
	fi
	if [ $x = "Enlightenment" ]
	then
		EnlightenmentPrep
	fi
	if [ $x = "Firefox" ]
	then
		FirefoxPrep
	fi
	if [ $x = "Flash" ]
	then
		FlashPrep
	fi
	if [ $x = "Getdeb" ]
	then
		GetdebPrep
	fi
	if [ $x = "gImageReader" ]
	then
		gImageReaderPrep
	fi
	if [ $x = "Picasa" ]
	then
		PicasaPrep
	fi
	if [ $x = "3.5" ]
	then
		KDEPrep
	fi
	if [ $x = "4.6" ]
	then
		KDE46Prep
	fi
	if [ $x = "Fonts" ]
	then
		FontsPrep
	fi
	if [ $x = "Libre" ]
	then
		LibrePrep
	fi
	if [ $x = "OpenShot" ]
	then
		OpenShotPrep
	fi
	if [ $x = "Pithos" ]
	then
		PithosPrep
	fi
	if [ $x = "Repositories" ]
	then
		RepositoriesPrep
	fi
	if [ $x = "Restricted" ]
	then
		RestrictedPrep
	fi
	if [ $x = "Skype" ]
	then
		SkypePrep
	fi
	if [ $x = "Tweak" ]
	then
		TweakPrep
	fi
#	if [ $x = "VirtualBox" ]
#	then
#		VirtualBoxPrep
#	fi
	if [ $x = "Wine" ]
	then
		WinePrep
	fi
done
if [ $UPDATEREQUIRED = "YES" ]
then
	sudo apt-get -q update
fi
for x in $arr
do
	if [ $x = "Hardware" ]
	then
		Hardware
	fi
	if [ $x = "Accelerate" ]
	then
		Accelerate
	fi
	if [ $x = "Acrobat" ]
	then
		Acrobat
	fi
	if [ $x = "Artha" ]
	then
		Artha
	fi
	if [ $x = "Blueman" ]
	then
		Blueman
	fi
	if [ $x = "Boxee" ]
	then
		Boxee
	fi
	if [ $x = "Cairo" ]
	then
		Cairo
	fi
	if [ $x = "Cinelerra" ]
	then
		Cinelerra
	fi
	if [ $x = "Companion" ]
	then
		Companion
	fi
	if [ $x = "Beep" ]
	then
		Beep
	fi
	if [ $x = "DockBarX" ]
	then
		DockBarX
	fi
	if [ $x = "Dolphin" ]
	then
		Dolphin
	fi
	if [ $x = "Dropbox" ]
	then
		Dropbox
	fi
	if [ $x = "Sound" ]
	then
		Sound
	fi
	if [ $x = "Enlightenment" ]
	then
		Enlightenment
	fi
	if [ $x = "Epidermis" ]
	then
		Epidermis
	fi
	if [ $x = "FileZilla" ]
	then
		FileZilla
	fi
	if [ $x = "Firefox" ]
	then
		Firefox
	fi
	if [ $x = "Flash" ]
	then
		Flash
	fi
	if [ $x = "gImageReader" ]
	then
		gImageReader
	fi
	if [ $x = "GMapCatcher" ]
	then
		GMapCatcher
	fi
	if [ $x = "Chrome" ]
	then
		Chrome
	fi
	if [ $x = "Chrome_BETA" ]
	then
		Chrome_BETA
	fi
	if [ $x = "Earth" ]
	then
		Earth
	fi
	if [ $x = "Picasa" ]
	then
		Picasa
	fi
	if [ $x = "Voice" ]
	then
		Voice
	fi
	if [ $x = "GtalX" ]
	then
		Gtalx
	fi
	if [ $x = "GUFW" ]
	then
		GUFW
	fi
	if [ $x = "Hulu" ]
	then
		Hulu
	fi
	if [ $x = "Java" ]
	then
		Java
	fi
	if [ $x = "Burner" ]
	then
		Burner
	fi
	if [ $x = "3.5" ]
	then
		KDE
	fi
	if [ $x = "4.6" ]
	then
		KDE46
	fi
	if [ $x = "Libre" ]
	then
		Libre
	fi
	if [ $x = "Lucidor" ]
	then
		Lucidor
	fi
	if [ $x = "Restricted" ]
	then
		Restricted
	fi
	if [ $x = "Move" ]
	then
		Move
	fi
	if [ $x = "Fonts" ]
	then
		Fonts
	fi
	if [ $x = "Octoshape" ]
	then
		Octoshape
	fi
	if [ $x = "OpenShot" ]
	then
		OpenShot
	fi
	if [ $x = "Pithos" ]
	then
		Pithos
	fi
	if [ $x = "Prey" ]
	then
		Prey
	fi
	if [ $x = "Remobo" ]
	then
		Remobo
	fi
	if [ $x = "SBackup" ]
	then
		SBackup
	fi
	if [ $x = "Skype" ]
	then
		Skype
	fi
	if [ $x = "Terminal" ]
	then
		Terminal
	fi
	if [ $x = "Tweak" ]
	then
		Tweak
	fi
	if [ $x = "VirtualBox" ]
	then
		VirtualBox
	fi
	if [ $x = "Wine" ]
	then
		Wine
	fi
	if [ $x = "Mono" ]
	then
		Mono
	fi
done
zenity --question --text="Would you like this program to tidy up\n\nThis involves removing locales (language files).\n\nRemoving old kernels.\n\nRemoving apt cache.\n\nRemoving config files for unused .deb packages.\n\nEmptying the trash."
if [ $? == 0 ]
then
	echo -e $BLUE"=================================================="$ENDCOLOR
	echo -e $BLUE"                 Cleaning Up"$ENDCOLOR
	echo -e $BLUE""$ENDCOLOR
	echo -e $BLUE"LocalePurge will remove language files that you do not need"$ENDCOLOR
	echo -e $BLUE"     Use the arrows, space bar, and tab if prompted"$ENDCOLOR
	echo -e $BLUE"=================================================="$ENDCOLOR
	if [ -f /usr/sbin/localepurge ]
		then
			sudo localepurge
		else
			/usr/bin/notify-send "LocalePurge will remove language files that you do not need"
			/usr/bin/notify-send "Use the arrows, space bar, and tab if prompted"
			sudo apt-get -y install localepurge
	fi
	sudo apt-get install
#	sudo apt-get autoremove --purge
	sudo apt-get clean
	sudo updatedb
#	OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')
	CURKERNEL=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
	LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
	METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
	OLDKERNELS=$(dpkg -l|awk '{print $2}'|grep -E $LINUXPKG |grep -vE $METALINUXPKG|grep -v $CURKERNEL)
	echo -e $RED"Cleaning apt cache..."$ENDCOLOR
#	sudo apt-get clean
#	echo -e $RED"Removing old config files..."$ENDCOLOR
#	sudo apt-get purge $OLDCONF
	if [ -z $OLDKERNELS ]
	then
		echo -e $BLUE"No old kernels found..."$ENDCOLOR
	else
		echo -e $RED"Removing old kernels..."$ENDCOLOR
		sudo apt-get purge $OLDKERNELS
		RESTART="1"
	fi
	echo -e $RED"Emptying the trash..."$ENDCOLOR
	rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
	rm -rf /root/.local/share/Trash/*/** &> /dev/null
fi
zenity --question --text="Would you like to remove repositories that were added while using this program?\n\nYes - Software installed by BleedingEdge will not be updated.\n\nNo - 3rd party repositories can be fickle and mess with DPKG."
if [ $? == 0 ]
then
	echo -e $BLUE"=================================================="$ENDCOLOR
	echo -e $BLUE"                 Removing Repositories"$ENDCOLOR
	echo -e $BLUE"=================================================="$ENDCOLOR
	if [ -f /etc/apt/sources.list.d/alex-p-notesalexp-maverick.list ]
	then
		echo "Removing alex-p-notesalexp-maverick.list"
		sudo rm /etc/apt/sources.list.d/alex-p-notesalexp-maverick.list
	fi
	if [ -f /etc/apt/sources.list.d/blueman.list ]
	then
		echo "Removing blueman.list"
		sudo rm /etc/apt/sources.list.d/blueman.list
	fi
	if [ -f /etc/apt/sources.list.d/boxee.list ]
	then
		echo "Removing boxee.list"
		sudo rm /etc/apt/sources.list.d/boxee.list
	fi
	if [ -f /etc/apt/sources.list.d/boxee.list.save ]
	then
		echo "Removing boxee.list.save"
		sudo rm /etc/apt/sources.list.d/boxee.list.save
	fi
	if [ -f /etc/apt/sources.list.d/cairo.list ]
	then
		echo "Removing cairo.list"
		sudo rm /etc/apt/sources.list.d/cairo.list
	fi
	if [ -f /etc/apt/sources.list.d/cinelerra.list ]
	then
		echo "Removing cinelerra.list"
		sudo rm /etc/apt/sources.list.d/cinelerra.list
	fi
	if [ -f /etc/apt/sources.list.d/clicompanion-devs-clicompanion-nightlies-$CODENAME.list ]
	then
		echo "Removing clicompanion-devs-clicompanion-nightlies-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/clicompanion-devs-clicompanion-nightlies-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list ]
	then
		echo "Removing nilarimogard-webupd8-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list ]
	then
		echo "Removing glennric-dolphin-emu-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list.save ]
	then
		echo "Removing glennric-dolphin-emu-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/glennric-dolphin-emu-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/dropbox.list ]
	then
		echo "Removing dropbox.list"
		sudo rm /etc/apt/sources.list.d/dropbox.list
	fi
	if [ -f /etc/apt/sources.list.d/enlightenment.list ]
	then
		echo "Removing enlightenment.list"
		sudo rm /etc/apt/sources.list.d/enlightenment.list
	fi
	if [ -f /etc/apt/sources.list.d/exaile-devel-ppa-maverick.list ]
	then
		echo "Removing exaile-devel-ppa-maverick.list"
		sudo rm /etc/apt/sources.list.d/exaile-devel-ppa-maverick.list
	fi
	if [ -f /etc/apt/sources.list.d/exaile-devel-ppa-maverick.list.save ]
	then
		echo "Removing exaile-devel-ppa-maverick.list.save"
		sudo rm /etc/apt/sources.list.d/exaile-devel-ppa-maverick.list.save
	fi
	if [ -f /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-maverick.list ]
	then
		echo "Removing ubuntu-mozilla-daily-ppa-maverick.list"
		sudo rm /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-maverick.list
	fi
	if [ -f /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-maverick.list.save ]
	then
		echo "Removing ubuntu-mozilla-daily-ppa-maverick.list.save"
		sudo rm /etc/apt/sources.list.d/ubuntu-mozilla-daily-ppa-maverick.list.save
	fi
	if [ -f /etc/apt/sources.list.d/freenx.list ]
	then
		echo "Removing freenx.list"
		sudo rm /etc/apt/sources.list.d/freenx.list
	fi
	if [ -f /etc/apt/sources.list.d/freetuxtv-freetuxtv-$CODENAME.list ]
	then
		echo "Removing freetuxtv-freetuxtv-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/freetuxtv-freetuxtv-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/freetuxtv-freetuxtv-$CODENAME.list.save ]
	then
		echo "Removing freetuxtv-freetuxtv-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/freetuxtv-freetuxtv-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/getdeb.list ]
	then
		echo "Removing getdeb.list"
		sudo rm /etc/apt/sources.list.d/getdeb.list
	fi
	if [ -f /etc/apt/sources.list.d/getdeb.list.save ]
	then
		echo "Removing getdeb.list.save"
		sudo rm /etc/apt/sources.list.d/getdeb.list.save
	fi
	if [ -f /etc/apt/sources.list.d/partner.list ]
	then
		echo "Removing partner.list"
		sudo rm /etc/apt/sources.list.d/partner.list
	fi
	if [ -f /etc/apt/sources.list.d/partner.list.save ]
	then
		echo "Removing partner.list.save"
		sudo rm /etc/apt/sources.list.d/partner.list.save
	fi
	if [ -f /etc/apt/sources.list.d/ubuntuzilla-4.7.4-0ubuntu1-i386.deb ]
	then
		echo "Removing ubuntuzilla-4.7.4-0ubuntu1-i386.deb"
		sudo rm /etc/apt/sources.list.d/ubuntuzilla-4.7.4-0ubuntu1-i386.deb
	fi
	if [ -f /etc/apt/sources.list.d/gnumed.list ]
	then
		echo "Removing gnumed.list"
		sudo rm /etc/apt/sources.list.d/gnumed.list
	fi
	if [ -f /etc/apt/sources.list.d/nanny.list ]
	then
		echo "Removing nanny.list"zenity --info --text="If the update software pops up, use it before continuing with this script."
		sudo rm /etc/apt/sources.list.d/nanny.list
	fi
	if [ -f /etc/apt/sources.list.d/google-chrome.list ]
	then
		echo "Removing google-chrome.list"
		sudo rm /etc/apt/sources.list.d/google-chrome.list
	fi
	if [ -f /etc/apt/sources.list.d/google-chrome.list.save ]
	then
		echo "Removing google-chrome.list.save"
		sudo rm /etc/apt/sources.list.d/google-chrome.list.save
	fi
	if [ -f /etc/apt/sources.list.d/google-talkplugin.list ]
	then
		echo "Removing google-talkplugin.list"
		sudo rm /etc/apt/sources.list.d/google-talkplugin.list
	fi
	if [ -f /etc/apt/sources.list.d/google-talkplugin.list.save ]
	then
		echo "Removing google-talkplugin.list.save"
		sudo rm /etc/apt/sources.list.d/google-talkplugin.list.save
	fi
	if [ -f /etc/apt/sources.list.d/picasa.list ]
	then
		echo "Removing picasa.list"
		sudo rm /etc/apt/sources.list.d/picasa.list
	fi
	if [ -f /etc/apt/sources.list.d/kde35.list ]
	then
		echo "Removing kde35.list"
		sudo rm /etc/apt/sources.list.d/kde35.list
	fi
	if [ -f /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list ]
	then
		echo "Removing ./kubuntu-ppa-backports-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list.save ]
	then
		echo "Removing ./kubuntu-ppa-backports-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/kubuntu-ppa-backports-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/medibuntu.list ]
	then
		echo "Removing medibuntu.list"
		sudo rm /etc/apt/sources.list.d/medibuntu.list
	fi
	if [ -f /etc/apt/sources.list.d/medibuntu.list.save ]
	then
		echo "Removing medibuntu.list.save"
		sudo rm /etc/apt/sources.list.d/medibuntu.list.save
	fi
	if [ -f /etc/apt/sources.list.d/nvidia.list ]
	then
		echo "Removing nvidia.list"
		sudo rm /etc/apt/sources.list.d/nvidia.list
	fi
	if [ -f /etc/apt/sources.list.d/libreoffice-ppa-$CODENAME.list ]
	then
		echo "Removing libreoffice-ppa-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/libreoffice-ppa-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/libreoffice-ppa-$CODENAME.list.save ]
	then
		echo "Removing libreoffice-ppa-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/libreoffice-ppa-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list ]
	then
		echo "Removing ./jonoomph-openshot-edge-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list.save ]
	then
		echo "Removing ./jonoomph-openshot-edge-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/jonoomph-openshot-edge-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list ]
	then
		echo "Removing kevin-mehall-pithos-daily-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list.save ]
	then
		echo "Removing kevin-mehall-pithos-daily-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/kevin-mehall-pithos-daily-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/playonlinux.list ]
	then
		echo "Removing playonlinux.list"
		sudo rm /etc/apt/sources.list.d/playonlinux.list
	fi
	if [ -f /etc/apt/sources.list.d/skype.list ]
	then
		echo "Removing skype.list"
		sudo rm /etc/apt/sources.list.d/skype.list
	fi
	if [ -f /etc/apt/sources.list.d/tweak.list ]
	then
		echo "Removing tweak.list"
		sudo rm /etc/apt/sources.list.d/tweak.list
	fi
	if [ -f /etc/apt/sources.list.d/tweak.list.save ]
	then
		echo "Removing tweak.list.save"
		sudo rm /etc/apt/sources.list.d/tweak.list.save
	fi
	if [ -f /etc/apt/sources.list.d/virtualbox.list ]
	then
		echo "Removing virtualbox.list"
		sudo rm /etc/apt/sources.list.d/virtualbox.list
	fi
	if [ -f /etc/apt/sources.list.d/virtualbox.list.save ]
	then
		echo "Removing virtualbox.list.save"
		sudo rm /etc/apt/sources.list.d/virtualbox.list.save
	fi
	if [ -f /etc/apt/sources.list.d/ferramroberto-vlc-$CODENAME.list ]
	then
		echo "Removing ferramroberto-vlc-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/ferramroberto-vlc-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/ferramroberto-vlc-$CODENAME.list.save ]
	then
		echo "Removing ferramroberto-vlc-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/ferramroberto-vlc-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list ]
	then
		echo "Removing nilarimogard-webupd8-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list.save ]
	then
		echo "Removing nilarimogard-webupd8-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/nilarimogard-webupd8-$CODENAME.list.save
	fi
	if [ -f /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list ]
	then
		echo "Removing alexandre-montplaisir-winepulse-$CODENAME.list"
		sudo rm /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list
	fi
	if [ -f /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list.save ]
	then
		echo "Removing alexandre-montplaisir-winepulse-$CODENAME.list.save"
		sudo rm /etc/apt/sources.list.d/alexandre-montplaisir-winepulse-$CODENAME.list.save
	fi
fi
unset CODENAME
unset ARCHITECTURE
unset OLDCONF
unset CURKERNEL
unset LINUXPKG
unset METALINUXPKG
unset OLDKERNELS
unset RED
unset BLUE
unset GREEN
unset ENDCOLOR
unset x
unset y
unset TESTCONNECTION
unset VERSION
unset LATEST
unset UPDATEREQUIRED
if [ $RESTART = "YES" ]
then
	echo -e $BLUE"Done! Restart your computer to apply the changes."$ENDCOLOR
	/usr/bin/notify-send "Done! Restart your computer to apply the changes."
else
	echo -e $GREEN"Done!  This program will end in 5 seconds."$ENDCOLOR
	/usr/bin/notify-send "Done!  This program will end in 5 seconds."
fi
unset RESTART
sleep 5
exit 0
