#!/bin/sh

docker run -d -p 80:80 -v $PWD/www/:/usr/local/apache2/htdocs/ httpd