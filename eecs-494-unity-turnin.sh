#!/bin/bash

DP0=$(pwd)
TURNIN=$1
UNITY=/Applications/Unity/Unity.app/Contents/MacOS/Unity
ZIP=/Applications/Keka.app/Contents/Resources/keka7z

ZIPFILE=$TURNIN.7z
APP=$TURNIN.app
EXE=$TURNIN.exe
EXEDATA=${TURNIN}_Data
REPODIR=/tmp/${TURNIN}_Repo

if [ "$1" == "" ]; then
  echo
  echo "Usage: sh ./eecs-494-unity-turnin_sh.bat TURNIN_NAME"
  echo
  exit 1
fi

for dir in $(ls -d "$APP" "$EXEDATA" 2> /dev/null); do rm -r $dir; done
for file in $(ls "$ZIPFILE" "$EXE" 2> /dev/null); do rm $file; done

echo "$UNITY" -quit -batchmode -buildOSXUniversalPlayer "$DP0/$APP" -buildWindowsPlayer "$DP0/$EXE" -projectPath "$DP0"
"$UNITY" -quit -batchmode -buildOSXUniversalPlayer "$DP0/$APP" -buildWindowsPlayer "$DP0/$EXE" -projectPath "$DP0"

for dir in $(ls -d "$REPODIR" 2> /dev/null); do rm -r $dir; done

pushd /tmp/

echo git clone "$DP0" "$REPODIR"
git clone "$DP0" "$REPODIR"

for dir in $(ls -d "$REPODIR/.git" 2> /dev/null); do rm -rf $dir; done

popd

echo "$ZIP" a "$ZIPFILE" "$APP" "$EXE" "$EXEDATA" "$REPODIR"
"$ZIP" a "$ZIPFILE" "$APP" "$EXE" "$EXEDATA" "$REPODIR"

for dir in $(ls -d "$APP" "$EXEDATA" 2> /dev/null); do rm -r $dir; done
for file in $(ls "$EXE" 2> /dev/null); do rm $file; done

echo ""

shasum -a 512 "$ZIPFILE"

exit
