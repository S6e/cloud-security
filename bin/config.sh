#!/bin/bash

##################################################
#
# Configuration settings for the Security showcase.
#
# This file defines some variables that can be used in other scripts by
# including it with: source config.sh
#
##################################################

# Persistent volume settings for mongodb
PV_MONGODB_PATH="/data/api-gw-mongodb"
PV_MONGODB_SIZE="1Gi"
PV_MONGODB_VOLUMES_PER_NODE="3" # max=10

# Persistent volume settings for elasticsearch
PV_ES_PATH="/data/api-gw-es"
PV_ES_SIZE="1Gi"
PV_ES_VOLUMES_PER_NODE="3" # max=10

