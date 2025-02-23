#!/bin/bash

root_dir=$(pwd)
api_dir=$root_dir/api

cd $api_dir

db_name=""
if [ -f .env ]; then
    db_name=$(grep "DB_NAME=" .env | cut -d '=' -f2)
else
    echo "Error: .env file not found"
    exit 1
fi

read -p "Enter migration name: " migration_name

wrangler d1 migrations create $db_name $migration_name

cd $root_dir