#!/bin/sh

# show the full list of git repos, not including CourseFiles which this is already in

function getagit {
	echo git clone $1
}
. ./getagit.sh
