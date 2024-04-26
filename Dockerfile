ARG KC_VERSION=23.0.7

FROM maven:3-eclipse-temurin-17 AS daps-ext-builder
ARG KC_VERSION

WORKDIR /home/app
COPY . ./
RUN --mount=type=cache,target=/root/.m2 mvn -D "version.keycloak=${KC_VERSION}" clean package

FROM quay.io/keycloak/keycloak:${KC_VERSION}
COPY --from=daps-ext-builder /home/app/target/dat-extension.jar /opt/keycloak/providers/dat-extension.jar

# Theme Customization
COPY themes/ /opt/keycloak/themes/

CMD ["start"]
