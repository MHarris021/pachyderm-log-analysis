set -x

imageTag=$1

# Create the pachyderm pipelines
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="warning" --arg searchTerm="warning" --arg imageTag="${imageTag}"
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="error" --arg searchTerm="error" --arg imageTag="${imageTag}"
pachctl create pipeline --jsonnet ./pipelines/log-analyzer-reducer.jsonnet --arg pipeline1="log-analyzer-warning" --arg pipeline2="log-analyzer-error" --arg imageTag="${imageTag}"
pachctl create pipeline --jsonnet ./pipelines/combine-log-analysis.jsonnet --arg inputPipeline="log-analyzer-reducer" --arg imageTag="${imageTag}"
pachctl create pipeline --jsonnet ./pipelines/create-log-analysis-report.jsonnet --arg inputPipeline="combine-log-analysis" --arg imageTag="${imageTag}"