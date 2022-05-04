# Script creates a human readable log analysis report from the aggregated json based log analysis files
# Usage: ./create-log-analysis-report.sh <log-analysis-dir> <output-directory>

# Note: The log-analysis-dir should be the directory where the aggregated json based log analysis file is located
# Note: The output-directory should be the directory where the report will be created
# Note: The report will be created in the output-directory with the name log-analysis-report.txt

# Note: The input file should be named combined-log-analysis.json and have the following json format:
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

# Get parameters
input_directory=$1
output_directory=$2

# Check if the user has provided the input and output directories
if [ -z "$input_directory" ] || [ -z "$output_directory" ]; then
    echo "Usage: $0 <input_directory> <output_directory>"
    exit 1
fi

# Create report header
output="Log Analysis Report:\n\n"

# Create report body
for f in "$input_directory"/*.json; do
    echo "Processing $f"

    # get the array of log analysis results
    analysis=$(jq '.analysis' "$f")
    if [ -z "$analysis" ]; then
        echo "No analysis found in $f"
        exit 1
    fi

    # get the array  of log file names
    filenames=$(echo "$analysis" | jq -r '.[] | .filename')

    # iterate over the array of log file names
    for filename in $filenames; do

      # get the filepath
      path=$(echo "$analysis" | jq -r ".[] | select(.filename == \"$filename\") | .filepath")

      # append the filepath to the report
      output+="Log file $filename found in $path has"

      # get the array of searchTerms and iterate over it
      searchTerms=$(echo "$analysis" | jq -r ".[] | select(.filename == \"$filename\") | .searchTerms | .[] | .searchTerm")
      echo "Search terms: $searchTerms"
      for searchTerm in $searchTerms; do

        # get the count of the search term and append it to the report
        count=$(echo "$analysis" | jq -r ".[] | select(.filename == \"$filename\") | .searchTerms | .[] | select(.searchTerm == \"$searchTerm\") | .count")
        output+=" $count $searchTerm(s),"
      done

      # remove the last comma and append a newline
      output=${output%?}"\n"
    done
done

# Write report to file
echo -e "$output" > "$output_directory"/log-analysis-report.txt