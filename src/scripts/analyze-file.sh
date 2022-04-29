# Script will quickly analyze a file, count the number of lines that contain a provided search term and output the results to a file in the /pfs/out directory
set -x
for f in /pfs/logs/*.log; do
    echo "Processing $f"
    directory=$(dirname "$f")
    out=$(basename "$directory")
    echo "{'name':'$f', 'phrase': '$1', 'count': '$(grep -icw "$1" "$f")' }" >> /pfs/out/"$out"-"$PACH_DATUM_ID"-analysis.json
done