#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_JAVA="$PROJECT_DIR/src/main/java"
SRC_RESOURCES="$PROJECT_DIR/src/main/resources"
WEBAPP_DIR="$PROJECT_DIR/src/main/webapp"
BUILD_DIR="$PROJECT_DIR/build"
LIB_DIR="$PROJECT_DIR/lib"
TOMCAT_LIB="/usr/share/tomcat9/lib"
TOMCAT_WEBAPPS="/var/lib/tomcat9/webapps"
APP_NAME="CyberNova"

echo "=== CyberNova Analytics Build ==="

mkdir -p "$BUILD_DIR/WEB-INF/classes"
mkdir -p "$BUILD_DIR/WEB-INF/lib"
mkdir -p "$LIB_DIR"

echo "[1/5] Checking dependencies..."

if [ ! -f "$LIB_DIR/postgresql-42.7.3.jar" ]; then
    echo "  Downloading PostgreSQL JDBC driver..."
    wget -q -O "$LIB_DIR/postgresql-42.7.3.jar" \
        "https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar"
fi

if [ ! -f "$LIB_DIR/taglibs-standard-spec-1.2.5.jar" ]; then
    echo "  Downloading JSTL spec..."
    wget -q -O "$LIB_DIR/taglibs-standard-spec-1.2.5.jar" \
        "https://repo1.maven.org/maven2/org/apache/taglibs/taglibs-standard-spec/1.2.5/taglibs-standard-spec-1.2.5.jar"
fi

if [ ! -f "$LIB_DIR/taglibs-standard-impl-1.2.5.jar" ]; then
    echo "  Downloading JSTL impl..."
    wget -q -O "$LIB_DIR/taglibs-standard-impl-1.2.5.jar" \
        "https://repo1.maven.org/maven2/org/apache/taglibs/taglibs-standard-impl/1.2.5/taglibs-standard-impl-1.2.5.jar"
fi

echo "[2/5] Compiling Java sources..."

CLASSPATH=""
for jar in "$TOMCAT_LIB"/*.jar; do
    CLASSPATH="$CLASSPATH:$jar"
done
for jar in "$LIB_DIR"/*.jar; do
    CLASSPATH="$CLASSPATH:$jar"
done
CLASSPATH="${CLASSPATH:1}"

find "$SRC_JAVA" -name "*.java" > /tmp/cybernova_sources.txt
javac -cp "$CLASSPATH" -d "$BUILD_DIR/WEB-INF/classes" @/tmp/cybernova_sources.txt

if [ $? -ne 0 ]; then
    echo "BUILD FAILED"
    exit 1
fi

echo "[3/5] Assembling application..."

cp -r "$WEBAPP_DIR/"* "$BUILD_DIR/"
cp "$SRC_RESOURCES/"* "$BUILD_DIR/WEB-INF/classes/" 2>/dev/null
cp "$LIB_DIR/"*.jar "$BUILD_DIR/WEB-INF/lib/"
if [ -f "$PROJECT_DIR/.env" ]; then
    cp "$PROJECT_DIR/.env" "$BUILD_DIR/WEB-INF/classes/.env"
fi

echo "[4/5] Deploying to Tomcat..."

sudo rm -rf "$TOMCAT_WEBAPPS/$APP_NAME"
sudo cp -r "$BUILD_DIR" "$TOMCAT_WEBAPPS/$APP_NAME"
sudo chown -R tomcat9:tomcat9 "$TOMCAT_WEBAPPS/$APP_NAME"

echo "[5/5] Restarting Tomcat..."

sudo systemctl restart tomcat9

echo ""
echo "=== Deployed ==="
echo "Site:  http://localhost:8080/$APP_NAME"
echo "Admin: http://localhost:8080/$APP_NAME/admin/login.jsp"
