#!/bin/bash
set -e
 
docker-compose down --volumes
#docker rmi webapp_apache_img webapp_php_img webapp_mysql_img