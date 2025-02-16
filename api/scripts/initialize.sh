#!/bin/bash

timestamp=$(date +%s)
db_name="automa_database_$timestamp"

if [ ! -f .env ]; then
    # Create new .env file if it doesn't exist
    echo "DB_NAME=$db_name" > .env
fi

# If DB_NAME exists, replace it, otherwise append it
if grep -q "^DB_NAME=" .env; then
    sed -i '' "s/^DB_NAME=.*$/DB_NAME=$db_name/" .env
else
    echo "DB_NAME=$db_name" >> .env
fi

database_id=$(npx wrangler d1 create $db_name | grep -o '"database_id": "[^"]*"' | cut -d'"' -f4)

if grep -q "^DATABASE_ID=" .env; then
    sed -i '' "s/^DATABASE_ID=.*$/DATABASE_ID=$database_id/" .env
else
    echo "DATABASE_ID=$database_id" >> .env
fi

# Create wrangler.jsonc with real values replacing placeholders from wrangler.jsonc.example
if [ -f wrangler.jsonc.example ]; then
    sed "s/DATABASE_NAME/$db_name/g; s/DATABASE_ID/$database_id/g" wrangler.jsonc.example > wrangler.jsonc
    echo "Created wrangler.jsonc successfully."
else
    echo "Error: wrangler.jsonc.example file not found. Cannot create wrangler.jsonc"
fi