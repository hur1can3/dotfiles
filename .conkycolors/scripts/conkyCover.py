#!/usr/bin/python

import commands
from optparse import OptionParser

import PIL
from PIL import Image

#retrieve track info from player
def get_info():
    check_running = commands.getoutput("ps aux")
    check_running = check_running.split("\n")
    for line in check_running:
        if "mocp" in line:
            return commands.getoutput("mocp -Q %artist"),commands.getoutput("mocp -Q %album"),commands.getoutput("mocp -Q %song")
        if "rhythmbox" in line:
            return commands.getoutput("rhythmbox-client --print-playing-format %ta"),commands.getoutput("rhythmbox-client --print-playing-format %at"),commands.getoutput("rhythmbox-client --print-playing-format %tt")
        if "mpd" in line:
            try:
                import mpdclient2
            except:
                print "please install python-mpdclient"
                raise SystemExit()
            mpd = mpdclient2.connect()
            song = mpd.currentsong()
            if song:
                return song.artist, song.album, song.title
            else:
                return "","",""
    return "","",""
    
#resize image
def size_image(width, height, path):
    image = Image.open(path)
#    if (image.size[0]) > (image.size[1]):
#        wpercent = (height/float(image.size[0]))
#        hsize = int((float(image.size[1])*float(wpercent)))
#        image = image.resize((width,hsize), PIL.Image.ANTIALIAS)
#        image.save(path, "png")
#    else:
    hpercent = (width/float(image.size[1]))
    wsize = int((float(image.size[0])*float(hpercent)))
    image = image.resize((wsize,height), PIL.Image.ANTIALIAS)
    image.save(path, "png")

#add reflection to image    
def reflect(width, height, path):
    image = Image.open(path)
    flipped_image = image.transpose(Image.FLIP_TOP_BOTTOM)
    final_image = Image.new('RGBA', (width, (height * 2) + 1) , (0, 0, 0, 0))
    gradient = Image.new('L', (1,255))
    for y in range(255, 0, -1):
        if y < 128:
            gradient.putpixel((0,y),255 - (y * 2))
        else:
            gradient.putpixel((0,255-y),0)
    alpha = gradient.resize(flipped_image.size)
    flipped_image.putalpha(alpha)
    final_image.paste(image, (0, 0))
    final_image.paste(flipped_image, (0, height + 1))
    final_image.save(path, "png")

def check_album():
    if artist == "" and album == "":
        if os.path.exists(home + "/.album"):
            os.remove(home + "/.album")
        if os.path.exists("/tmp/trackinfo"):
            os.remove("/tmp/trackinfo")
        return False
    elif os.path.exists("/tmp/trackinfo") and open("/tmp/trackinfo").read() == artist + album:
        return False
    return True
   
#fetch album
def get_album():
    api_album = api.get_album(album, artist)
    if api_album.image["extralarge"]:
        urllib.urlretrieve(api_album.image["extralarge"], home + "/.album")
    elif api_album.image["large"]:
        urllib.urlretrieve(api_album.image["large"], home + "/.album")
    elif api_album.image["medium"]:
        urllib.urlretrieve(api_album.image["medium"], home + "/.album")
    elif api_album.image["small"]:
        urllib.urlretrieve(api_album.image["small"], home + "/.album")
    else:
        commands.getoutput("cp %s %s" % (home + "/.noalbum", home + "/.album"))
    open("/tmp/trackinfo","w").write(artist + album)
    size_image(width, height, home + album_path)
    if options.reflect:
        reflect(width, height, home + album_path)
   
def check_artist_art():
    if artist == "":
        if os.path.exists(home + "/.artist"):
            os.remove(home + "/.artist")
        if os.path.exists("/tmp/artistinfo"):
            os.remove("/tmp/artistinfo")
        return False
    elif os.path.exists("/tmp/artistinfo") and open("/tmp/artistinfo").read() == artist:
        return False
    return True
         
#fetch artist art
def get_artist_art():
    api_artist = api.get_artist(artist)
    if api_artist.image["extralarge"]:
        urllib.urlretrieve(api_artist.image["extralarge"], home + "/.artist")
    elif api_artist.image["large"]:
        urllib.urlretrieve(api_artist.image["large"], home + "/.artist")
    elif api_artist.image["medium"]:
        urllib.urlretrieve(api_artist.image["medium"], home + "/.artist")
    elif api_artist.image["small"]:
        urllib.urlretrieve(api_artist.image["small"], home + "/.artist")
    else:
        commands.getoutput("cp %s %s" % (home + "/.noalbum", home + "/.artist"))
    open("/tmp/artistinfo","w").write(artist)
    size_image(width, height, home + artist_path)
    if options.reflect:
        reflect(width, height, home + artist_path)
        
def check_similar():
    if title == "":
        if os.path.exists(home + "/.similar"):
            os.remove(home + "/.similar")
        if os.path.exists("/tmp/titleinfo"):
            os.remove("/tmp/titleinfo")
        return False
    if os.path.exists("/tmp/titleinfo") and open("/tmp/titleinfo").read() == title:
        return False
    return True

def get_similar():
    api_artist = api.get_artist(artist)
    out = ""
    for item in api_artist.get_similar(limit=5):
        out = out + item.name + "\n"
    open(home + "/.similar", "w").write(out)

#set up command line options                                        
parser = OptionParser()
parser.add_option("-s", "--size", dest="size", default="80x80", help="image size")
parser.add_option("-r", "--reflect", action="store_true", dest="reflect", default=False, help="image reflection")
parser.add_option("-a", "--artist-art", action="store_true", dest="artist_art", default=False, help="artist image")
parser.add_option("--artist", action="store_true", dest="return_artist", default=False, help="artist")
parser.add_option("--album", action="store_true", dest="return_album", default=False, help="album")
parser.add_option("--title", action="store_true", dest="return_title", default=False, help="title")
parser.add_option("--similar", action="store_true", dest="similar_artists", default=False, help="similar artists")
(options, args) = parser.parse_args()

#check if size is valid
try:
    width,height = options.size.split("x")
    width = int(width)
    height = int(height)
except:
    parser.error("please specify size in WIDTHxHEIGHT format")

artist, album, title = get_info()

#return artis, album, or title
if options.return_artist:
    print artist
    raise SystemExit()
if options.return_album:
    print album
    raise SystemExit()
if options.return_title:
    print title
    raise SystemExit()


import Image, os
#set up variables 
home = os.getenv("HOME")
album_path = "/.album"
artist_path = "/.artist"
api_key = "b25b959554ed76058ac220b7b2e0a026"

if check_artist_art() or check_album() or check_similar():
    import urllib, lastfm
    api = lastfm.Api(api_key)

if options.similar_artists and check_similar():
    get_similar()
    if os.path.exists(home + "/.similar"):
        print open(home + "/.similar").read()
    raise SystemExit()
    
if options.artist_art and check_artist_art():
    get_artist_art()
    
if check_album():
    get_album()
