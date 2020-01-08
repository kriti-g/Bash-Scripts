#!/bin/bash

for mkvfile in *.mkv; do
	#change every mkv title to its file name
	mkvpropedit "$mkvfile" -e info -s title="${mkvfile%.*}"
	#change default subtitle track as needed
	mkvpropedit "$mkvfile" --edit track:s1 --set flag-default=0 --edit track:s2 --set flag-default=1
	#change default audio track as needed
	mkvpropedit "$mkvfile" --edit track:a1 --set flag-default=0 --edit track:a2 --set flag-default=1
done
