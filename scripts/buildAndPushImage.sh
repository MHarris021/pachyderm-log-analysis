set -x

version=$1
noCache=$2
# shellcheck disable=SC2086
docker build $noCache -t pachyderm-log-analyzer .
docker tag pachyderm-log-analyzer darcstarsolutions/pachyderm-log-analyzer:"$version"
docker push darcstarsolutions/pachyderm-log-analyzer:"$version"