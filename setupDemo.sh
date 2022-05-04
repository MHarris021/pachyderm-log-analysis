# Script purpose: This script is used to setup the demo pipelines.
# Usage: ./setupDemo.sh <imageVersion> [true|false] [imageRepo] [imageName] [inputDir]
# Example: ./setupDemo.sh 1.0.0
# Example: ./setupDemo.sh 1.0.0 true
# Example: ./setupDemo.sh 1.0.0 true docker.io/myrepo myimage
# Example: ./setupDemo.sh 1.0.0 true docker.io/myrepo myimage /my/input/dir

set -x

# Get the parameters
imageVersion=$1
noCache=$2
imageRepo=$3
imageName=$4
inputDir=$5

# Check if all of the parameters are set
if [ -z "$imageVersion" ] ; then
  echo "Usage: $0 <imageVersion> [true|false] [imageRepo] [imageName] [inputDir]"
  exit 1
fi

# Set the default value
if [ -z "$imageRepo" ] ; then
  imageRepo="darcstarsolutions"
fi

# Set the default value
if [ -z "$imageName" ] ; then
  imageName="pachyderm-log-analyzer"
fi

# Crate the image tag
imageTag="${imageRepo}/${imageName}:${imageVersion}"

# Set the default value
if [ -z "$inputDir" ] ; then
  inputDir="./data/test/logs/"
fi

# Build and push the image
./scripts/buildAndPushImage.sh "$imageRepo" "$imageName" "$imageVersion" "$noCache"

# Create the pachyderm repo
./scripts/createRepo.sh logs

# Load the data
./scripts/loadTestData.sh logs "$inputDir"

# Create the pipelines
./scripts/createPipelines.sh "$imageTag"