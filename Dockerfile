FROM debian:bullseye
LABEL maintainer="Razvan Crainea <razvan@opensips.org>"

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG OPENSIPS_VERSION=3.2
ARG OPENSIPS_BUILD=releases

#install basic components
RUN apt-get -y update -qq && apt-get -y install gnupg2 ca-certificates

#add keyserver, repository
RUN apt-key adv --fetch-keys https://apt.opensips.org/pubkey.gpg
RUN echo "deb https://apt.opensips.org bullseye ${OPENSIPS_VERSION}-${OPENSIPS_BUILD}" >/etc/apt/sources.list.d/opensips.list

RUN apt-get -y update -qq && apt-get -y install opensips

ARG OPENSIPS_CLI=false
RUN if [ ${OPENSIPS_CLI} = true ]; then \
    echo "deb https://apt.opensips.org bullseye cli-nightly" >/etc/apt/sources.list.d/opensips-cli.list \
    && apt-get -y update -qq && apt-get -y install opensips-cli \
    ;fi

ARG OPENSIPS_EXTRA_MODULES
RUN if [ -n "${OPENSIPS_EXTRA_MODULES}" ]; then \
    apt-get -y install ${OPENSIPS_EXTRA_MODULES} \
    ;fi

RUN apt-get -y install libpq-dev python3-pip vim sngrep iputils-ping net-tools
RUN pip install --no-cache-dir psycopg2

RUN cp -r /usr/share/opensips/postgres /usr/share/opensips/postgresql

RUN rm -rf /var/lib/apt/lists/*
RUN sed -i "s/stderror_enabled=no/stderror_enabled=yes/g" /etc/opensips/opensips.cfg && \
    sed -i "s/syslog_enabled=yes/syslog_enabled=no/g" /etc/opensips/opensips.cfg && \
    sed -i "s/log_stderror=no/log_stderror=yes/g" /etc/opensips/opensips.cfg && \
    sed -i "s/127\.0\.0\.1/0\.0\.0\.0/g" /etc/opensips/opensips.cfg

EXPOSE 5060/udp

ENTRYPOINT ["/usr/sbin/opensips", "-f", "/etc/opensips/opensips.cfg", "-FE"]
