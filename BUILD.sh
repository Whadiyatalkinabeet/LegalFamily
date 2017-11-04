#!/bin/sh

(cd tools ; nodejs fakedata.js) && elm-make Main.elm --output=main.js && echo "Running elm-reactor for all interfaces..." && elm-reactor -a 0.0.0.0
