#!/bin/bash

# Check if file provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input.txt"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="output.txt"

# Clear old output file
> "$OUTPUT_FILE"

# Read file line by line
while IFS= read -r line
do
    # Check for required parameters using pattern matching
    if [[ "$line" == *"\"frame.time\""* ]] || \
       [[ "$line" == *"\"wlan.fc.type\""* ]] || \
       [[ "$line" == *"\"wlan.fc.subtype\""* ]]; then
        
        echo "$line" >> "$OUTPUT_FILE"
    fi

done < "$INPUT_FILE"

echo "Extraction complete. Output saved to $OUTPUT_FILE"
