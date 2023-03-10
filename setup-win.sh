#!/bin/bash

# Download this into a different name, e.g.
# git clone https://github.com/IanDarwin/CourseFiles518Z CourseFiles

# Set up some version numbers
COURSE_NUM=518Z
INTELLIJ_VER=2022.3.1
AS_VER=2021.3.1.17
JAVA_VER=17.0.4.8
FLUTTER_VER=3.3.10-stable
MAVEN_VER=3.8.7

echo Androd Module: Installs Part One 
echo You must have installed git:
echo winget install -i Git.Git 
echo And chosen the "'Unix utilities path'"!
echo

# Make sure we start in ~
cd $HOME
# Create these early to avoid accidents
mkdir bin lib

set -e # from here, bomb if error

echo Windows Terminal - tabbed terminal with CTRL/C-CTRL-V
# winget install --id Microsoft.WindowsTerminal
echo "Had to manually install via store??"

echo Java JDK 17 LTS - free from numerous OpenJDK download sites
winget install --id EclipseAdoptium.Temurin.17.JDK --version ${JAVA_VER}
PATH="/c/Program Files/Eclipse Adoptium/jdk-${JAVA_VER}-hotspot/bin:$PATH"
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

function getagit {
	git_repo=$1
	targdir=${git_repo##*/}
	if [ ! -d ${targdir} ]; then
		git clone $git_repo
	else echo $targdir already exists, skipping $git_repo
	fi
}
. getagit.sh

# Pick a shorter name
mv bookmarks-flutter bookmarks

echo Tools used in preparing the course load
echo "Make (gnu-make)"
winget install --id GnuWin32.Make
echo nmap just for ncat
winget install --id Insecure.Nmap

echo Downloading maven build tool from https://maven.apache.org/download
curl https://dlcdn.apache.org/maven/maven-3/${MAVEN_VER}/binaries/apache-maven-${MAVEN_VER}-bin.tar.gz | tar xzf -

echo Documentation
curl -o Documents/LevinInternalsBookVol1FirstEdn.pdf http://newandroidbook.com/AIvI-M-RL1.pdf

echo "Visual Studio C++ for making windows desktop apps"
echo "BE SURE TO CHOOSE THE 'Desktop development with C++' Workload"
winget install -i Microsoft.VisualStudio.2022.Community

(
cd makehandsons
sh ../apache-maven-${MAVEN_VER}/bin/mvn -ntp -DskipTests clean package install assembly:single
cp target/makehandsons-1.0-SNAPSHOT-jar-with-dependencies.jar $HOME/lib/makehandsons.jar
cp scripts/* $HOME/bin
)

echo NOT Generating exercise files from solutions
#J(
#Jcd CourseFiles/sourcecode
#Jmake
#J)

echo Pre-fetch a bunch ("half the internet") of dependencies for Spring-boot server
sh apache-maven-3.8.6\bin\mvn -ntp -f expenses-server/pom.xml compile

# echo Grand finale: download a tranche of files in non-git format
# curl https://darwinsys.com/tmp/Tilde${COURSENUM}.tgz | tar xzf -

echo Java Version - default should be 17, not 11
java --version

echo Tha-Tha-Tha-That's all folks!

echo Remember there is one manual step needed:
echo Set All Browser Home Pages to 
echo	file:///C:/Users/%USERNAME%/CourseFiles${COURSENUM}/website/index.html


