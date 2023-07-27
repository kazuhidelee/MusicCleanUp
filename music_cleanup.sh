#!/usr/bin/bash

getArtistName() {
    # Take one argument and set a global variable to the artist's name with whitespace removed
    # Using ffprobe to extract the artist name
    artist_name=$(ffprobe -show_format -loglevel quiet "$1" | grep -oP "(?<=TAG:artist=).*" | tr -d ' ')
}

getSongName() {
    # Take one argument and set a global variable to the song name with whitespace removed
    # Using ffprobe to extract the song name
    song_name=$(ffprobe -show_format -loglevel quiet "$1" | grep -oP "(?<=TAG:title=).*" | tr -d ' ')
}

doConversion() {
    # Perform the conversion on a single file
    ffmpeg -i "$1"  "${TARGET_DIR}/${artist_name}_${song_name}.mp3"
    return $?
}

# Takes one argument, that being a directory
TARGET_DIR=$1

# Check if the directory argument is provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Now we should iterate over every file in the directory and do the conversion for each file
for file in "$TARGET_DIR"/*; do
    if [[ -f "$file" ]]; then
        getArtistName "$file"
        getSongName "$file"

        if doConversion "$file"; then
            rm "$file"
            mv "${TARGET_DIR}/${artist_name}_${song_name}.mp3" "${TARGET_DIR}/${artist_name}_${song_name}.mp3"
        else
            rm "$file"
        fi
    fi
done

exit 0




