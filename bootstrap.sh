#!/bin/bash
# This is just here for the sake of people running bootstrap.sh with curl still

log(){
    printf "\n\033[32m$*\033[00m\n"
    return $?
}

echo "The script now uses 'firefoxes.sh' not 'bootstrap.sh', I'll go ahead and download the updated script for you now..."

if curl -C - -L "https://raw.github.com/omgmog/install-all-firefox/master/firefoxes.sh" -o "/tmp/firefoxes.sh"
	then
	chmod +x "/tmp/firefoxes.sh"
	log "✔ Successfully downloaded the new 'firefoxes.sh'!"
	echo "Would you like to copy 'firefoxes.sh' from /tmp/ to your current directory (${PWD})? [y/n]"
	read user_choice
	choice_made="false"
	while [[ "$choice_made" == "false" ]]
	do
		case "$user_choice" in
			"y")
				choice_made="true"
				log "Copying 'firefoxes.sh' to ${PWD}/firefoxes.sh"
				cp "/tmp/firefoxes.sh" "${PWD}/firefoxes.sh"
			;;
			"n")
				choice_made="true"
				echo "Okay then, you will need to move the file manually. It's currently stored in /tmp/firefoxes.sh"
			;;
			*)
				choice_made="true"
				echo "Please enter 'y' or 'n'"
				read user_choice
			;;
		esac
	done
fi
