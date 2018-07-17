#!/bin/bash
set -e
 
if ! [[ -d ../logs/apache ]]; then
    mkdir -p ../logs/apache
fi
 
if ! [[ -d ../logs/mysql ]]; then
    mkdir -p ../logs/mysql
fi
 
if ! [[ -d ../logs/php ]]; then
    mkdir -p ../logs/php
fi
 
if ! [[ -d ../database ]]; then
    mkdir ../database
fi

if ! [[ -d ../public_html ]]; then
    mkdir ../public_html
    echo "<?php phpinfo(); ?>" > ../public_html/index.php
fi

# BUILD DOCKER CONTAINERS
docker-compose up --build

#detached mode
#docker-compose up -d --build
 