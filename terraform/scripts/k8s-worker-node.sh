

#!/bin/bash

FILE_PATH="/home/ubuntu/join.sh"

# Check if the file exists and is a regular file
if [ -f "$FILE_PATH" ]; then
    echo "File $FILE_PATH found. Executing..."
    # Execute the script
    /bin/bash "$FILE_PATH"
else
    echo "Error: File $FILE_PATH does not exist."
    exit 1
fi
