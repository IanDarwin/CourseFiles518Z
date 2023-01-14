#!/bin/bash

# Set up some version numbers
INTELLIJ_VER=2022.3.1
AS_VER=2021.3.1.17
FLUTTER_VER=3.3.10-stable
MAVEN_VER=3.8.7

echo Androd Module: Installs Part One 
echo You must have installed git:
echo winget install -i Git.Git 
echo And chosen the "Unix utilities path"!

# Make sure we start in ~
cd $HOME
# Create these early to avoid accidents
mkdir bin lib

set -e # from here, bomb if error

if [ false ]; then

echo Windows Terminal - tabbed terminal with CTRL/C-CTRL-V
# winget install --id Microsoft.WindowsTerminal
echo Java JDK 17 LTS - free from numerous OpenJDK download sites
echo done  winget install --id EclipseAdoptium.Temurin.17.JDK --version 17.0.4.8
PATH="/c/Program Files/Eclipse Adoptium/jdk-17.0.4.8-hotspot/bin:$PATH"
java -version

echo IntelliJ java-only install
winget install --id JetBrains.IntelliJIDEA.Community
echo "Android Studio IDE (Ch03 to end) - free from Google (it's just JetBrains IntelliJ with extra plugins)"
winget install --id Google.AndroidStudio
echo Android SDK, tools, emulators - downloaded when starting up Studio first time

echo Flutter SDK - latest - from https://flutter.dev/
curl -o flutter.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.0.5-stable.zip
"C:\Program Files\Git\usr\bin\unzip.exe" flutter.zip > nul:
rm   flutter.zip

# Sample Code:
# DartSrc - course author's open-source Dart demo package 
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
l10n_counter_way1,\
makehandsons\
} \
	https://github.com/flutter/samples \
	https://github.com:/{gskinnerTeam/flutter-wonderous-app,ErfanRht/MovieLab,RajithAshok/ThePlantApp_v2.3} \
# This line intentionally left blank. Well, at least commented
do
	targdir=${git_repo##*/}
	if [ ! -d ${targdir} ]; then
		git clone $git_repo
	else echo $targdir already exists, skipping $git_repo
	fi
done

fi # ================== END ================

echo Tools used in preparing the course load
echo Make (gnu-make) - 
winget install --id GnuWin32.Make
echo nmap just for ncat
winget install --id Insecure.Nmap

echo Downloading maven build tool from https://maven.apache.org/download
curl https://dlcdn.apache.org/maven/maven-3/${MAVEN_VER}/binaries/apache-maven-${MAVEN_VER}-bin.tar.gz | tar xzf -

echo Documentation
curl -o Documents/LevinInternalsBookVol1FirstEdn.pdf http://newandroidbook.com/AIvI-M-RL1.pdf

cd makehandsons
CALL ..\apache-maven-3.8.6\bin\mvn.cmd -ntp -DskipTests clean package install assembly:single
copy target\makehandsons-1.0-SNAPSHOT-jar-with-dependencies.jar $HOME\lib\makehandsons.jar
copy scripts\* $HOME\bin
cd ..
git clone https://github.com/IanDarwin/CourseFiles510G
echo Generating exercise files from solutions
cd CourseFiles510G\sourcecode
make
cd ..\..

echo Chapter 3 Expenses-server - from course author, to upload expenses for Expenses app  
git clone https://github.com/IanDarwin/expenses-server
echo Pre-fetch a bunch ("half the internet") of dependencies for Spring-boot server
CALL apache-maven-3.8.6\bin\mvn.cmd -ntp -f expenses-server/pom.xml compile

echo Grand finale: download a tranche of files in non-git format
curl https://darwinsys.com/tmp/Tilde510G.tgz | tar xzf -

echo Java Version - default should be 17, not 11
java --version

@echo Tha-Tha-Tha-That's all folks!

@echo echoember there is one manual step needed:
@echo Set All Browser Home Pages to 
@echo	file:///C:/Users/%USERNAME%/CourseFiles510G/website/index.html
