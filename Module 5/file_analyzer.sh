#!/bin/bash
#--help using here document
if [[ "$1" == "--help" ]]; then
cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Directory to search
  -f <file>        File to search
  -k <keyword>     Keyword to search
  --help           Display this help menu

Examples:
  $0 -d logs -k error
  $0 -f script.sh -k TODO
EOF
exit 0
fi
# parsing short options
while getopts ":d:f:k:" opt; do
    case $opt in
        d)
            directory="$OPTARG"
            ;;
        f)
            file="$OPTARG"
            ;;
        k)
            keyword="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" | tee -a errors.log
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." | tee -a errors.log
            exit 1
            ;;
    esac
done
#here string file search
if [ -n "$file" ] && [ -n "$keyword" ]; then
    if [ ! -f "$file" ]; then
        echo "File does not exist."
        exit 1
    fi

    echo "Searching for '$keyword' in $file..."

    while read line; do
        if grep -q "$keyword" <<< "$line"; then
            echo "Match found: $line"
        fi
    done < "$file"
fi

