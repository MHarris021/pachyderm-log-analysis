set -x

version=$1
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="warning" --arg searchTerm="warning" --arg imageVersion="$version"
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="error" --arg searchTerm="error" --arg imageVersion="$version"