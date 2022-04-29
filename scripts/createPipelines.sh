set -x

version=$1
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="warning" --arg phrase="warning" --arg imageVersion="$version"
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="error" --arg phrase="error" --arg imageVersion="$version"
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="critical" --arg phrase="critical" --arg imageVersion="$version"