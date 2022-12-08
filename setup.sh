#!/bin/bash

# Install 'git bash' if you don't have it already!

# Flutter Course - Installs 

# Make sure we start in ~
cd %USERPROFILE%
# Create these early to avoid accidents
mkdir bin lib

# Windows Terminal - tabbed terminal with CTRL/C-CTRL-V
winget install --id Microsoft.WindowsTerminal
# Dart stable           
winget install --id Gekorm.Dart
# Java JDK 17 LTS - free from numerous OpenJDK download sites
winget install --id EclipseAdoptium.Temurin.17.JDK --version 17.0.4.8

# IntelliJ base install
winget install --id JetBrains.IntelliJIDEA.Community
# Android Studio IDE (Ch03 to end) - just JetBrains IntelliJ with extra plugins
winget install --id Google.AndroidStudio
# Android SDK, tools, emulators - downloaded when starting up Studio first time

# Flutter SDK - latest - from https://flutter.dev/
curl -o flutter.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.3.9-stable.zip
"C:\Program Files\Git\usr\bin\unzip.exe" flutter.zip > nul:
del   flutter.zip

rem Visual Studio needed by Flutter to build Windows apps
echo "Choose the C++ tooling if asked"
winget install "Visual Studio Community 2022"  --override "--add Microsoft.VisualStudio.Workload.NativeDesktop  Microsoft.VisualStudio.ComponentGroup.WindowsAppSDK.Cpp"  -s msstore

# Tools used in preparing the course load
# Make (gnu-make) - 
winget install --id GnuWin32.Make
# nmap just for ncat
winget install --id Insecure.Nmap

echo Downloading maven build tool from https://maven.apache.org/download
curl https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz | tar xzf -

# Sample Code:
# DartSrc - course author's open-source Dart demo package 
git clone https://github.com/IanDarwin/dartsrc
# AndroidCookbookExamples - course author's open-source Android demos 
git clone https://github.com/IanDarwin/Android-Cookbook-Examples
# AndroidTemplate
git clone https://github.com/IanDarwin/AndroidTemplate

# Course Problems and Solutions, and a few demos 
git clone https://github.com/IanDarwin/makehandsons
cd makehandsons
CALL ..\apache-maven-3.8.6\bin\mvn.cmd -ntp -DskipTests clean package install assembly:single
copy target\makehandsons-1.0-SNAPSHOT-jar-with-dependencies.jar %USERPROFILE%\lib\makehandsons.jar
copy scripts\* %USERPROFILE%\bin
cd ..
git clone https://github.com/IanDarwin/CourseFiles518Z
# Generating exercise files from solutions
cd CourseFiles518Z\sourcecode
make
cd ..\..

# Chapter 3 Expenses-server - from course author, to upload expenses for Expenses app  
git clone https://github.com/IanDarwin/expenses-server
rem Pre-fetch a bunch ("half the internet") of dependencies for Spring-boot server
CALL apache-maven-3.8.6\bin\mvn.cmd -ntp -f expenses-server/pom.xml compile

# Grand finale: download a tranche of files in non-git format
curl https://darwinsys.com/tmp/Tilde518Z.tgz | tar xzf -

echo Tha-Tha-Tha-That's all folks!

@echo Remember there is one manual step needed:
@echo Set All Browser Home Pages to 
@echo	file:///C:/Users/%USERNAME%/CourseFiles518Z/website/index.html
