# Use a stable base image
FROM ubuntu:22.04 

# Set non-interactive to avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Combine RUN commands to reduce layers and fix the 404 Maven URL
RUN apt update && apt install -y openjdk-21-jdk wget tar \
    && wget https://dlcdn.apache.org/maven/maven-3/3.9.12/binaries/apache-maven-3.9.12-bin.tar.gz \
    && tar -xvf apache-maven-3.9.12-bin.tar.gz \
    && mv apache-maven-3.9.12 /opt/maven \
    && rm apache-maven-3.9.12-bin.tar.gz \
    && apt-get clean

# Set Environment Variables
ENV M2_HOME=/opt/maven
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$M2_HOME/bin:$JAVA_HOME/bin:$PATH"

# Copy source code
COPY . .

# Build the application
RUN mvn clean package -DskipTests

EXPOSE 8080

# Start the application using Jetty
CMD ["mvn", "jetty:run"]
