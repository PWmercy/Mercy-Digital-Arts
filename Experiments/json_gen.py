#!/usr/bin/python3

import json
import os

# set to false to generate an intermediate json file
# set to true to pass generated json in as a string
stringinput = False

dialog_app = "/usr/local/bin/dialog"

contentDict = {
    "title": "An Important Message",
    "titlefont": "name=Chalkboard,colour=#3FD0a2,size=40",
    "message": "This is a **very important** messsage and you _should_ read it carefully\n\nThis is on a new line",
    "icon": "/Applications/Safari.app",
    "hideicon": 0,
    "infobutton": 1,
    "quitoninfo": 1
}

jsonString = json.dumps(contentDict)

if stringinput:
   # create a temporary file
    jsonTMPFile = "/Users/Shared/dialog2.json"
    f = open(jsonTMPFile, "w")
    f.write(jsonString)
    f.close()
    print("Using string Input")
    os.system("'{}' --jsonstring '{}'".format(dialog_app, jsonString))
else:
    print("Using file Input")

    # create a temporary file
    jsonTMPFile = "/Users/Shared/dialog.json"
    f = open(jsonTMPFile, "w")
    f.write(jsonString)
    f.close()

    os.system("'{}' --jsonfile {}".format(dialog_app, jsonTMPFile))

    # clean up
    os.remove(jsonTMPFile)
