#!/bin/bash

root_dir=$(pwd)
api_dir=$root_dir/api
frontend_dir=$root_dir/app

app_name="automa"
timestamp=$(date +%s)
db_name="automa_database_$timestamp"

cd $api_dir

if [ ! -f .env ]; then
    touch .env
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

if [ -f wrangler.json.example ]; then
    sed "s/DATABASE_NAME/$db_name/g; s/DATABASE_ID/$database_id/g" wrangler.json.example > wrangler.json
    echo "Created wrangler.json successfully."
else
    echo "Error: wrangler.json.example file not found. Cannot create wrangler.json"
fi

api_url=$(npx wrangler deploy 2>/dev/null | grep -o 'https://.*\.workers\.dev')
if [ ! -z "$api_url" ]; then
    if grep -q "^API_URL=" .env; then
        sed -i '' "s|^API_URL=.*$|API_URL=$api_url|" .env
    else
        echo "API_URL=$api_url" >> .env
    fi
fi

cd $frontend_dir

if [ ! -f .env ]; then
    touch .env
fi

# If API_URL exists, replace it, otherwise append it
if grep -q "^API_URL=" .env; then
    sed -i '' "s/^API_URL=.*$/API_URL=$api_url/" .env
else
    echo "API_URL=$api_url" >> .env
fi

if [ -f wrangler.json.example ]; then
    sed "s|\"API_URL\": \"API_URL\"|\"API_URL\": \"$api_url\"|g" wrangler.json.example > wrangler.json
    echo "Created wrangler.json successfully."
else
    echo "Error: wrangler.json.example file not found. Cannot create wrangler.json"
fi

npx wrangler pages project create $app_name --production-branch main

app_url=$(pnpm run deploy 2>&1 | grep -o 'https://.*\.pages\.dev')
if [ ! -z "$app_url" ]; then
    if grep -q "^APP_URL=" $api_dir/.env; then
        sed -i '' "s|^APP_URL=.*$|APP_URL=$app_url|" $api_dir/.env
    else
        echo "APP_URL=$app_url" >> $api_dir/.env
    fi
fi

if grep -q "^APP_URL=" .env; then
    sed -i '' "s/^APP_URL=.*$/APP_URL=$app_url/" .env
else
    echo "APP_URL=$app_url" >> .env
fi

cd $root_dir

echo "Initialized project successfully."
echo "API URL: $api_url"
echo "App URL: $app_url"

