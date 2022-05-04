# Script purpose: Update the deployed pachyderm pipelines
# Usage: ./updatePipelines.sh <imageTag> [true|false]
# Example: ./updatePipelines.sh v0.0.1

set -x

# Get parameters
imageTag=$1
reprocess=$2

# Check parameters
if [ -z "$imageTag" ]; then
  echo "Usage: $0 <imageTag> [true|false]"
  exit 1
fi

# Set default reprocess
if [ -z "$reprocess" ]; then
  reprocess=false # default
fi

# Update the pipelines

# Update the pipeline for analyzing the log files for the `warning` searchTerm
pachctl update pipeline --reprocess="$reprocess" --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="warning" --arg searchTerm="warning" --arg imageTag="$imageTag"

# Update the pipeline for analyzing the log files for the `error` searchTerm
pachctl update pipeline --reprocess="$reprocess" --jsonnet ./pipelines/log-analyzer.jsonnet --arg suffix="error" --arg searchTerm="error" --arg imageTag="$imageTag"

# Update the pipeline for reducing the log file analysis results to a single json file per log file
pachctl update pipeline --reprocess="$reprocess" --jsonnet ./pipelines/log-analyzer-reducer.jsonnet --arg pipeline1="log-analyzer-warning" --arg pipeline2="log-analyzer-error" --arg imageTag="$imageTag"

# Update the pipeline for combining the log file analysis results into a single json file
pachctl update pipeline --reprocess="$reprocess" --jsonnet ./pipelines/combine-log-analysis.jsonnet --arg inputPipeline="log-analyzer-reducer" --arg imageTag="$imageTag"

# Update the pipeline for converting the combined log file analysis json file to a human readable report
pachctl update pipeline --reprocess="$reprocess" --jsonnet ./pipelines/create-log-analysis-report.jsonnet --arg inputPipeline="combine-log-analysis" --arg imageTag="$imageTag"
