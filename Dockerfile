ARG keycloak_image=quay.io/keycloak/keycloak:23.0.7

FROM ${keycloak_image} as builder

WORKDIR /opt/keycloak

ENV KC_HEALTH_ENABLED=true
ENV KC_DB=postgres

RUN /opt/keycloak/bin/kc.sh build

FROM ${keycloak_image}
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ADD ./keycloak-sms-authenticator.jar /opt/keycloak/providers/sms-auth.jar
ADD ./keycloak-theme /opt/keycloak/themes/wolpertinger
ADD ./realm-export.json /opt/keycloak/data/import/realm-export.json

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
