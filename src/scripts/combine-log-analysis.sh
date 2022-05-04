# Script purpose: combine log analysis results
# Usage: ./combine-log-analysis.sh <log-analysis-dir> <output-dir>
# Example: ./combine-log-analysis.sh input/log-analysis output/log-analysis

# Note: The input directory should contain the following files: *.json
# Note: The output file will be named combined-log-analysis.json and have the following json format:
# {
#  "input-directory": "/pfs/in",
#  "analysis": [
#   {
#     "filename": "log-1.json",
#     "filepath": "./logs/log-1.json",
#     "searchTerms": [
#       {
#         "searchTerm": "warning",
#         "count": 1
#       },
#       {
#         "searchTerm": "error",
#         "count": 4
#       }
#     ]
#   },
#   {
#     "filename": "log-2.json",
#     "filepath": "./logs/log-2.json",
#     "searchTerms": [
#       {
#         "searchTerm": "warning",
#         "count": 3
#       },
#       {
#         "searchTerm": "error",
#         "count": 2
#       }
#     ]
#   }
#  ]
# }

set -x

# Get the parameters
input_directory=$1
output_directory=$2

if [ -z "$input_directory" ] || [ -z "$output_directory" ]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
fi

# Create the output json file
output="{ \"input_directory\": \"$input_directory\", \"analysis\": [ "

# iterate through the input directory and add the results to the output json file
for f in "$input_directory"/*.json; do
    echo "Processing $f"
    output+=$(jq '.' "$f")
    output+=","
done

# remove the last comma and add the closing bracket
output=${output%?}"]}"

# write the output to the output json file
echo "$output" | jq '.' > "$output_directory"/combined-log-analysis.json