# Java 4 Docker: Spring Guide "Building a RESTful Web Service"

This project is my attempt at following the
["Building a RESTful Web Service"](https://spring.io/guides/gs/rest-service/)
guide at [spring.io](https://spring.io), but this time using Docker exclusively
for the development process :)

## Prerequisites

1. Have Docker & Docker Compose Installed
2. Clone the project
3. Move to the cloned project's folder

OH MY: This project uses the Oracle Java Server JRE, which requires you to
have a Docker account (which is free) and accept the Licence Agreement at [Oracle Java Server JRE Image](https://hub.docker.com/_/oracle-serverjre-8) (The "Proceed to Checkout" button over there - it's also free)

4. Ensuse your authenticated your docker CLI: `docker login`

## Run Demo

### Development mode

This runs the "development" image:

```
docker-compose run --service-ports web
```

Visit [localhost:8080](http://localhost:8080)


### Release mode

This runs the "release" image:

```
docker-compose run --service-ports web_release
```

Visit [localhost:8081](http://localhost:8081)
