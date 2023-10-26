#!/bin/bash

# check .env first
docker-compose down -v \
&& docker-compose up --build -d \
&& docker-compose logs -f
