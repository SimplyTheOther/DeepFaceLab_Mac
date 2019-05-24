#!/bin/bash
# OS X Installer - base 

# check program installed
# invoke with parameter "command to check", returns 0 for false and 1 for true
function check_program_installed () {
	local output=0

	#param 1 zero length
	if [ -z "$1" ]; then												
		echo "check_program_installed() not passed a parameter!"
	else
		if command -v "$1" &>/dev/null; then
			output=1
			echo "$1" "is installed"
		else
			echo "$1" "is not installed"
		fi
	fi
	
	return $output
}

# checks if multiple programs are installed
# returns true only if all are installed
function check_multiple_programs_installed () {
	local output=1
	
	for var in "$@"; do
		check_program_installed "$var"
		
		if [ "$?" -eq 0 ]; then
			echo "Program" "$var" "not installed!"
			output=0
		else
			echo "Program" "$var" "installed!"
		fi
	done
	
	return $output
}

# check to see if all dependencies installed
check_multiple_programs_installed "python3" "cmake" "ffmpeg"
if [ "$?" -eq 0 ]; then
	# check package managers available
	check_program_installed "brew"
	local hasHB="$?"
	
	check_program_installed "port"
	local hasMP="$?"
	
	# if homebrew installed	
	if [ $hasHB -eq 1 ]; then			
		brew update
		brew install python
	
		# install DeepFaceLab dependencies
		brew install ffmpeg cmake 
		# build should work fine assuming xcode tools provides compiler, linker, etc.
		# also xcode provides git
	# if macports installed 
	elif [ $hasMP -eq 1 ]; then
		sudo port selfupdate
		sudo port upgrade outdated
		
		sudo port install ffmpeg cmake
	# if no package managers found
	else
		echo "Not all dependencies were installed, nor were any known package managers found."
		echo "Please retry after installing the dependencies, Homebrew, or MacPorts."
	
		exit 1
	fi
else
	echo "All base dependencies are already installed. Proceeding to variant dependencies."	
fi