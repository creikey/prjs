#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALLCOMMAND="alias prjs='source $SCRIPTDIR/prjs'"

is_installed() {
	echo -n "$(grep -xn "$INSTALLCOMMAND" "$HOME/.bashrc")" 
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo -e -n "--Manages prjs--\n--install : installs to .bashrc\n--uninstall : uninstalls from the bashrc\n--update : pulls from git to update\n"
elif [ "$1" == "--update" ]; then
	echo -e -n "Updating..."
	if [ ! -d ".git" ]; then
		echo -e -n "FAIL!\n"
		echo -e -n "-Not a git repository, cannot pull!\n"
	else
		REMOTES=$(git remote -v | grep origin)
		if [ "$REMOTES" == "" ]; then
			echo -e -n "FAIL!\n"
			echo -e -n "-No origin remote to pull from!\n"
			echo -e -n "-ABORT - OUT OF OPTIONS\n"
			exit
		fi
		GITSTATUS=$(git status -s)
		if [ "$GITSTATUS" != "" ]; then
			echo -e -n "FAIL!\n"
			echo -e -n "-Local changes are not yet saved! Overwrite them? "
			read -n1 ans
			if [ "$ans" != "y" ]; then
				echo -e -n "-ABORT - OUT OF OPTIONS\n"
				exit
			fi
		fi
		echo -e -n "OK!\n\n"
		git pull origin master
	fi
elif [ "$1" == "--install" ]; then
	if [ "$(is_installed)" == "" ]; then
		echo -e -n "Prjs not installed...\n"
		echo -e -n "Installing..."
		echo -e -n "\n$INSTALLCOMMAND\n" >> ~/.bashrc
		if [ "$(is_installed)" == "" ]; then
			echo -e -n "FAILED!\n"
		else
			echo -e -n "OK!\n"
		fi
	else
		echo -e -n "Prjs is already installed!\n"
	fi
elif [ "$1" == "--uninstall" ]; then
	if [ "$(is_installed)" != "" ]; then
		echo -e -n "Prjs installed...\n"
		echo -e -n "Uninstalling..."
		INSTALLLINE=$(grep -xn "$INSTALLCOMMAND" "$HOME/.bashrc" | grep -Eo '^[^:]+')
		sed -i.bak "${INSTALLLINE}d" ~/.bashrc
		if [ "$(is_installed)" == "" ]; then
			echo -e -n "OK!\n"
		else
			echo -e -n "FAILED!\n"
		fi
	else
		echo -e -n "Prjs is not installed\n"
	fi
else
	echo -e -n "Run --help to see commands\n"
fi
