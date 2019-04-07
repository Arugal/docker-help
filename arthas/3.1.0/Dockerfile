FROM hengyunabc/arthas:3.1.0

ARG tini_version=v0.18.0

ADD https://github.com/krallin/tini/releases/download/${tini_version}/tini-static /usr/bin/tini
RUN chmod +x /usr/bin/tini

ENTRYPOINT [ "/usr/bin/tini", "--"]