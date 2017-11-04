#!/bin/sh

(cd tools ; nodejs fakedata.js) && elm-make Ward.elm --output=main.js && elm-reactor
