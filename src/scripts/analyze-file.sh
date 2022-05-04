# Script will quickly analyze a file, count the number of lines that contain a provided search term and output the results to a file in the /pfs/out directory
# Usage: ./analyze-file.sh <searchTerm> <directory> <output_directory>
# Example: ./analyze-file.sh "test" /pfs/in /pfs/out

# Note: The files outputted to the /pfs/out directory will be named based on the logfile name.
#       For example, if the logfile is named "test.log" the output file will be named "test-analysis.json"

# Note output file will be formatted as a JSON object with the following structure:
# {
#   "filename": "test.log",
#   "filePath": "/pfs/in/test.log",
#   "searchTerm": "test",
#   "count": "10"
# }

set -x

# Get parameters
searchTerm=$1
directory=$2
output_directory=$3

if [ -z "$searchTerm" ] || [ -z "$directory" ] || [ -z "$output_directory" ]; then
    echo "Usage: $0 <searchTerm> <directory> <output_directory>"
    exit 1
fi

# Create output directory if it doesn't exist
subdirectory=$(basename "$directory")
mkdir -p "$output_directory"/"$subdirectory"

# Iterate through all files in the directory with the extension .log
for f in "$directory"/*.log; do
    echo "Processing $f"

    # Get the file name without the extension or path
    filename=$(basename "$f")

    # Count the number of lines that contain the search term, case insensitive, whitespace insensitive, whole word only
    count=$(grep -icw "$searchTerm" "$f")

    # Create json object with the filename, filepath, searchTem and the count
    output="{\"filename\":\"$filename\", \"filepath\":\"$directory\",\"searchTerm\": \"$searchTerm\", \"count\": \"$count\" }"

    # Write the json object to a file in the output directory
    echo "$output" | jq '.'  >> "$output_directory"/"$subdirectory"/"$filename"-analysis.json
done