#!/bin/bash

echo Androd Module: Installs Part One 
echo You must have installed git:
echo winget install -i Git.Git 
echo And chosen the "Unix utilities path"!

# Make sure we start in ~
cd $HOME
# Create these early to avoid accidents
mkdir bin lib

set -e # from here, bomb if error

echo Windows Terminal - tabbed terminal with CTRL/C-CTRL-V
winget install --id Microsoft.WindowsTerminal
echo Java JDK 17 LTS - free from numerous OpenJDK download sites
winget install --id EclipseAdoptium.Temurin.17.JDK --version 17.0.4.8
PATH="C:\Program Files\Eclipse Adoptium\jdk-17.0.4.8-hotspot\bin";%PATH%
java -version

exit 

echo IntelliJ java-only install
winget install --id JetBrains.IntelliJIDEA.Community
echo Android Studio IDE (Ch03 to end) - free from Google (it's just JetBrains IntelliJ with extra plugins)
winget install --id Google.AndroidStudio
echo Android SDK, tools, emulators - downloaded when starting up Studio first time

echo Flutter SDK - latest - from https://flutter.dev/
curl -o flutter.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.0.5-stable.zip
"C:\Program Files\Git\usr\bin\unzip.exe" flutter.zip > nul:
del   flutter.zip

echo Tools used in preparing the course load
echo Make (gnu-make) - 
winget install --id GnuWin32.Make
echo mitmproxy for Chap 7
winget install --id mitmproxy.mitmproxy
echo nmap just for ncat
winget install --id Insecure.Nmap

echo Downloading maven build tool from https://maven.apache.org/download
curl https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz | tar xzf -

echo Documentation
echo Android Internals book first edition, free download, Used with permission.
echo SEE http://newandroidbook.com/vault7.htm. 
curl -o Documents/LevinInternalsBookVol1FirstEdn.pdf http://newandroidbook.com/AIvI-M-RL1.pdf

echo Sample Code:
echo JavaSrc - course author's open-source Java demo package 
git clone https://github.com/IanDarwin/javasrc
echo AndroidCookbookExamples - course author's open-source Android demos 
git clone https://github.com/IanDarwin/Android-Cookbook-Examples
echo AndroidTemplate
git clone https://github.com/IanDarwin/AndroidTemplate

echo Course Problems and Solutions, and a few demos 
git clone https://github.com/IanDarwin/makehandsons
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
