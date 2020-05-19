FROM golang:alpine

WORKDIR /

# Variables
ARG CLOUD_SDK_VERSION=262.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

ENV PATH /google-cloud-sdk/bin:$PATH

# Tools
RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg \
        gcc \
        g++ \
        openjdk8-jre

# gcloud
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud config set project test && \
    gcloud --version

# Additional gcloud
RUN gcloud components install app-engine-go beta

# Go packages
RUN go get -v golang.org/x/lint/golint && \
    go get -v cloud.google.com/go/datastore && \
    go get -v cloud.google.com/go/logging && \
    go get -v gitlab.com/ccode-ab/cgo/... && \
    go get -v golang.org/x/crypto/... && \
    go get -v github.com/sideshow/apns2

WORKDIR $GOPATH

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
