#!/bin/bash

db_name=""
if [ -f .env ]; then
    db_name=$(grep "DB_NAME=" .env | cut -d '=' -f2)
else
    echo "Error: .env file not found"
    exit 1
fi

# Set default value for local flag
local=true

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --local=*)
            local="${1#*=}"
            shift
            ;;
        *)
            shift
            ;;
    esac
done


if [ "$local" = true ]; then
    wrangler d1 migrations list $db_name --local
else
    wrangler d1 migrations list $db_name --remote
fi

if [ "$local" = true ]; then
    wrangler d1 migrations apply $db_name --local
else
    wrangler d1 migrations apply $db_name --remote
fi

 