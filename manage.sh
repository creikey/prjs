#!/bin/bash
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALLCOMMAND="alias prjs='source $SCRIPTDIR/prjs'"

is_installed() {
	echo -n "$(grep -xn "$INSTALLCOMMAND" "$HOME/.bashrc")" 
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo -e -n "--Manages prjs--\n--install : installs to .bashrc\n--uninstall : uninstalls from the bashrc\n"
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
