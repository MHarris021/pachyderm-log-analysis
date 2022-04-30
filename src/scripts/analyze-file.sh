# Script will quickly analyze a file, count the number of lines that contain a provided search term and output the results to a file in the /pfs/out directory
set -x

searchTerm=$1
directory=$2
output_directory=$3
for f in "$directory"/*.log; do
    echo "Processing $f"
    directory=$(dirname "$f")
    subdirectory=$(basename "$directory")
    filename=$(basename "$f")
    count=$(grep -icw "$searchTerm" "$f")
    mkdir -p "$output_directory"/"$subdirectory"
    output="{\"filename\":\"$filename\", \"filepath\":\"$directory\",\"searchTerm\": \"$searchTerm\", \"count\": \"$count\" }"
    echo "$output" | jq '.'  >> "$output_directory"/"$subdirectory"/"$filename"-analysis.json
done