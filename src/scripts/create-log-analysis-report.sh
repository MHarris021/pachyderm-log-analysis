# Script will quickly analyze a file, count the number of lines that contain a provided search term and output the results to a file in the /pfs/out directory
set -x

input_directory=$1
output_directory=$2
output="Log Analysis Report:\n\n"
for f in "$input_directory"/*.json; do
    echo "Processing $f"
    analysis=$(jq '.analysis' "$f")
    if [ -z "$analysis" ]; then
        echo "No analysis found in $f"
        continue
    fi
    filenames=$(echo "$analysis" | jq -r '.[] | .filename')
    for filename in $filenames; do
      path=$(echo "$analysis" | jq -r ".[] | select(.filename == \"$filename\") | .filepath")
      output+="Log file $filename found in $path has"
      searchTerms=$(echo "$analysis" | jq -r ".[] | select(.filename == \"$filename\") | .searchTerms | .[] | .searchTerm")
      echo "Search terms: $searchTerms"
      for searchTerm in $searchTerms; do
        count=$(echo "$analysis" | jq -r ".[] | select(.filename == \"$filename\") | .searchTerms | .[] | select(.searchTerm == \"$searchTerm\") | .count")
        output+=" $count $searchTerm(s),"
      done
      output=${output%?}"\n"
    done
done
echo -e "$output" > "$output_directory"/log-analysis-report.txt