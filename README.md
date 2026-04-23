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

Config file: `src/main/resources/db.properties`

```properties
db.url=
db.user=postgres.xsgzgfrrulcnemkywxpi
db.password=
db.driver=org.postgresql.Driver
```

> The username format for the pooler is `postgres.<project-ref>`, not just `postgres`.

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

## Build & Deploy

### Using build.sh (recommended)

`build.sh` is the canonical way to build and deploy the app. It handles everything in one command:

```bash
chmod +x build.sh   # only needed once
./build.sh
```

What it does, step by step:

1. **Checks dependencies** — downloads `postgresql-42.7.3.jar`, `taglibs-standard-spec-1.2.5.jar`, and `taglibs-standard-impl-1.2.5.jar` into `lib/` if they are not already there
2. **Compiles Java sources** — runs `javac` against all `.java` files in `src/main/java/` using Tomcat's servlet API and the project JARs as the classpath; outputs `.class` files to `build/WEB-INF/classes/`
3. **Assembles the app** — copies JSP/CSS/JS from `src/main/webapp/`, copies `db.properties` from `src/main/resources/`, and copies all JARs from `lib/` into `build/WEB-INF/lib/`
4. **Deploys to Tomcat** — removes the old deployed app at `/var/lib/tomcat9/webapps/CyberNova`, copies the fresh `build/` directory there, and fixes ownership to `tomcat9:tomcat9`
5. **Restarts Tomcat** — runs `sudo systemctl restart tomcat9`

Requires `sudo` access for the deploy and restart steps.

### Manual build (alternative)

If you want to run steps individually:

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

Prerequisites:

- Java 17 (`java --version`)
- Apache Tomcat 9 installed as a systemd service (`tomcat9`)
- `sudo` access for deploy steps
- Network access to the Supabase pooler (`aws-0-eu-west-1.pooler.supabase.com:5432`)

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
  -e DB_URL="jdbc:postgresql://aws-0-eu-west-1.pooler.supabase.com:5432/postgres" \
  -e DB_USER="postgres.xsgzgfrrulcnemkywxpi" \
  -e DB_PASSWORD="your-password" \
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
   - `DB_URL` → `jdbc:postgresql://aws-0-eu-west-1.pooler.supabase.com:5432/postgres`
   - `DB_USER` → `postgres.xsgzgfrrulcnemkywxpi`
   - `DB_PASSWORD` → *(your Supabase password — set as a secret)*
5. Deploy. On first startup, `DatabaseInitializer` will create all tables and seed data in Supabase.

### Why environment variables instead of db.properties?

`DatabaseConnection.java` checks `DB_URL`, `DB_USER`, `DB_PASSWORD` environment variables first, and only falls back to `db.properties` if they are not set. This means:
- Locally: uses `db.properties` (no extra setup needed)
- On Render: uses the environment variables you set in the dashboard (credentials never hardcoded in the image)

> Set `DB_PASSWORD` as a **Secret** in Render so it is not visible in deployment logs.

