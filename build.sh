#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_JAVA="$PROJECT_DIR/src/main/java"
SRC_RESOURCES="$PROJECT_DIR/src/main/resources"
WEBAPP_DIR="$PROJECT_DIR/src/main/webapp"
BUILD_DIR="$PROJECT_DIR/build"
LIB_DIR="$PROJECT_DIR/lib"
# Resolve Tomcat — prefer TOMCAT_HOME env var, then common Linux install paths
if [ -z "$TOMCAT_HOME" ]; then
    for candidate in \
        "/opt/tomcat11" \
        "/opt/tomcat" \
        "$HOME/tomcat11" \
        "$HOME/tomcat" \
        "/usr/share/tomcat11" \
        "/usr/share/tomcat9"
    do
        if [ -d "$candidate/lib" ]; then
            TOMCAT_HOME="$candidate"
            break
        fi
    done
fi

if [ -z "$TOMCAT_HOME" ] || [ ! -d "$TOMCAT_HOME/lib" ]; then
    echo "Tomcat not found. Download Tomcat 11 from https://tomcat.apache.org/download-11.cgi,"
    echo "extract it, then run: TOMCAT_HOME=/path/to/tomcat ./build.sh"
    exit 1
fi

TOMCAT_LIB="$TOMCAT_HOME/lib"
TOMCAT_WEBAPPS="$TOMCAT_HOME/webapps"
echo "  Using Tomcat at: $TOMCAT_HOME"
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

if [ ! -f "$LIB_DIR/jakarta.servlet.jsp.jstl-3.0.1.jar" ]; then
    echo "  Downloading Jakarta JSTL..."
    wget -q -O "$LIB_DIR/jakarta.servlet.jsp.jstl-3.0.1.jar" \
        "https://repo1.maven.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/3.0.1/jakarta.servlet.jsp.jstl-3.0.1.jar"
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

if [ -w "$TOMCAT_WEBAPPS" ]; then
    rm -rf "$TOMCAT_WEBAPPS/$APP_NAME"
    cp -r "$BUILD_DIR" "$TOMCAT_WEBAPPS/$APP_NAME"
else
    sudo rm -rf "$TOMCAT_WEBAPPS/$APP_NAME"
    sudo cp -r "$BUILD_DIR" "$TOMCAT_WEBAPPS/$APP_NAME"
fi

echo "[5/5] Restarting Tomcat..."

if systemctl is-active --quiet tomcat 2>/dev/null; then
    sudo systemctl restart tomcat
elif systemctl is-active --quiet tomcat9 2>/dev/null || systemctl is-enabled --quiet tomcat9 2>/dev/null; then
    sudo systemctl restart tomcat9
else
    "$TOMCAT_HOME/bin/shutdown.sh" 2>/dev/null || true
    sleep 2
    "$TOMCAT_HOME/bin/startup.sh"
fi

echo ""
echo "=== Deployed ==="
echo "Site:  http://localhost:8080/$APP_NAME"
echo "Admin: http://localhost:8080/$APP_NAME/admin/login.jsp"
