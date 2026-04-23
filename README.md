# CyberNova Analytics

A Java/JSP web application for CyberNova Analytics — a cybersecurity services company. The platform handles service request submissions, webinar registration, client testimonials, and a full admin panel for managing requests, webinars, and analytics.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Web Container | Apache Tomcat 9 |
| Database | PostgreSQL via Supabase |
| JDBC Driver | PostgreSQL 42.7.3 |
| View Layer | JSP + JSTL 1.2.5 |
| Icons | Font Awesome 6.5.1 (CDN) |
| Charts | Chart.js 4.4.4 (CDN) |
| Auth | Session-based with SHA-256 password hashing |

---

## Project Structure

```
CyberNova/
├── build.sh                          # One-command build and deploy script
├── build/                            # Compiled output (generated, not committed)
├── database/
│   └── schema.sql                    # Reference SQL schema (not auto-applied)
├── lib/                              # Third-party JARs
│   ├── postgresql-42.7.3.jar
│   ├── taglibs-standard-spec-1.2.5.jar
│   ├── taglibs-standard-impl-1.2.5.jar
│   └── h2-2.2.224.jar                # Unused (kept as leftover from early dev)
└── src/
    └── main/
        ├── java/com/cybernova/
        │   ├── dao/                  # Data access objects
        │   ├── filter/               # Servlet filters (auth)
        │   ├── listener/             # App lifecycle (DB init on startup)
        │   ├── model/                # Java model classes
        │   ├── servlet/              # HTTP servlet controllers
        │   └── util/                 # Utility classes (password hasher)
        ├── resources/
        │   └── db.properties         # Database connection config
        └── webapp/
            ├── WEB-INF/
            │   └── web.xml           # Servlet 4.0 app descriptor
            ├── css/                  # Stylesheets
            ├── js/                   # JavaScript
            ├── includes/             # Shared header/footer/nav JSP fragments
            ├── admin/                # Admin panel JSPs and includes
            └── *.jsp                 # Public-facing pages
```

---

## Database

### Connection

The app connects to a Supabase-hosted PostgreSQL database. Because the Supabase direct database host is IPv6-only, the **session-mode connection pooler** is used instead, which has full IPv4 support.

Config file: `src/main/resources/db.properties` (gitignored — never committed)

```properties
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://<aws-pooler-host>:5432/postgres
db.user=postgres.<your-project-ref>
db.password=<your-supabase-password>
```

> The username format for the pooler is `postgres.<project-ref>`, not just `postgres`. See **Credentials Setup** below for how to create this file after cloning.

### Schema

Tables are created automatically on startup by `DatabaseInitializer.java` using `CREATE TABLE IF NOT EXISTS`. The `database/schema.sql` file is a reference copy only — it is not applied automatically.

#### service_request

Stores all client service enquiries submitted via the public form.

