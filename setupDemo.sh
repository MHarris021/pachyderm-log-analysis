set -x


version=$1
noCache=$2
./scripts/buildAndPushImage.sh "$version" "$noCache"
./scripts/createRepo.sh logs
./scripts/loadTestData.sh
./scripts/createPipelines.sh "$version"