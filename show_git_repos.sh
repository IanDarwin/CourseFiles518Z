#!/bin/sh

# show the full list of git repos, not including CourseFiles which this is already in

echo "# You can pipe this output into a shell, eg $0 | sh -x"
function getagit {
	echo git clone $1
}
. ./getagit.sh
