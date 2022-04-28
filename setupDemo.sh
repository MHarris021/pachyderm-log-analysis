set -x

./scripts/buildAndPushImage.sh
./scripts/createRepo.sh logs
./scripts/loadTestData.sh
./scripts/createPipelines.sh