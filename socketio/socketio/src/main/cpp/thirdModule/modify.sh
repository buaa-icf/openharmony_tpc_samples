#!/bin/sh
cp ./0001-.patch ../socketio/
cd ../socketio/
git am 0001-.patch
rm -rf 0001-.patch