#!/usr/bin/python
# -*- coding: utf-8 -*-
###############################################################################
# conkyExaile-GetCoverart.py is a simple python script to update a known
# cover art path to be refreshed on track change.
#
#  Author: Kaivalagi
# Created: 06/08/2010
from PIL import Image
from StringIO import StringIO
import eyeD3
import gobject
import os
import shutil
import sys
import traceback
import uuid

try:
    import dbus
    DBUS_AVAIL = True
except ImportError:
    # Dummy D-Bus library
    class _Connection:
        get_object = lambda *a: object()
    class _Interface:
        __init__ = lambda *a: None
        ListNames = lambda *a: []
    class Dummy: pass
    dbus = Dummy()
    dbus.Interface = _Interface
    dbus.service = Dummy()
    dbus.service.method = lambda *a: lambda f: f
    dbus.service.Object = object
    dbus.SessionBus = _Connection
    DBUS_AVAIL = False

class Exaile_GetCoverart:

    COVERART_DESTINATION = "/tmp/exaile-coverart.jpg"
    current = ""
    
    
    def __init__(self):
        
        try:
            print "conkyExaile-GetCoverart - Cover art will be copied to '%s'"%self.COVERART_DESTINATION
            print "* Initialising: Creating a D-Bus session..."
            self.bus = dbus.SessionBus()
            self.remote_object = self.bus.get_object("org.exaile.Exaile","/org/exaile/Exaile")
            self.iface = dbus.Interface(self.remote_object, "org.exaile.Exaile")
            self.iface.connect_to_signal("TrackChanged", self.OnTrackChange)
            print "* Listening: waiting for a track change..."
        except:
            print "** Error: Is Exaile running? The D-Bus service is not working."
            traceback.print_exc()
    
    def OnTrackChange(self,sender=None):
        try:

            src = self.getCoverartPath()
            
            if src == None:
                
                print "** Track Changed: No cover art images known, Checking for embedded images in audio file..."
                
                if len(self.getCoverartImage(self.COVERART_DESTINATION)) > 0:
                    print "**                Image found and extracted to %s."%self.COVERART_DESTINATION
                else:
                    print "**                No image found."
                    
            elif src == self.current:
                
                print "** Track changed: Cover art unchanged, no copy necessary"

            elif os.path.exists(src) == True:
                
                print "** Track changed: Copying '%s' to '%s'"%(src,self.COVERART_DESTINATION)
                shutil.copy(src, self.COVERART_DESTINATION)
                self.current = src
                                    
            else:
                print "** Track changed: No sure what to do: src = '%s', dst='%s'"%(src,self.COVERART_DESTINATION) 
        except:
            print "*** Error: Begin"
            traceback.print_exc()
            print "*** Error: End"
        finally:
            print "* Listening: waiting for a track change..."
                        
    def getCoverartPath(self):
        
        try:       
            imgString = "".join(chr(byte) for byte in self.iface.GetCoverData())
            if imgString:
                img = Image.open(StringIO(imgString))
                savepath = "/tmp/exaile-"+str(uuid.uuid1())+".jpg"
                img.save(savepath, "JPEG")
                return savepath
        except:
            traceback.print_exc()
            return None
            
    def getCoverartImage(self,savepath):

        # get file apth
        if "location" in self.props:
            location = self.props["location"]
        
        srcfilepath = location.replace("file://","").replace("%20"," ")
        dstfolder = os.path.dirname(savepath) 
        dstfile = savepath.replace(os.path.dirname(savepath)+"/","")
        
        tag = eyeD3.Tag()
        
        if os.path.isfile(srcfilepath):
            if os.path.splitext(srcfilepath)[1] == ".mp3":
                # Extract picture
                try:
                    tag.link(srcfilepath)
                    for image in tag.getImages():
                        image.writeFile(dstfolder, dstfile)
                        return savepath
                except:
                    print "Unable to extract image for: " + srcfilepath
                    traceback.print_exc()
        return ""


if __name__ == '__main__':
    from dbus.mainloop.glib import DBusGMainLoop
    DBusGMainLoop(set_as_default=True)
    loop = gobject.MainLoop()
    Exaile_GetCoverart()
    loop.run()
    
