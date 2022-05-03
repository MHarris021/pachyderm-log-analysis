set -x

# Load test data
pachctl put file -r logs@master:/. -f ./data/test/logs/