# Script purpose: Build and push the docker image to the docker hub
# Usage: ./buildAndPushImage.sh <image_repository> <image_name> <image_version> [true|false]
# Example: ./buildAndPushImage.sh my-repo my-image 1.0.0 true
# Set noCache to true to force a rebuild of the image

set -x

# Get parameters
imageRepo="$1"
imageName="$2"
imageVersion="$3"
noCache=$4

# Check if the user has passed all the required parameters
if [ -z "$imageRepo" ] || [ -z "$imageName" ] || [ -z "$imageVersion" ]; then
  echo "Usage: $0 <imageRepo> <imageName> <imageVersion> [true|false]"
  exit 1
fi

# Set default value for noCache
if [ -z "$noCache" ]; then
  noCache="false"
fi

# Create the image tag
imageTag="${imageRepo}/${imageName}:${imageVersion}"

# Build and push the image
docker build --pull --no-cache="${noCache}" -t "${imageTag}" .
docker tag "${imageTag}" "${imageTag}"
docker push "${imageTag}"
