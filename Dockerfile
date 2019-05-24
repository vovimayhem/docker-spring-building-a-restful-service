# Stage I: "development" Stage =================================================

# In this stage, we'll set up the required development dependencies, including
# Gradle and other packages required during our development process:

# Step 1: Build on top of the "Java Server JRE" image:
FROM store/oracle/serverjre:8 AS development

# Step 2: Set the /usr/src directory as the WORKING_DIR:
WORKDIR /usr/src

# Step 3: Set the /usr/src directory as HOME: (So shell history is saved within
# our project)
ENV HOME=/usr/src

# Step 4: Install unzip:
RUN yum install -y unzip

# Step 5: Configure the Gradle version and the Gradle User Home:
ENV GRADLE_VERSION=5.4.1 GRADLE_USER_HOME=/usr/local/gradle

# Step 6: Add gradle executables to PATH:
ENV PATH=/opt/gradle/gradle-$GRADLE_VERSION/bin:$PATH

# Step 7: Install the configured Gradle version:
RUN curl -L -o "gradle-${GRADLE_VERSION}-bin.zip" \
  "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
 mkdir -p /opt/gradle /usr/local/gradle && \
 unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip

# Step 8: Set the default command for this image:
CMD ["gradle", "bootRun"]

# Stage II: "builder" Stage ====================================================

# In this stage we'll compile the app into bytecode:

# Step 9: Build on top of the "development" stage image:
FROM development AS builder

# Step 10: Set the `/usr` directory as the WORKING_DIR:
WORKDIR /usr

# Step 11: Copy the `build.gradle` file:
COPY build.gradle /usr/

# Step 12: Copy the source code:
COPY src /usr/src

# Step 13: Build the application:
RUN gradle build

# Stage III: "release" Stage ===================================================

# In this stage we'll complete the final, release image

# Step 14: Build on top of the "Java Server JRE" image:
FROM store/oracle/serverjre:8 AS release

# Step 15: Copy the compiled JAR file into `/` from the "builder" stage image:
COPY --from=builder /usr/build/libs/spring-building-a-restful-service-0.1.0.jar .

# Step 16: Set the default command for the image:
CMD ["java", "-jar", "spring-building-a-restful-service-0.1.0.jar"]
