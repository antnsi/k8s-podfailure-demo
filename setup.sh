#!/bin/bash

brew install kubectl
brew install kind

# create cluster
kind delete cluster --name pfptest
kind create cluster --name pfptest --config kind-config.yaml

# build and load the image
docker build -t local/pfptest:latest .
kind load docker-image local/pfptest:latest --name pfptest
docker exec pfptest-worker crictl images | grep pfptest

