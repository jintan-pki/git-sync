FROM alpine

LABEL "repository"="http://github.com/wei/git-sync"
LABEL "homepage"="http://github.com/wei/git-sync"
LABEL "maintainer"="Wei He <github@weispot.com>"
LABEL org.opencontainers.image.source https://github.com/jintan-pki/git-sync

RUN apk add --no-cache git openssh-client && \
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ARG GITLFS_VERSION="3.2.0"
RUN apk --no-cache add openssl curl \
    && curl -sLO https://github.com/github/git-lfs/releases/download/v${GITLFS_VERSION}/git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz \
    && tar zxvf git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz \
    && mv git-lfs-${GITLFS_VERSION}/git-lfs /usr/bin/ \
    && rm -rf git-lfs-${GITLFS_VERSION} \
    && rm -rf git-lfs-linux-amd64-v${GITLFS_VERSION}.tar.gz \
    && git lfs install --skip-smudge
    && git config --global filter.lfs.smudge "git-lfs smudge --skip -- %f"
    && git config --global filter.lfs.process "git-lfs filter-process --skip"

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
