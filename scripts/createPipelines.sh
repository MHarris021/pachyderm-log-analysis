# Script purpose: Create pachyderm pipelines from all of the jsonnet defined pipelines
# These pipelines are used to analyze log files and generate a human readable report
# Usage: ./createPipelines.sh <imageTag>
# Example: ./createPipelines.sh darcstarsolutions/pachyderm-log-analyzer:1.2.20

set -x

# Docker image to use for the pipelines
imageTag=$1

# Check if the image tag is set
if [ -z "$imageTag" ]; then
  echo "Usage: $0 <imageTag>"
  exit 1
fi

# Create the pachyderm pipelines

# Create the pipeline to count the number of times `warning` appears in the the log files
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="warning" --arg searchTerm="warning" --arg imageTag="${imageTag}"

# Create the pipeline to count the number of times `error` appears in the the log files
pachctl create pipeline --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="error" --arg searchTerm="error" --arg imageTag="${imageTag}"

# Create the pipeline to reduce the output of the log file analyzer pipelines to a single json file per log file
pachctl create pipeline --jsonnet ./pipelines/log-analyzer-reducer.jsonnet --arg pipeline1="log-analyzer-warning" --arg pipeline2="log-analyzer-error" --arg imageTag="${imageTag}"

# Create the pipeline to combine the output of the reduced log file analysis pipelines into a single combined json file
pachctl create pipeline --jsonnet ./pipelines/combine-log-analysis.jsonnet --arg inputPipeline="log-analyzer-reducer" --arg imageTag="${imageTag}"

# Create the pipeline to generate a human readable report from the combined log file analysis pipeline
pachctl create pipeline --jsonnet ./pipelines/create-log-analysis-report.jsonnet --arg inputPipeline="combine-log-analysis" --arg imageTag="${imageTag}"