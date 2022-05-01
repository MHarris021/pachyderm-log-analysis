# Script will quickly analyze a file, count the number of lines that contain a provided search term and output the results to a file in the /pfs/out directory
set -x

input_directory=$1
output_directory=$2
output="{ \"input_directory\": \"$input_directory\", \"analysis\": [ "
for f in "$input_directory"/*.json; do
    echo "Processing $f"
    output+=$(jq '.' "$f")
    output+=","
done
output=${output%?}"]}"
echo "$output" | jq '.' > "$output_directory"/combined-log-analysis.json