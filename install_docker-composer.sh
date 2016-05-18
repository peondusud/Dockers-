#!/bin/bash

# docker compose
curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

