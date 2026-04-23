# CyberNova Analytics Build Script for Windows
# Run from PowerShell: .\build.ps1
# Prerequisites:
#   - Java 17 (https://adoptium.net)
#   - Apache Tomcat 11 extracted to C:\tomcat11
#   - javac on your PATH

param(
    [string]$TomcatHome = "C:\tomcat11"
)

$ProjectDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$SrcJava     = "$ProjectDir\src\main\java"
$SrcRes      = "$ProjectDir\src\main\resources"
$WebappDir   = "$ProjectDir\src\main\webapp"
$BuildDir    = "$ProjectDir\build"
$LibDir      = "$ProjectDir\lib"
$AppName     = "CyberNova"

if (-not (Test-Path "$TomcatHome\lib")) {
    Write-Host "Tomcat 11 not found at $TomcatHome" -ForegroundColor Red
    Write-Host "Download from https://tomcat.apache.org/download-11.cgi and extract to C:\tomcat11"
    exit 1
}

if (-not (Test-Path "$SrcRes\db.properties")) {
    Write-Host "db.properties not found. Copy the example and fill in your credentials:" -ForegroundColor Red
    Write-Host "  copy src\main\resources\db.properties.example src\main\resources\db.properties"
    exit 1
}

Write-Host "=== CyberNova Analytics Build (Windows) ===" -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path "$BuildDir\WEB-INF\classes" | Out-Null
New-Item -ItemType Directory -Force -Path "$BuildDir\WEB-INF\lib"     | Out-Null
New-Item -ItemType Directory -Force -Path $LibDir                      | Out-Null

Write-Host "[1/5] Checking dependencies..."

function Download-Jar($dest, $url) {
    if (-not (Test-Path $dest)) {
        Write-Host "  Downloading $(Split-Path -Leaf $dest)..."
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    }
}

Download-Jar "$LibDir\postgresql-42.7.3.jar" `
    "https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar"

Download-Jar "$LibDir\jakarta.servlet.jsp.jstl-3.0.1.jar" `
    "https://repo1.maven.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/3.0.1/jakarta.servlet.jsp.jstl-3.0.1.jar"

Write-Host "[2/5] Compiling Java sources..."

$tomcatJars = (Get-ChildItem "$TomcatHome\lib\*.jar").FullName
$libJars    = (Get-ChildItem "$LibDir\*.jar").FullName
$classpath  = ($tomcatJars + $libJars) -join ";"

$sources = Get-ChildItem -Recurse -Filter "*.java" $SrcJava | Select-Object -ExpandProperty FullName
$sources | Out-File -Encoding ASCII "$env:TEMP\cybernova_sources.txt"

javac -cp $classpath -d "$BuildDir\WEB-INF\classes" `@"$env:TEMP\cybernova_sources.txt"

if ($LASTEXITCODE -ne 0) {
    Write-Host "BUILD FAILED" -ForegroundColor Red
    exit 1
}

Write-Host "[3/5] Assembling application..."

Copy-Item -Recurse -Force "$WebappDir\*" "$BuildDir\"
Copy-Item -Force "$SrcRes\*" "$BuildDir\WEB-INF\classes\" -ErrorAction SilentlyContinue
Copy-Item -Force "$LibDir\*.jar" "$BuildDir\WEB-INF\lib\"

Write-Host "[4/5] Deploying to Tomcat..."

$deployPath = "$TomcatHome\webapps\$AppName"
if (Test-Path $deployPath) { Remove-Item -Recurse -Force $deployPath }
Copy-Item -Recurse -Force $BuildDir $deployPath

Write-Host "[5/5] Starting Tomcat..."
Write-Host "  Stop:  $TomcatHome\bin\shutdown.bat"
Write-Host "  Start: $TomcatHome\bin\startup.bat"

& "$TomcatHome\bin\startup.bat"

Write-Host ""
Write-Host "=== Deployed ===" -ForegroundColor Green
Write-Host "Site:  http://localhost:8080/$AppName"
Write-Host "Admin: http://localhost:8080/$AppName/admin/login.jsp"
