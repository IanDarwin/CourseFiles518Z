#!/bin/sh

# A list of GIT repos needed for this course. Gets included "(sourcced)" into 
# the main setup script, which MUST define a shell function called getagit.

for git_repo in \
	https://github.com/IanDarwin/{\
bookmarks-flutter,\
dartsrc,\
darttest,\
darttestmocks,\
expenses-server,\
fluttersrc,\
flowcase,\
jmemory,\
makehandsons,\
scripts\
} \
	https://github.com/flutter/samples \
	https://github.com:/{gskinnerTeam/flutter-wonderous-app,ErfanRht/MovieLab,RajithAshok/ThePlantApp_v2.3} \
# This line intentionally left blank. Well, at least commented
do
	getagit $git_repo
done
