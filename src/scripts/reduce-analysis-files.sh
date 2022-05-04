# Script takes 2 json files created by running a log file through the analyzer and reduces them to a single json file
# Usage: ./reduce-analysis-files.sh <directory1> <directory2> <output-directory>
# Example: ./reduce-analysis-files.sh ./logs/log-1 ./logs/log-2 ./logs/reduced-log

# Note: This script assumes that the files are named in the format <log>-analysis.json
# Note: Input files are formatted as json objects with the following structure:
# {
#   "filename": "log-1.json",
#   "filepath": "./logs/log-1.json",
#   "searchTerm": "warning",
#   "count": 1
# }

# Note: Output file is formatted as json objects with the following structure:
# {
#   "filename": "log-1.json",
#   "filepath": "./logs/log-1.json",
#   "searchTerms": [
#     {
#       "searchTerm": "warning",
#       "count": 1
#     },
#     {
#       "searchTerm": "error",
#       "count": 4
#     }
#   ]
# }

set -x

# Get parameters
directory1=$1
directory2=$2
output_directory=$3

# Check if user has provided all parameters
if [ -z "$directory1" ] || [ -z "$directory2" ] || [ -z "$output_directory" ]; then
    echo "Usage: ./reduce-analysis-files.sh <directory1> <directory2> <output-directory>"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$output_directory/logs"

# Get all json files in directory1
for f in "$directory1"/*.json; do
    echo "Processing $f"

    # Get the original log's filename
    filename=$(jq -r '.filename' "$f")

    # Get the original log's filepath
    filepath=$(jq -r '.filepath' "$f")

    # Get the first search term and its count
    searchTerm1=$(jq -r '.searchTerm' "$f")
    count1=$(jq -r '.count' "$f")

    # Get corresponding json files in directory2
    f2="$directory2"/$(basename "$f")

    # Get the second search term and its count
    searchTerm2=$(jq -r '.searchTerm' "$f2")
    count2=$(jq -r '.count' "$f2")

    # Create output json
    output="{\"filename\":\"$filename\", \"filepath\":\"$filepath\",\"searchTerms\": [{\"searchTerm\":\"$searchTerm1\", \"count\": \"$count1\"}, {\"searchTerm\":\"$searchTerm2\", \"count\": \"$count2\"}] }"

    # Write output json to file
    echo "$output" | jq '.' >> "$output_directory"/logs/"$filename"-reduced-analysis.json
done