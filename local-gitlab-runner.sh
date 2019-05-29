#!/bin/bash
. .config
sudo gitlab-runner register -n \
   --url https://gitlab.com/ \
   --registration-token $REGISTRATION_TOKEN \
   --executor shell \
   --description "Roadrunner"
sudo usermod -aG docker gitlab-runner
sudo -u gitlab-runner -H docker info
