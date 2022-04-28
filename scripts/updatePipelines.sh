set -x

pachctl update pipeline --reprocess --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="warning" --arg phrase="warning"
pachctl update pipeline --reprocess --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="error" --arg phrase="error"
