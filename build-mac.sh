#!/bin/bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_JAVA="$PROJECT_DIR/src/main/java"
SRC_RESOURCES="$PROJECT_DIR/src/main/resources"
WEBAPP_DIR="$PROJECT_DIR/src/main/webapp"
BUILD_DIR="$PROJECT_DIR/build"
LIB_DIR="$PROJECT_DIR/lib"
APP_NAME="CyberNova"

# Resolve Tomcat home — priority:
#   1. TOMCAT_HOME environment variable (covers IntelliJ / manual installs)
#   2. Homebrew (Apple Silicon)
#   3. Homebrew (Intel)
#   4. Common manual extract locations

if [ -z "$TOMCAT_HOME" ]; then
    if [[ $(uname -m) == 'arm64' ]]; then
        BREW_CANDIDATE="/opt/homebrew/opt/tomcat@9/libexec"
    else
        BREW_CANDIDATE="/usr/local/opt/tomcat@9/libexec"
    fi

    for candidate in \
        "$BREW_CANDIDATE" \
        "$HOME/tomcat9" \
        "$HOME/tomcat" \
        "/opt/tomcat9" \
        "/opt/tomcat" \
        "/Applications/Tomcat9" \
        "/Applications/Tomcat"
    do
        if [ -d "$candidate/lib" ]; then
            TOMCAT_HOME="$candidate"
            break
        fi
    done
fi

if [ -z "$TOMCAT_HOME" ] || [ ! -d "$TOMCAT_HOME/lib" ]; then
    echo "Tomcat 9 not found. Either:"
    echo "  a) Install via Homebrew:  brew install tomcat@9"
    echo "  b) Download the zip from https://tomcat.apache.org/download-90.cgi,"
    echo "     extract it, then run:"
    echo "       TOMCAT_HOME=/path/to/extracted/tomcat ./build-mac.sh"
    echo "  c) If using IntelliJ, set TOMCAT_HOME to the directory IntelliJ"
    echo "     points at (Run Configurations → Application server path)"
    exit 1
fi

TOMCAT_LIB="$TOMCAT_HOME/lib"
TOMCAT_WEBAPPS="$TOMCAT_HOME/webapps"

echo "  Using Tomcat at: $TOMCAT_HOME"

if [ ! -f "$SRC_RESOURCES/db.properties" ]; then
    echo "db.properties not found. Copy the example and fill in your credentials:"
    echo "  cp src/main/resources/db.properties.example src/main/resources/db.properties"
    exit 1
fi

echo "=== CyberNova Analytics Build (macOS) ==="

mkdir -p "$BUILD_DIR/WEB-INF/classes"
mkdir -p "$BUILD_DIR/WEB-INF/lib"
mkdir -p "$LIB_DIR"

echo "[1/5] Checking dependencies..."

if [ ! -f "$LIB_DIR/postgresql-42.7.3.jar" ]; then
    echo "  Downloading PostgreSQL JDBC driver..."
    curl -fsSL -o "$LIB_DIR/postgresql-42.7.3.jar" \
        "https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar"
fi

if [ ! -f "$LIB_DIR/taglibs-standard-spec-1.2.5.jar" ]; then
    echo "  Downloading JSTL spec..."
    curl -fsSL -o "$LIB_DIR/taglibs-standard-spec-1.2.5.jar" \
        "https://repo1.maven.org/maven2/org/apache/taglibs/taglibs-standard-spec/1.2.5/taglibs-standard-spec-1.2.5.jar"
fi

if [ ! -f "$LIB_DIR/taglibs-standard-impl-1.2.5.jar" ]; then
    echo "  Downloading JSTL impl..."
    curl -fsSL -o "$LIB_DIR/taglibs-standard-impl-1.2.5.jar" \
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

echo "[4/5] Deploying to Tomcat..."

rm -rf "$TOMCAT_WEBAPPS/$APP_NAME"
cp -r "$BUILD_DIR" "$TOMCAT_WEBAPPS/$APP_NAME"

echo "[5/5] Restarting Tomcat..."

if command -v brew &>/dev/null && brew list tomcat@9 &>/dev/null 2>&1; then
    brew services restart tomcat@9
else
    echo "  Manual Tomcat detected — restart it yourself:"
    echo "  Stop:  $TOMCAT_HOME/bin/shutdown.sh"
    echo "  Start: $TOMCAT_HOME/bin/startup.sh"
    if [ -f "$TOMCAT_HOME/bin/shutdown.sh" ]; then
        "$TOMCAT_HOME/bin/shutdown.sh" 2>/dev/null || true
        sleep 2
        "$TOMCAT_HOME/bin/startup.sh"
    fi
fi

echo ""
echo "=== Deployed ==="
echo "Site:  http://localhost:8080/$APP_NAME"
echo "Admin: http://localhost:8080/$APP_NAME/admin/login.jsp"
