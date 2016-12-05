#!/bin/bash

if [ `pwd` != "/opt/complaints-queue/debian" ]
then
  echo "Buildout must be installed in /opt/complaints-queue"
  exit
fi

if [ `id -u` -ne 0 ]
then
  echo "Please run as root"
  exit
fi

DIR=complaints-queue

NAME=`awk -F: '$1~/Package/{print $2}' $DIR/DEBIAN/control`
VER=`awk -F: '$1~/Version/{print $2}' $DIR/DEBIAN/control`
ARCH=`awk -F: '$1~/Architecture/{print $2}' $DIR/DEBIAN/control`
DIST=${NAME// /}_${VER/ /}_${ARCH// /}

DIST_DIR=$DIST/opt/$DIR
DIST_ETC=$DIST/etc/$DIR

test -d $DIST && rm -r $DIST
test -f $DIST.deb && rm $DIST.deb

mkdir -p $DIST_DIR
cp -r $DIR/* $DIST
cp -r ../bin ../eggs ../src $DIST_DIR
rm -f $DIST_DIR/bin/buildout $DIST_DIR/bin/develop

mkdir -p $DIST_ETC
cp -f ../etc/*.ini $DIST_ETC

find $DIST -name \*.pyc -name \*.pyo -delete

chown -R root:root $DIST
dpkg-deb --build $DIST

