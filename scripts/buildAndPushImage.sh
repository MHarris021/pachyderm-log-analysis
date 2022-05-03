set -x

imageRepo="$1"
imageName="$2"
imageVersion="$3"
noCache=$4

imageTag="${imageRepo}/${imageName}:${imageVersion}"
# shellcheck disable=SC2086
docker build $noCache -t "$imageName" .
docker tag "$imageName" "$imageTag"
docker push "$imageTag"