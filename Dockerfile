ARG BASH_VERSION

FROM bash:$BASH_VERSION

RUN apk update && apk add make git