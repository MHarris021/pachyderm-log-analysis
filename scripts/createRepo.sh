# Script purpose: Create a new pachyderm repository based on the given input
# Usage: ./createRepo.sh <repoName>
# Example: ./createRepo.sh logs

set -x

# Get parameters
repoName=$1

# Check if the user has provided a repo name
if [ -z "$repoName" ]; then
  echo "Usage: createRepo.sh <repoName>"
  exit 1
fi

# Create the repo
pachctl create repo "$repoName"