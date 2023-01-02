#!/bin/bash

# Set up some version numbers
MAVEN_VER=3.8.7
FLUTTER_VER=3.3.9-stable

echo Flutter Course - Installs 

set -e # for now, bomb if anything fails

# Make sure we start in ~
cd
# Create these early to avoid accidents
mkdir bin lib

# To install: IntelliJ IDea, Android Studio, Dart, Flutter

# Flutter SDK - latest - from https://flutter.dev/
curl -o flutter.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_.${FLUTTER_VER}.zip
unzip flutter.zip > nul:
rm   flutter.zip

echo Downloading Apache Maven build tool from https://maven.apache.org/download
curl https://dlcdn.apache.org/maven/maven-3/${MAVEN_VER}/binaries/apache-maven-${MAVEN_VER}-bin.tar.gz | tar xzf -
PATH=$PATH:$HOME/apache-maven-${MAVEN_VER}/bin

# Sample Code:
# DartSrc - course author's open-source Dart demo package 
for git_repo in \
	https://github.com/IanDarwin/{dartsrc,flutterdemos,jMemory} \
	https://github.com/IanDarwin/{makehandsons,CourseFiles518Z,expenses-server \
	https://github.com/IanDarwin/{bookmarks-flutter,jmemory} \
	https://github.com/flutter/samples \
	https://github.com:/{gskinnerTeam/flutter-wonderous-app,ErfanRht/MovieLab.git} \
# This line intentionally left blank. Well, at least commented
do
	git clone $git_repo
done

echo Need to add these
echo i18n_counter_way1

cd makehandsons
. ../apache-maven-${MAVEN_VER}/bin/mvn -ntp -DskipTests clean package install assembly:single
copy target/makehandsons-1.0-SNAPSHOT-jar-with-dependencies.jar $HOME/lib/makehandsons.jar
copy scripts/* $HOME/bin
cd ..
# Generating exercise files from solutions
(
	cd CourseFiles518Z/sourcecode
	make
)

# Chapter 3 Expenses-server - from course author, to upload expenses for Expenses app  
echo Pre-fetch a bunch ("half the internet") of dependencies for Spring-boot server
. apache-maven-${MAVEN_VER}/bin/mvn -ntp -f expenses-server/pom.xml compile

# Grand finale: download any remaining files in non-git format
curl https://darwinsys.com/tmp/Tilde518Z.tgz | tar xzf -

echo Tha-Tha-Tha-That's all folks!

echo Remember there are many manual step needed:
echo Set All Browser Home Pages to ~/CourseFiles518Z/website/index.html
echo Start Android Studio, get Flutter plugin, configure Android API 33
