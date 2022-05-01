# Script will quickly analyze a file, count the number of lines that contain a provided search term and output the results to a file in the /pfs/out directory
set -x

searchTerm=$1
directory=$2
output_directory=$3
subdirectory=$(basename "$directory")
mkdir -p "$output_directory"/"$subdirectory"

for f in "$directory"/*.log; do
    echo "Processing $f"
    filename=$(basename "$f")
    count=$(grep -icw "$searchTerm" "$f")
    output="{\"filename\":\"$filename\", \"filepath\":\"$directory\",\"searchTerm\": \"$searchTerm\", \"count\": \"$count\" }"
    echo "$output" | jq '.'  >> "$output_directory"/"$subdirectory"/"$filename"-analysis.json
done