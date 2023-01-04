#!/bin/bash

# Set up some version numbers
FLUTTER_VER=3.3.10-stable
AS_VER=2021.3.1.17

echo Flutter Course - Installs 

# Make sure we start in ~
cd
# Create these early to avoid accidents
mkdir bin lib

set -e # for now, bomb if anything fails

# Some things we can actually install directly
sudo apt install maven

echo STILL TO install: IntelliJ IDea

if [ ! -d android-studio ]; then
echo Installing Android Studio
curl https://r2---sn-q4flrnsk.gvt1.com/edgedl/android/studio/ide-zips/2021.3.1.17/android-studio-2021.3.1.17-linux.tar.gz | tar xzf -
else echo Android studio already installed
fi

if [ ! -d flutter ]; then
echo Installing Flutter SDK - latest - from https://flutter.dev/
curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VER}.tar.xz
tar xf flutter.tar.xz > /dev/null
rm   flutter.tar.xz
else echo Flutter already installed
fi

if [ ! -d apache-maven-${MAVEN_VER} ]; then
echo Downloading Apache Maven build tool from https://maven.apache.org/download
curl https://dlcdn.apache.org/maven/maven-3/${MAVEN_VER}/binaries/apache-maven-${MAVEN_VER}-bin.tar.gz | tar xzf -
PATH=$PATH:$HOME/apache-maven-${MAVEN_VER}/bin
else echo apache-maven-${MAVEN_VER} already installed
fi

# Sample Code:
# DartSrc - course author's open-source Dart demo package 
for git_repo in \
	https://github.com/IanDarwin/{dartsrc,flutterdemos,jMemory} \
	https://github.com/IanDarwin/{makehandsons,expenses-server} \
	https://github.com/IanDarwin/{bookmarks-flutter,darttest,l10n_counter_way1,jmemory} \
	https://github.com/flutter/samples \
	https://github.com:/{gskinnerTeam/flutter-wonderous-app,ErfanRht/MovieLab.git,RajithAshok/ThePlantApp_v2.3} \
# This line intentionally left blank. Well, at least commented
do
	targdir=${git_repo##*/}
	if [ ! -d ${targdir} ]; then
		git clone $git_repo
	else echo $targdir already exists, skipping $git_repo
	fi
done

echo Building makehandsons app
(
cd makehandsons
mvn -ntp -DskipTests clean package install assembly:single
cp target/makehandsons-1.0-SNAPSHOT-jar-with-dependencies.jar $HOME/lib/makehandsons.jar
cp scripts/* $HOME/bin
)

echo Generating exercise files from solutions
(
	cd CourseFiles518Z/sourcecode
	make
)

echo Setting up Expenses-server - from course author, to upload expenses for Expenses app  
(
cd expenses-server
echo Pre-fetch '"half the internet"' dependencies for Spring-boot server
mvn -ntp -f expenses-server/pom.xml compile 
)

# Grand finale: download any remaining files in non-git format
# curl https://darwinsys.com/tmp/Tilde518Z.tgz | tar xzf -

echo Tha-Tha-Tha-That's all folks!

echo Remember there are many manual step needed:
echo Set All Browser Home Pages to ~/CourseFiles518Z/website/index.html
echo Start Android Studio, get Flutter plugin, configure Android API 33
