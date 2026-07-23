FROM scratch AS ctx
COPY build_files /

FROM  quay.io/fedora/fedora-bootc:44

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh
COPY system_files /
RUN mkdir -p /var/lib/greetd && chown greetd:greetd /var/lib/greetd
RUN bootc container lint
