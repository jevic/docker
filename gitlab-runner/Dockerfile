FROM gitlab/gitlab-runner:v11.1.1
RUN apt-get -y update \
    && apt-get install -y sudo \
    && curl -O https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz  \
    && tar zxvf docker-latest.tgz \
    && cp docker/docker /usr/local/bin/ \
    && rm -rf docker docker-latest.tgz  \
    && echo "gitlab-runner    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
