# Script purpose: Load test data into the pachyderm repo
# Usage: ./loadTestData.sh <repoName> <inputDir>
# Example: ./loadTestData.sh pachyderm-test-data /tmp/test-data

set -x

# Get parameters
repoName="$1"
inputDir="$2"

# Check if user has provided the required parameters
if [ -z "$repoName" ] || [ -z "$inputDir" ]; then
  echo "Usage: $0 <repoName> <inputDir>"
  exit 1
fi


# Load test data
pachctl put file -r "$repoName"@master:/. -f "$inputDir"