FROM tomcat:11.0-jdk17 AS builder

WORKDIR /build

RUN mkdir -p lib && \
    curl -fsSL -o lib/postgresql-42.7.3.jar \
        "https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar" && \
    curl -fsSL -o lib/jakarta.servlet.jsp.jstl-api-3.0.0.jar \
        "https://repo1.maven.org/maven2/jakarta/servlet/jsp/jstl/jakarta.servlet.jsp.jstl-api/3.0.0/jakarta.servlet.jsp.jstl-api-3.0.0.jar" && \
    curl -fsSL -o lib/jakarta.servlet.jsp.jstl-3.0.1.jar \
        "https://repo1.maven.org/maven2/org/glassfish/web/jakarta.servlet.jsp.jstl/3.0.1/jakarta.servlet.jsp.jstl-3.0.1.jar"

COPY src/ src/

RUN mkdir -p app/WEB-INF/classes app/WEB-INF/lib && \
    CLASSPATH=$(find /usr/local/tomcat/lib lib -name '*.jar' | tr '\n' ':' | sed 's/:$//') && \
    find src/main/java -name "*.java" > /tmp/sources.txt && \
    javac -cp "$CLASSPATH" -d app/WEB-INF/classes @/tmp/sources.txt && \
    cp -r src/main/webapp/* app/ && \
    echo "db.driver=org.postgresql.Driver" > app/WEB-INF/classes/db.properties && \
    cp lib/*.jar app/WEB-INF/lib/

FROM tomcat:11.0-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=builder /build/app /usr/local/tomcat/webapps/ROOT

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
