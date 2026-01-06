#!/usr/bin/env bash

# Usage: ./test-php-fpm-lb.sh [N] [HOST]
#   N = number of requests (default: 100)
#   HOST = host:port (default: localhost:8080)
#set -xeu

N=${1:-100}
HOST=${2:-${HOST:-"localhost:8080"}}

echo "Testing load balancing: sending $N requests to http://${HOST}/hostname.php"
echo "--------------------------------------------------"

# Temporary file to store results
TMP_FILE=$(mktemp)

# Send N curl requests (sequentially is fine for this test)
for ((i=1; i<=N; i++)); do
    # -s = silent, -f = fail silently on HTTP errors (we don't expect any)
    hostname=$(curl -s -f http://${HOST}/hostname.php)
    if [ $? -eq 0 ]; then
        echo "$hostname" >> "$TMP_FILE"
    else
        echo "ERROR: Request $i failed" >&2
    fi

    # Optional: show progress every 20 requests
    (( i % 20 == 0 )) && echo "Progress: $i/$N requests sent..."
done

echo "--------------------------------------------------"
echo "Results ($N requests):"

# Count occurrences and sort by count descending
sort "$TMP_FILE" | uniq -c | sort -nr

# Optional summary
unique_count=$(wc -l < <(sort "$TMP_FILE" | uniq))
echo "--------------------------------------------------"
echo "Unique containers hit: $unique_count"
echo "Ideal even distribution would be ~$((N / unique_count)) requests per container (if $unique_count containers exist)"

# Cleanup
rm -f "$TMP_FILE"