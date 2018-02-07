FROM gitlab/gitlab-runner:v10.4.0
RUN curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz  \
    && tar zxvf docker-latest.tgz \
    && cp docker/docker /usr/local/bin/ \
    && rm -rf docker docker-latest.tgz  \
    && echo "gitlab-runner    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
