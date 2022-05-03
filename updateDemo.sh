set -x

# This script is used to update the demo.
imageVersion=$1
noCache=$2
imageRepo=$3
imageName=$4

# Check if all of the parameters are set
if [ -z "$imageVersion" ] ; then
  echo "Usage: $0 <imageVersion> [noCache] [imageRepo] [imageName]"
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

./teardownDemo.sh
./setupDemo.sh "$imageVersion" "$noCache" "$imageRepo" "$imageName"