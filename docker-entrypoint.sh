#!/bin/bash
set -e

PORT=${PORT:-8080}

sed -i "s/port=\"8080\"/port=\"$PORT\"/" /usr/local/tomcat/conf/server.xml
sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

exec "$@"
