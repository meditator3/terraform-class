#!/bin/bash


# boot-finished is a cloud file, created after boot has finished.
#slepp until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
    sleep 1
done



# install nginx
apt update
apt -y install nginx


# make sure nginx has started
service nginx start
# change index.html
echo "<h1> THIS IS ARIEL NGINX CONVERT HTML </h1>" >> /var/www/html/index.html
echo "<h2> and even added this one to it </h2>" >> /var/www/html/index.html