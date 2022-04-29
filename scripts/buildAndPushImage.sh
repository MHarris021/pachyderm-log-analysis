set -x

version=$1
docker build --no-cache -t pachyderm-log-analyzer .
docker tag pachyderm-log-analyzer darcstarsolutions/pachyderm-log-analyzer:"$version"
docker push darcstarsolutions/pachyderm-log-analyzer:"$version"