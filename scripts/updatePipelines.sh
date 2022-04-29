set -x

version=$1
pachctl update pipeline --reprocess --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="warning" --arg phrase="warning" --arg imageVersion="$version"
pachctl update pipeline --reprocess --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="error" --arg phrase="error" --arg imageVersion="$version"
