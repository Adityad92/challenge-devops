FROM alpine:3.14

WORKDIR /docs

RUN apk update --no-cache \
    && apk add --no-cache python2 py-pip \
    && pip install --no-cache-dir \
    mkdocs \
    pathlib \
    pygments \
    material \
    mkdocs-windmill \
    pymdown-extensions==6.0.0 \
    mkdocs-markdownextradata-plugin

EXPOSE 8000

# ENTRYPOINT [ "mkdocs" ]
# CMD ["serve", "-a", "0.0.0.0:8000"]