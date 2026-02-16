#!/bin/bash

ERROR_LOG="errors.log"

#2&3a.HelpMenu (Here Doc)
if [ "$1" == "--help" ]; then
cat << EOF
Usage: $0 -d <directory> -k <keyword>
       $0 -f <file> -k <keyword>

Options:
  -d   Directory to search
  -f   File to search
  -k   Keyword to search
EOF
exit 0
fi

#2&6.getopts
while getopts "d:f:k:" opt
do
    case $opt in
        d) DIR="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        k) KEY="$OPTARG" ;;
        *) echo "Invalid option" | tee -a "$ERROR_LOG"
           exit 1 ;;
    esac
done

#5.Validate keyword 
if [[ -z "$KEY" || ! "$KEY" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Invalid keyword!" | tee -a "$ERROR_LOG"
    exit 1
fi

#1.RecursiveSearc
search_recursive() {
    local dir="$1"
    local keyword="$2"

    for item in "$dir"/*; do
        if [ -d "$item" ]; then
            search_recursive "$item" "$keyword"
        elif [ -f "$item" ]; then
            if grep -q "$keyword" "$item"; then
                echo "Keyword found in: $item"
            fi
        fi
    done
}

if [ -n "$DIR" ] && [ -n "$KEY" ]; then
    if [ ! -d "$DIR" ]; then
        echo "Directory not found!" | tee -a "$ERROR_LOG"
        exit 1
    fi
    search_recursive "$DIR" "$KEY"
fi

#4.SpecialParameters
echo "Script name: $0"
echo "Total arguments: $#"
echo "All arguments: $@"
echo "Last command status:$?"

#2&3bFile Search (Here String)
if [ -n "$FILE" ]; then
    if [ ! -f "$FILE" ]; then
        echo "File not found!" | tee -a "$ERROR_LOG"
        exit 1
    fi

    while read line
    do
        grep -q "$KEY" <<< "$line"
        if [ $? -eq 0 ]; then
            echo "Match: $line"
        fi
    done < "$FILE"
fi
