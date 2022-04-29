set -x


version=$1
./scripts/buildAndPushImage.sh "$version"
./scripts/createRepo.sh logs
./scripts/loadTestData.sh
./scripts/createPipelines.sh "$version"