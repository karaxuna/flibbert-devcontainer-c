# Base build image
FROM --platform=linux/amd64 ubuntu:22.04

# Install inotify-tools for inotifywait
RUN apt-get update && apt-get install -y inotify-tools curl

# Install WASI SDK for compiling C/C++ to WebAssembly
ARG WASI_SDK_VERSION=20
ARG WASI_SDK_URL=https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VERSION}/wasi-sdk-${WASI_SDK_VERSION}.0-linux.tar.gz
RUN curl -sL "$WASI_SDK_URL" | tar -xzf - -C /opt
ENV WASI_SDK_PATH="/opt/wasi-sdk-${WASI_SDK_VERSION}.0"
ENV PATH="${WASI_SDK_PATH}/bin:${PATH}"

# Set up the working directory
WORKDIR /usr/src/app

# Copy files
COPY sync-watch.sh /usr/local/bin/sync-watch.sh
RUN chmod a+x /usr/local/bin/sync-watch.sh
COPY ./src src/
