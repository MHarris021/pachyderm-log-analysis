#  Script to tear down the demo pipelines and data

set -x

# Remove the demo pipelines
pachctl delete all

