# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and download the project dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code into the container
COPY src ./src

# Package the application
RUN mvn clean package

# Stage 2: Run the application
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/helloworld-0.0.1-SNAPSHOT.jar /app/helloworld.jar

# Expose the new port
EXPOSE 9090

# Command to run the application
ENTRYPOINT ["java", "-jar", "/app/helloworld.jar"]