```sql
CREATE TABLE IF NOT EXISTS service_request (
    request_id       SERIAL PRIMARY KEY,
    full_name        VARCHAR(100) NOT NULL,
    email            VARCHAR(150) NOT NULL,
    phone_number     VARCHAR(20),
    organisation_name VARCHAR(150),
    country          VARCHAR(100) NOT NULL,
    job_title        VARCHAR(100),
    industry_sector  VARCHAR(100),
    service_type     VARCHAR(100) NOT NULL,
    description      TEXT NOT NULL,
    status           VARCHAR(20) DEFAULT 'pending',
    submission_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Status values: `pending`, `in-progress`, `resolved`

#### admin

Holds admin login credentials. Password is stored as a SHA-256 hash.

```sql
CREATE TABLE IF NOT EXISTS admin (
    admin_id      SERIAL PRIMARY KEY,
    username      VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(256) NOT NULL
);
```

Default credentials seeded on first startup: `admin` / `admin123`

#### rating

Client testimonials/ratings, optionally linked to a service request.

```sql
CREATE TABLE IF NOT EXISTS rating (
    rating_id    SERIAL PRIMARY KEY,
    request_id   INT REFERENCES service_request(request_id) ON DELETE SET NULL,
    customer_name VARCHAR(100) NOT NULL,
    rating_value  INT NOT NULL CHECK (rating_value >= 1 AND rating_value <= 5),
    comment       TEXT,
    created_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### webinar

Upcoming and past webinars created by the admin.

```sql
CREATE TABLE IF NOT EXISTS webinar (
    webinar_id   SERIAL PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    description  TEXT,
    webinar_date DATE NOT NULL,
    webinar_time VARCHAR(20) NOT NULL,
    platform     VARCHAR(20) DEFAULT 'Online',
    speaker      VARCHAR(150),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### webinar_registration

Public registrations for webinars. Duplicate registrations (same email + webinar) are blocked at the application level.

```sql
CREATE TABLE IF NOT EXISTS webinar_registration (
    registration_id  SERIAL PRIMARY KEY,
    webinar_id       INT NOT NULL REFERENCES webinar(webinar_id) ON DELETE CASCADE,
    full_name        VARCHAR(100) NOT NULL,
    email            VARCHAR(150) NOT NULL,
    organisation     VARCHAR(150),
    phone            VARCHAR(20),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Seed Data

On first startup, `DatabaseInitializer` checks if each table is empty and seeds it automatically:

- **service_request** — 20 sample requests from African and international clients across various service types and statuses
- **rating** — 8 client testimonials with star ratings
- **webinar** — 4 upcoming webinars with dates, speakers, and platforms
- **admin** — default admin account (`admin` / `admin123`)

---

## Credentials Setup

`src/main/resources/db.properties` is gitignored and must be created manually after cloning. A template is provided:

```bash
cp src/main/resources/db.properties.example src/main/resources/db.properties
```

Then open `db.properties` and fill in your Supabase credentials:

```properties
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://<aws-pooler-host>:5432/postgres
db.user=postgres.<your-project-ref>
db.password=<your-supabase-password>
```

Get your pooler hostname and project ref from **Supabase → Project Settings → Database → Connection Pooling → Session Mode**.

---

## Build & Deploy

### Linux

`build.sh` handles everything:

```bash
chmod +x build.sh   # only needed once
./build.sh
```

Prerequisites: Java 17, Apache Tomcat 9 installed as a systemd service (`tomcat9`), `sudo` access.

What it does:

1. Downloads missing JARs into `lib/`
2. Compiles all Java sources against Tomcat's servlet API
3. Assembles JSPs, CSS, JS, and `db.properties` into `build/`
4. Deploys to `/var/lib/tomcat9/webapps/CyberNova` and fixes ownership
5. Restarts Tomcat via `sudo systemctl restart tomcat9`

---

### macOS

**Install Java 17**

```bash
brew install openjdk@17
```

Or download the installer from [adoptium.net](https://adoptium.net).

---

**Install Tomcat 9 — pick one method:**

**Option A — Homebrew** (easiest, managed via `brew services`)

```bash
brew install tomcat@9
```

Installs to:
- Apple Silicon: `/opt/homebrew/opt/tomcat@9/libexec`
- Intel: `/usr/local/opt/tomcat@9/libexec`

Start/stop: `brew services start tomcat@9` / `brew services stop tomcat@9`

**Option B — Manual zip** (required for IntelliJ, also works standalone)

1. Download the **Core** `.tar.gz` from [tomcat.apache.org/download-90.cgi](https://tomcat.apache.org/download-90.cgi)
2. Extract it wherever you like, e.g.:

```bash
tar -xzf apache-tomcat-9.0.*.tar.gz -C ~/
mv ~/apache-tomcat-9.0.* ~/tomcat9
```

Start/stop manually:
```bash
~/tomcat9/bin/startup.sh
~/tomcat9/bin/shutdown.sh
```

---

**Build and deploy (terminal)**

`build-mac.sh` auto-detects your Tomcat installation — it checks for Homebrew first, then falls back to common manual locations (`~/tomcat9`, `/opt/tomcat9`, etc.). No `sudo` required.

```bash
chmod +x build-mac.sh   # only needed once
./build-mac.sh
```

If Tomcat is in a non-standard location, set `TOMCAT_HOME` explicitly:

```bash
TOMCAT_HOME=~/tomcat9 ./build-mac.sh
```

---

**Using IntelliJ IDEA instead of the build script**

IntelliJ handles compilation and deployment itself — you don't need `build-mac.sh` at all if you're working from the IDE.

1. **Download and extract Tomcat 9** using Option B above (IntelliJ needs a local directory)
2. **Open the project** in IntelliJ (`File → Open` → select the `CyberNova` folder)
3. **Set the Project SDK**: `File → Project Structure → Project → SDK` → select Java 17
4. **Add a Tomcat run configuration**:
   - `Run → Edit Configurations → + → Tomcat Server → Local`
   - **Application server** → click `Configure` → set the path to your extracted Tomcat (`~/tomcat9`)
   - Switch to the **Deployment** tab → `+ → Artifact → CyberNova:war exploded`
   - Set **Application context** to `/CyberNova`
5. **Mark source root**: right-click `src/main/java` → `Mark Directory as → Sources Root`
6. **Add JARs to the module classpath**: `File → Project Structure → Modules → Dependencies → +` → add all JARs from `lib/` and Tomcat's `lib/` (IntelliJ needs them to compile)
7. Click **Run** — IntelliJ compiles, deploys, and opens the browser

The app will be at `http://localhost:8080/CyberNova/`.

> `db.properties` is gitignored. Copy the example file before running:
> ```bash
> cp src/main/resources/db.properties.example src/main/resources/db.properties
> ```
> Then fill in your Supabase credentials. IntelliJ will include it automatically when building the exploded WAR.

---

### Windows

**Option A — Docker (recommended, no Tomcat install needed)**

Install [Docker Desktop](https://www.docker.com/products/docker-desktop/), then:

```powershell
docker build -t cybernova-analytics .

docker run -p 8080:8080 `
  -e DB_URL="jdbc:postgresql://<pooler-host>:5432/postgres" `
  -e DB_USER="postgres.<your-project-ref>" `
  -e DB_PASSWORD="<your-password>" `
  cybernova-analytics
```

Open `http://localhost:8080/`.

**Option B — Native (PowerShell + Tomcat)**

1. Install [Java 17](https://adoptium.net)
2. Download [Apache Tomcat 9](https://tomcat.apache.org/download-90.cgi) and extract to `C:\tomcat9`
3. Make sure `javac` is on your PATH
4. Open PowerShell and run:

```powershell
# Allow local script execution if not already enabled
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

.\build.ps1
```

Tomcat starts automatically. Stop it with `C:\tomcat9\bin\shutdown.bat`.

To use a non-default Tomcat path:

```powershell
.\build.ps1 -TomcatHome "D:\servers\tomcat9"
```

---

### Using build.sh — step-by-step detail (Linux reference)

### Manual build (Linux alternative)

```bash
# 1. Compile
CLASSPATH="/usr/share/tomcat9/lib/servlet-api.jar:/usr/share/tomcat9/lib/jsp-api.jar:lib/postgresql-42.7.3.jar:lib/taglibs-standard-spec-1.2.5.jar:lib/taglibs-standard-impl-1.2.5.jar"
find src/main/java -name "*.java" | xargs javac -cp "$CLASSPATH" -d build/WEB-INF/classes

# 2. Assemble
cp -r src/main/webapp/* build/
cp src/main/resources/* build/WEB-INF/classes/
cp lib/*.jar build/WEB-INF/lib/

# 3. Deploy
sudo rm -rf /var/lib/tomcat9/webapps/CyberNova
sudo cp -r build /var/lib/tomcat9/webapps/CyberNova
sudo chown -R tomcat9:tomcat9 /var/lib/tomcat9/webapps/CyberNova
sudo systemctl restart tomcat9
```

---

## Running Locally

Prerequisites (all platforms):

- Java 17 (`java --version`)
- `db.properties` configured (see **Credentials Setup** above)
- Network access to the Supabase pooler
- Platform-specific: see **Build & Deploy** above

After deploying:

| URL | Description |
|---|---|
| `http://localhost:8080/CyberNova/` | Public homepage |
| `http://localhost:8080/CyberNova/webinars` | Webinar listings |
| `http://localhost:8080/CyberNova/admin/login.jsp` | Admin login |
| `http://localhost:8080/CyberNova/admin/dashboard` | Admin dashboard |

---

## Application Routes

### Public

| Method | URL | Servlet | Description |
|---|---|---|---|
| GET | `/` | `HomeServlet` | Homepage |
| GET | `/webinars` | `WebinarsServlet` | Webinar listings from DB |
| GET/POST | `/webinar-register` | `WebinarRegisterServlet` | Webinar registration form |
| GET/POST | `/request` | `SubmitRequestServlet` | Service request form |
| GET | `/testimonials` | `TestimonialsServlet` | Client testimonials |
| GET | `/analytics` | `AnalyticsServlet` | Public analytics page |

Static JSPs (no servlet): `about.jsp`, `services.jsp`, `blog.jsp`, `contact.jsp`, `case-studies.jsp`, `resources.jsp`, `gallery.jsp`

### Admin (requires login session)

| Method | URL | Servlet | Description |
|---|---|---|---|
| GET/POST | `/admin/login.jsp` | `AdminLoginServlet` | Login |
| GET | `/admin/logout` | `AdminLogoutServlet` | Logout |
| GET | `/admin/dashboard` | `AdminDashboardServlet` | Dashboard with stats |
| GET/POST | `/admin/requests` | `AdminRequestsServlet` | View and manage service requests |
| GET | `/admin/request-detail` | `RequestDetailServlet` | Single request + update status |
| GET/POST | `/admin/webinars` | `AdminWebinarsServlet` | Create/delete webinars, view registrants |
| POST | `/admin/update-request` | `UpdateRequestServlet` | Update request status |
| POST | `/admin/delete-request` | `DeleteRequestServlet` | Delete a request |

All `/admin/*` routes (except login) are protected by `AuthenticationFilter`.

---

## Admin Panel

Login at `/admin/login.jsp` with:

- **Username**: `admin`
- **Password**: `admin123`

Change the default password after first deployment by updating the `admin` table directly in Supabase or by adding a change-password flow.

---

## Known Notes

- `lib/h2-2.2.224.jar` is left over from the original H2 local database setup. It is bundled into the app but never used. It can be safely deleted from `lib/` and removed from the deploy steps.
- `database/schema.sql` is a reference document only. The live schema is managed by `DatabaseInitializer.java` using `CREATE TABLE IF NOT EXISTS` on every app startup.
- The app uses annotation-based servlet registration (`@WebServlet`). `web.xml` only declares the app metadata and display name — no servlet mappings are defined there.

---

## Docker

The app ships with a multi-stage Dockerfile. Stage 1 compiles the Java source using the Tomcat base image (which includes the servlet API). Stage 2 runs the compiled app as Tomcat's ROOT webapp.

### Build the image

```bash
docker build -t cybernova-analytics .
```

### Run locally with Docker

```bash
docker run -p 8080:8080 \
  -e DB_URL="jdbc:postgresql://<pooler-host>:5432/postgres" \
  -e DB_USER="postgres.<your-project-ref>" \
  -e DB_PASSWORD="<your-password>" \
  cybernova-analytics
```

Then open `http://localhost:8080/`.

The `docker-entrypoint.sh` script reads the `PORT` environment variable (set automatically by Render) and patches Tomcat's `server.xml` before startup so the container listens on the correct port.

---

## Render Deployment

The project includes a `render.yaml` that configures the service automatically when connected to a Git repository.

### Steps

1. Push the repository to GitHub (or GitLab).
2. Log in to [render.com](https://render.com) and create a new **Web Service**.
3. Connect your repository. Render will detect the `Dockerfile` automatically.
4. In the Render dashboard under **Environment**, set:
   - `DB_URL` → your Supabase session-mode pooler JDBC URL
   - `DB_USER` → `postgres.<your-project-ref>`
   - `DB_PASSWORD` → your Supabase password *(add as a **Secret** so it is masked in logs)*
5. Deploy. On first startup, `DatabaseInitializer` will create all tables and seed data in Supabase.

### Why environment variables instead of db.properties?

`DatabaseConnection.java` checks `DB_URL`, `DB_USER`, `DB_PASSWORD` environment variables first, and only falls back to `db.properties` if they are not set. This means:
- Locally: uses `db.properties` (no extra setup needed)
- On Render: uses the environment variables you set in the dashboard (credentials never hardcoded in the image)

> Set `DB_PASSWORD` as a **Secret** in Render so it is not visible in deployment logs.

