#!/bin/bash
set -e

#Pull the docker image from dockerhub
docker pull shubham315/python-flask-service-app:latest

# Run the docker image as container
docker run -d -p 5000:5000 shubham315/python-flask-service-app:latest