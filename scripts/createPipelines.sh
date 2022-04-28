set -x

pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="warning" --arg phrase="warning"
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="error" --arg phrase="error"
