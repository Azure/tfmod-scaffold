FROM localhost:5000/builder:latest as build

#FROM mcr.microsoft.com/azurelinux/base/python:3.12 as runner
FROM mcr.microsoft.com/azure-cli:cbl-mariner2.0 as runner
ARG GOLANG_IMAGE_TAG=1.19
ARG TERRAFORM_VERSION=1.3.3
ARG TARGETARCH
ARG HOME_DIR=/home/runtimeuser
ARG PACKER_VERSION=1.9.4
ARG TFLINT_VERSION=v0.41.0
ENV AVM_MOD_PATH=/src
ENV AVM_IN_CONTAINER=1
ENV GOPATH=${HOME_DIR}/go
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:${HOME_DIR}/tfenv/bin:${HOME_DIR}/pkenv/bin:$GOROOT/bin:$GOPATH/bin
ENV TF_CLI_CONFIG_FILE=${HOME_DIR}/.terraformrc
ENV TFENV_AUTO_INSTALL=true
ENV TFENV_TERRAFORM_VERSION=$TERRAFORM_VERSION
ENV TFLINT_PLUGIN_DIR ${HOME_DIR}/tflint
ENV TFLINTENV_DEFAULT_VERSION=$TFLINT_VERSION
ENV TFLINTENV_HOME_DIR=${HOME_DIR}/tflintenv
# Update image, install and configure system-wide software
RUN tdnf update -y && \
    tdnf install -y ca-certificates zip unzip jq make git less diffutils build-essential openssh openssh-server wget moby-cli && \
    tdnf clean all && \
#    pip3 install cryptography -U && \ # Uncomment if we need to use azure-cli with python3
#    pip install azure-cli && \
    cd / && \
    wget -q https://go.dev/dl/go${GOLANG_IMAGE_TAG}.linux-${TARGETARCH}.tar.gz && \
    tar -C /usr/local -xzf go*.linux-${TARGETARCH}.tar.gz && \
    rm go${GOLANG_IMAGE_TAG}.linux-${TARGETARCH}.tar.gz && \
    git config --global user.email "tfmod442916@users.noreply.github.com" && \
    git config --global user.name "github-actions[bot]" && \
    git config --global --add safe.directory '*'
# Create home directory, copy over utilities for xyzenv, terraform cli config, and set permissions
RUN mkdir ${HOME_DIR}
COPY .terraformrc ${HOME_DIR}/.terraformrc
COPY --from=build /go/bin /usr/local/go/bin
COPY --from=build /src/tfenv ${HOME_DIR}/tfenv
COPY --from=build /src/pkenv ${HOME_DIR}/pkenv
RUN cp /root/.gitconfig ${HOME_DIR}/.gitconfig && \
    mkdir ${HOME_DIR}/tflintenv && \
    chmod -Rv a+rwX ${HOME_DIR} && \
    chmod 777 ${HOME_DIR}/tfenv/bin/* && \
    chmod 777 ${HOME_DIR}/pkenv/bin/* && \
    rm -r /tmp/*

ENV HOME=${HOME_DIR}
