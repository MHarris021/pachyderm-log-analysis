# This script is used to update the demo by first tearing it down and then rebuilding it.
# Usage: ./updateDemo.sh <imageVersion> [true|false] [imageRepo] [imageName] [inputDir]
# Example: ./updateDemo.sh 1.0.0 true
# Example: ./updateDemo.sh 1.0.0 false
# Example: ./updateDemo.sh 1.0.0 false localhost:5000/my-image-repo my-image-name my-input-dir

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

# Set the default value
if [ -z "$inputDir" ] ; then
  inputDir="./data/test/logs/"
fi

# Teardown the demo
./teardownDemo.sh

# Build the demo
./setupDemo.sh "$imageVersion" "$noCache" "$imageRepo" "$imageName" "$inputDir"