# Etapa 1: build
FROM eclipse-temurin:21-alpine AS build
WORKDIR /app
COPY . .

# Agregar permisos de ejecución al wrapper de Maven
RUN chmod +x mvnw

RUN ./mvnw clean package -DskipTests

# Etapa 2: runtime
FROM eclipse-temurin:21-alpine
WORKDIR /app

# Crear un usuario no root y usarlo
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --from=build /app/target/*.jar app.jar
EXPOSE 8087
ENTRYPOINT ["java", "-jar", "app.jar"]
