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

# Step 5: Configure the Maven version and the Maven User Home:
ARG MAVEN_VERSION=3.6.1
ARG MAVEN_SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

# Step 6: Configure Maven
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "/usr/local/m2"

# Step 7: Install the configured maven version:
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# STep X: Copy the POM file:
COPY pom.xml /usr/src/

# Step X+1: Download dependencies:
RUN mvn dependency:go-offline

# Step 8: Set the default command for this image:
CMD ["mvn", "spring-boot:run"]

# Stage II: "builder" Stage ====================================================

# In this stage we'll compile the app into bytecode:

# Step 9: Build on top of the "development" stage image:
FROM development AS builder

# Step 10: Copy the source code:
COPY . /usr/src/

# Step 13: Build the application:
RUN mvn package

# Stage III: "release" Stage ===================================================

# In this stage we'll complete the final, release image

# Step 14: Build on top of the "Java Server JRE" image:
FROM store/oracle/serverjre:8 AS release

# Step 15: Copy the compiled JAR file into `/` from the "builder" stage image:
COPY --from=builder /usr/src/target/gs-rest-service-0.1.0.jar .

# Step 16: Set the default command for the image:
CMD ["java", "-jar", "gs-rest-service-0.1.0.jar"]
