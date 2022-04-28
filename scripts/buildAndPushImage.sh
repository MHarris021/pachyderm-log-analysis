set -x
docker build --no-cache -t pachyderm-log-analyzer .
docker tag pachyderm-log-analyzer darcstarsolutions/pachyderm-log-analyzer:1.0.1
docker push darcstarsolutions/pachyderm-log-analyzer:1.0.1