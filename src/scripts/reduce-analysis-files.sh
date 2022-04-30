# Script will quickly analyze a file, count the number of lines that contain a provided search term and output the results to a file in the /pfs/out directory
set -x

directory1=$1
directory2=$2
output_directory=$3
for f in "$directory1"/*.json; do
    echo "Processing $f"
    directory=$(dirname "$f")
    subdirectory=$(basename "$directory")
    mkdir -p "$output_directory/$subdirectory"
    filename=$(jq -r '.filename' "$f")
    filepath=$(jq -r '.filepath' "$f")
    searchTerm1=$(jq -r '.searchTerm' "$f")
    count1=$(jq -r '.count' "$f")
    f2="$directory2"/$(basename "$f")
    searchTerm2=$(jq -r '.searchTerm' "$f2")
    count2=$(jq -r '.count' "$f2")
    output="{\"filename\":\"$filename\", \"filepath\":\"$filepath\",\"searchTerms\": [{\"searchTerm\":\"$searchTerm1\", \"count\": \"$count1\"}, {\"searchTerm\":\"$searchTerm2\", \"count\": \"$count2\"}] }"
    echo "$output" | jq '.' >> "$output_directory"/"$filename"-"$PACH_DATUM_ID"-analysis.json
done