# Etapa 1: Build de la app
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY . .
RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# Etapa 2: Preparar archivos necesarios
FROM eclipse-temurin:21-jdk-alpine AS prepare
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -D appuser
RUN mkdir -p /opt/java/openjdk /lib /app/tmp && chmod -R 777 /app/tmp
RUN cp -r /usr/lib/jvm/* /opt/java/openjdk || true
RUN cp /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1 || true
RUN echo "appuser:x:1001:1001::/home/appuser:/bin/sh" > /etc/passwd && \
    echo "appgroup:x:1001:" > /etc/group

# Etapa 3: Imagen final desde scratch
FROM scratch
COPY --from=prepare /opt/java/openjdk /opt/java/openjdk
COPY --from=prepare /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=prepare /etc/passwd /etc/passwd
COPY --from=prepare /etc/group /etc/group
COPY --from=prepare /app/tmp /app/tmp
COPY --from=build /app/target/*.jar /app/app.jar

USER 1001
ENV PATH="/opt/java/openjdk/bin:${PATH}"
ENV JAVA_OPTS="-Djava.io.tmpdir=/app/tmp"
WORKDIR /app
EXPOSE 8087
ENTRYPOINT ["/opt/java/openjdk/bin/java", "-Djava.io.tmpdir=/app/tmp", "-jar", "/app/app.jar"]
