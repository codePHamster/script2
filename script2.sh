#!/bin/bash
#
# CSE 15L - Winter 2018
# Scripting Practice 2 (Due: Fri, Mar 16, 23:59)
#
# Name:  Kim Pham 
# PID:   A12426296
# Login: cs15xjx
#
#===============================================================================
# INSTRUCTIONS
#===============================================================================
#
# For the final scripting assignment in CSE 15L, you will be writing your own
# implementation of the `gethw` script that you have been using this quarter.
#
# You should be fairly familiar with what the script does, But just to bring
# everyone on the same page, here are some expected behaviors of your script
# upon different use cases:
#
#
# 1. Script usage error
#
#    Your script takes exactly one positional parameter.  If a user passes in
#    incorrect number of parameters, print the following usage message and exit
#    the script with code 1.
#
#    USAGE="Usage: ./script2.sh [hw-name]"
#
# 2. Invalid homework error
#
#    Your script takes in the name of the homework as its only parameter. Your
#    script should look at the public `homework` directory to see if homework
#    directory of the same name can be found.  If the user has passed in a
#    homework name that does not match any directory inside public `homework`,
#    print the following error message and exit the script with code 1.
#
#    EINVALID="Invalid homework: $1"
#
# 3. Retrieving valid homework for the first time
#
#    If the parameter turns out to be valid, and that the homework does not
#    already exist inside your home directory, simply go ahead and copy the
#    entire homework directory matching the specified name under `~/homework`
#    and print the following message once it's done.
#
#    SUCCESS="Done.  Navigate to \`~/homework/$1\` to get started."
#
# 4. Confirm overwrite
#
#    In case the user forgot that the homework is already half way done, it
#    would be very upsetting if the `gethw` script simply copies a fresh set
#    of empty homework files and overwrites the existing ones.  To prevent such
#    incident from happening, if a user specifies a homework name that already
#    exists under `~/homework/`, prompt the user for each individual file
#    inside the homework directory to ask for confirmation whether the user
#    wants the this file to be overwritten by a fresh copy.  Use the following
#    strings to for user interaction.
#
#    PROMPT="$file already exists.  Overwrite? (y/N) "
#    ABORT="Skipping $file."
#
#    Notice that the 'N' is capitalized, which means that the response is
#    negative by default -- unless the user either enters 'y' or 'Y'. (We won't
#    be testing any response other than upper and lower case 'n' and 'y', but we
#    will be testing on empty response where the user simply hits "enter"
#    without any input.  In this case, your script should treat it as negative.
#
#
#===============================================================================
# USEFUL TIPS
#===============================================================================
#
# 1. To access both public and home directory, use defined environment variables
#    `$PUBLIC` and `$HOME` (or tilde `~`) instead of hard coding the absolute
#    path -- we can't grade you if you hard code it.
#
# 2. You may find the command `read` useful when prompting the user.  Read its
#    man page to best utilize what it can do for you.
#
#    (No pun intended)
#
# 3. For reference, you can always run your script against the `gethw` command
#    on various test cases.  We won't be testing beyond what was covered in the
#    "INSTRUCTIONS" section of the write-up.
#
#
#===============================================================================
# TODO YOUR CODE STARTS BELOW -- HAVE FUN
#===============================================================================
USAGE="Usage: $0 [hw-name]"
EINVALID="Invalid homework: $1"
SUCCESS="Done.  Navigate to \`~/homework/$1\` to get started."

if [ $# -ne 1 ]; then
	echo $USAGE
	exit 1
fi

#access public homework
if [ ! -d $PUBLIC/homework/$1 ]; then
	echo $EINVALID
else
	#now access home homework
	if [ ! -d ~/homework/$1 ]; then
		cp -r $PUBLIC/homework/$1 ~/homework
		echo $SUCCESS
	else
		for file in ~/homework/$1/*
		do
			
			if [ -z "$(ls -A ~/homework/$1)" ]; then
				rm -r ~/homework/$1 
				cp -r $PUBLIC/homework/$1 ~/homework
				break
			fi
			PROMPT="$file already exists. Overwrite? (y/N) "
			echo $PROMPT
			read overwrite 
			if [ "$overwrite" == "y" ] || [ "$overwrite" == "Y" ]; then
				base=$(basename "$file")
				rm $file
				cp $PUBLIC/homework/$1/$base ~/homework/$1 
			else
				ABORT="Skipping $file."
				echo $ABORT 
			fi
		done
		echo $SUCCESS
	fi
fi
