#!/bin/bash

# The natural consequence of a busy schedule is that at times, time will begin to slip
# through your fingers, and commitments will need to be shifted around.
# Unfortunately, your responsibilities are quite often not solely your own, and thus you
# will have to notify the people waiting on you - mainly, professors.
# These notifications can range anywhere between repetitive to stressful, and can be both
# time-consuming and difficult to remember to do. So, a solution.

# Exmple of its usage:
# -bash4.2$ sh myScript.sh class sick recipient@email.com
# (generates and sends an email excusing self from class on account of illness)

# three initial vars
EVENT=$1
EXCUSE=$2
RECIPIENT=$3

# asked for a make-up day of the week
echo "When can you make up $1? (Enter a day of the week)"
read MAKE_UP_DAY

# Enter a customised message subject (e.g. with the name of the assignment)
echo "Please enter message subject."
read SUBJECT

# Use today's date in the subject line
DATE=$(date +%D)
SUBJECT_FULL="$DATE - $SUBJECT"
SIGNED=$(whoami)

#Initialise parts of the email
GREETING=NULL
EVENT_FORMAT=NULL
EXCUSE_FORMAT=NULL
MAKE_UP=NULL

#First generate a greeting based on the time of day
HOUR=$(date +%H)
case $HOUR in
03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 | 11)
	GREETING="Good morning,"
	;;
12 | 13 | 14 | 15 | 16 | 17)
	GREETING="Good afternoon,"
	;;
18 | 19 | 20 | 21 | 22 | 23 | 00 | 01 | 02)
	GREETING="Good evening,"
	;;
esac

# Then use the missed event to generate a formatted sentence for it, as well as a make-up
# suggestion.
case $EVENT in
	class)
	EVENT_FORMAT="to attend class"
        MAKE_UP="I will make sure to follow up on missed notes with a classmate before the next time we meet."
	;;
	homework)
	EVENT_FORMAT="to complete the homework in time for the deadline"
        MAKE_UP="If you would allow it, I will ensure to have it done on $MAKE_UP_DAY."
	;;
	quiz)
	EVENT_FORMAT="to take our next quiz"
        MAKE_UP="Would it be possible for me to take a make-up quiz on $MAKE_UP_DAY?"
	;;
	meeting)
	EVENT_FORMAT="to meet with you as planned"
        MAKE_UP="I am available the coming $MAKE_UP_DAY, would this work for you?"
	;;
esac

# Format the excuse given to the professor.
case $EXCUSE in
	sick)
	EXCUSE_FORMAT="as I have fallen ill"
	;;
	mappointment)
	EXCUSE_FORMAT="as I have a medical appointment at that time"
	;;
	badweather)
	EXCUSE_FORMAT="as the weather does not permit travel"
	;;
	private)
	EXCUSE_FORMAT="due to a personal emergency"
	;;
esac

# Create a temporary text file to preserve the formatting of the string and still
# read variables.
touch Excuse.txt

# Write email to text file
echo "$GREETING" >> Excuse.txt
echo $'\n' >> Excuse.txt
echo "I hope you are well. Unfortunately, I am unable $EVENT_FORMAT $EXCUSE_FORMAT. I am very sorry for this inconvenience. $MAKE_UP" >> Excuse.txt
echo $'\nThank you very much for your understanding,\n' >> Excuse.txt
echo "$SIGNED" >> Excuse.txt

# Allow the user to verify the email before sending
cat Excuse.txt
echo "Send email? (y/n)"
read RESPONSE_1

# If all is good, send the email.
case $RESPONSE_1 in
	y)
	mailx -s "$SUBJECT_FULL" $RECIPIENT < Excuse.txt
	;;
	n)
	;;
esac

echo "Save email as a text file? (y/n)"
read RESPONSE_2

# Rename file to something distinguishable if yes, remove if no
case $RESPONSE_2 in
	y)
	mv Excuse.txt "Excuse_$(date +%F)".txt
	;;
	n)
	rm Excuse.txt
	;;
esac
