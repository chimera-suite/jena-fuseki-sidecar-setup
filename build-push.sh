#! /bin/bash

# Ensure that there no pending changes
if [[ `git status --porcelain` ]]; then
    echo "Please commit your changes before building"
    exit 1
fi

TAG=$(git rev-parse --short HEAD)

echo "Building with tag ${TAG}"

docker build -t "chimerasuite/jena-fuseki-sidecar-setup:${TAG}" .

echo "Enter you dockerhub credentials"
read -p "Username:" username
read -s -p "Password:" password
echo ""

echo "${password}" | docker login --username "${username}" --password-stdin

echo "Pushing to Dockerhub"

docker push "chimerasuite/jena-fuseki-sidecar-setup:${TAG}"
