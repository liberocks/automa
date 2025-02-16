#!/bin/bash

db_name="automa_database"

read -p "Enter migration name: " migration_name

wrangler d1 migrations create $db_name $migration_name
