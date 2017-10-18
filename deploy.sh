#!/bin/bash

if [ "$1" = "" ]
then
  echo "Usage: $0 <CLUSTER>"
  exit
fi

CLUSTER=$1
APP="mailcatcher"
IMAGE="flynn-mailcatcher"

# Build docker image from Dockerfile
docker build -t $IMAGE .

# Create flynn app without remote
flynn -c $CLUSTER create $APP --remote ""

# Push docker image to remote app
flynn -c $CLUSTER -a $APP docker push $IMAGE

# Scale up app on flynn cluster
flynn -c $CLUSTER -a $APP scale app=1

# Add tcp router for smtp port
flynn -c $CLUSTER -a $APP route add tcp -p 1025 -s $APP-smtp

# Update app release with config exposing smtp port
flynn -c $CLUSTER -a $APP release update config.json
