FROM shakataganai/nginx-accessfabric:latest
LABEL MAINTAINER "Jon 'ShakataGaNai' Davis"
VOLUME /etc/letsencrypt
EXPOSE 443

# Do this apt/pip stuff all in one RUN command to avoid creating large
# intermediate layers on non-squashable docker installs
RUN installpkg python python-dev libffi6 libffi-dev libssl-dev curl build-essential && \
    curl -L 'https://bootstrap.pypa.io/get-pip.py' | python && \
    pip install -U cffi certbot && \
    apt remove --purge -y python-dev build-essential libffi-dev libssl-dev curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy in scripts for certbot
COPY ./scripts/ /scripts
RUN chmod +x /scripts/*.sh

# Add /scripts/startup directory to source more startup scripts
RUN mkdir -p /scripts/startup

COPY nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT []
CMD ["/bin/bash", "/scripts/entrypoint.sh"]
