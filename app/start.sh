#!/bin/bash

# Check if db exists and if not create it and add files that aren't av1 to the db
/app/db_create.sh

# Run encoder
/app/db_encoder.sh