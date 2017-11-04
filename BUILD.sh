#!/bin/sh

(cd tools ; nodejs fakedata.js) && elm-make Main.elm --output=main.js && elm-reactor
