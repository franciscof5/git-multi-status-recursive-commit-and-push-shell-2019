#!/bin/bash

dir="$1"

# No directory has been provided, use current
if [ -z "$dir" ]
then
    dir="`pwd`"
fi

# Make sure directory ends with "/"
if [[ $dir != */ ]]
then
	dir="$dir/*"
else
	dir="$dir*"
fi

# Loop all sub-directories
for f in $dir
do
	# Only interested in directories
	[ -d "${f}" ] || continue

	echo -en "\033[0;35m"
	echo "${f}"
	echo -en "\033[0m"

	# Check if directory is a git repository
	if [ -d "$f/.git" ]
	then
		mod=0
		cd $f

		# Check for modified files
		if [ $(git status | egrep "modified|deleted" -c) -ne 0 ]
		then
			mod=1
			echo -en "\033[0;31m"
			echo "Modified files"
			echo -en "\033[0m"

			read -p "Do you want to commit and push (y/n) [y]: " commit
			commit=${commit:-y}

			if [ "$commit" == "y" ]; then
				gacr
			else
				echo "Leaving untrack files..."
			fi
			echo $commit
		fi

		# Check for untracked files
		if [ $(git status | grep Untracked -c) -ne 0 ]
		then
			mod=1
			echo -en "\033[0;31m"
			echo "Untracked files"
			echo -en "\033[0m"

			read -p "Do you want to commit and push (y/n) [y]: " commit
			commit=${commit:-y}

			if [ "$commit" == "y" ]; then
				gacr
			else
				echo "Leaving untrack files..."
			fi
			echo $commit
		fi

		# Check if everything is peachy keen
		if [ $mod -eq 0 ]
		then
			echo "Nothing to commit"
		fi

		cd ../
	else
		echo "Not a git repository, checking sub-directories"

		#if [ -d "$f" ]
		#then
	    	cd "$f"
	    	git-multi-status
	    #fi
	fi

	echo
done
