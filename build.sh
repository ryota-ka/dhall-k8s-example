#!/bin/bash -eu

rm ./dist/*

# nginx
dhall-to-yaml --omitNull --explain <<< './deployment.yaml.dhall ./nginx.dhall' > ./dist/nginx.deployment.yaml
dhall-to-yaml --omitNull --explain <<< './service.yaml.dhall ./nginx.dhall' > ./dist/nginx.service.yaml
