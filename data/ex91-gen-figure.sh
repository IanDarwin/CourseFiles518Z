#!/bin/sh

# generate the "tree" diagram used in ex91.
# "emulates" a simplified versino of actual directory tree.

mkdir CourseFiles

cd CourseFiles

mkdir ex91 ex91flutter

mkdir ex91/app ex91flutter/lib

touch ex91/build.gradle

touch ex91flutter/pubspec.yaml

cd ..

tree CourseFiles
