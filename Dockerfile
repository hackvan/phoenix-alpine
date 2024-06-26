FROM alpine:3.12
LABEL maintainer="Erick Reyna <erickueen@resuelve.mx>"

ARG DEBIAN_FRONTEND=noninteractive

ENV ERLANG_VERSION=25.3.2.12
ENV ELIXIR_VERSION=1.14.5-otp-25
ENV PHOENIX_VERSION=1.5.14

RUN \
    apk add --no-cache --update \
    bash \
    ca-certificates \
    openssl-dev \
    ncurses-dev \
    unixodbc-dev \
    zlib-dev curl gcc \
    make automake \
    autoconf gnupg nodejs npm \
    inotify-tools
RUN \
    apk add --no-cache \
    dpkg-dev \
    dpkg \
    binutils \
    git \
    autoconf \
    build-base \
    perl-dev
RUN apk --no-cache add -U musl musl-dev ncurses-libs libssl1.1 libressl3.1-libcrypto bash \
    qt5-qtwebkit qt5-qtbase-x11 qt5-qtsvg qt5-qtdeclarative qt5-qtsvg qt5-qtbase
RUN apk add --update-cache \
    xvfb \
    dbus \
    ttf-freefont \
    fontconfig wkhtmltopdf

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN touch ~/.bashrc
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf

ENV KERL_CONFIGURE_OPTIONS --disable-silent-rules \
    --without-javac \
    --enable-shared-zlib \
    --enable-dynamic-ssl-lib \
    --enable-hipe \
    --disable-sctp \
    --enable-smp-support \
    --enable-threads \
    --enable-kernel-poll \
    --enable-wx \
    --disable-debug \
    --enable-darwin-64bit

RUN cd ~/.asdf && git checkout "$(git describe --abbrev=0 --tags)"

ENV PATH /root/.asdf/bin:/root/.asdf/shims:${PATH}

RUN /bin/bash -c "source ~/.bashrc"
RUN /bin/bash -c "asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git"
RUN /bin/bash -c "asdf install erlang $ERLANG_VERSION"
RUN /bin/bash -c "asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git"
RUN /bin/bash -c "asdf global erlang $ERLANG_VERSION"
RUN /bin/bash -c "asdf install elixir $ELIXIR_VERSION"
RUN /bin/bash -c "asdf global elixir $ELIXIR_VERSION"
RUN /bin/bash -c "rm -rf ~/.asdf/installs/elixir/$ELIXIR_VERSION/lib/mix/tmp/"
RUN /bin/bash -c "mix local.hex --force"
RUN /bin/bash -c "mix local.rebar --force"
