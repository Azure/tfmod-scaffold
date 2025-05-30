ARG GOLANG_IMAGE_TAG=1.20
FROM mcr.microsoft.com/oss/go/microsoft/golang:${GOLANG_IMAGE_TAG} as build
ARG TERRAFORM_DOCS_VERSION=v0.18.0
ARG TERRAGRUNT_VERSION=v0.43.0
ARG TFMOD_TEST_HELPER_VERSION=v0.0.22
ARG GOLANGCI_LINT_VERSION=v1.49.0
ARG HCLEDIT_VERSION=v0.2.6
ARG GOSEC_VERSION=v2.14.0
ARG TFENV=v3.0.0
ARG GREPT_VERSION=1a4f08c2fdc41b6a3702fa1238354c40a3fcce3e
ARG NEWRES_VERSION=a535fe92925845dfa033a3db71adf7d65511cbf3
ARG AVMFIX_VERSION=9c158444b055e845c0cc9afc7cdc88d0ab19e5eb
ARG HCLMERGE_VERSION=8735bef83162f3ee952213b16e89f8d0ac0d08f7
ARG PREVIOUS_TAG_VERSION=656b12a97270ca29998ad62e3564d08e7d4369ba
ARG CONFTEST_VERSION=v0.56.0
ARG MAPOTF_VERSION=34acfd616ae081a560286d06c42f1f8329cf5b74
ARG TARGETARCH
COPY GNUmakefile /src/GNUmakefile
COPY scripts /src/scripts
RUN cd /src && \
    apt-get update && \
    apt-get install -y zip  && \
    export CGO_ENABLED=0 && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install mvdan.cc/gofumpt@latest && \
    go install github.com/Azure/terraform-module-test-helper/bin/breaking_detect@$TFMOD_TEST_HELPER_VERSION && \
    go install github.com/securego/gosec/v2/cmd/gosec@$GOSEC_VERSION && \
    go install github.com/minamijoyo/hcledit@$HCLEDIT_VERSION && \
    go install github.com/lonegunmanb/previousTag@$PREVIOUS_TAG_VERSION && \
    go install github.com/magodo/hclgrep@latest && \
    go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@$GOLANGCI_LINT_VERSION && \
    go install github.com/lonegunmanb/avmfix@$AVMFIX_VERSION && \
    go install github.com/Azure/grept@$GREPT_VERSION && \
    go install github.com/lonegunmanb/newres/v3@$NEWRES_VERSION && \
    go install github.com/lonegunmanb/hclmerge@$HCLMERGE_VERSION && \
    go install github.com/open-policy-agent/conftest@$CONFTEST_VERSION && \
    go install github.com/terraform-docs/terraform-docs@$TERRAFORM_DOCS_VERSION && \
    go install github.com/Azure/mapotf@$MAPOTF_VERSION && \
    cd /src && \
    git clone https://github.com/lonegunmanb/tflintenv.git && \
    cd tflintenv && cd tflintenv && go install && \
    cd ../tflint && go install && \
    cd /src && \
    git clone https://github.com/lonegunmanb/terrafmt.git && \
    cd terrafmt && \
    go install && \
    cd /src && \
    git clone https://github.com/tfutils/tfenv.git && \
    cd /src/tfenv && \
    git checkout $TFENV && \
    rm -rf .git && \
    cd /src && \
    git clone https://github.com/iamhsa/pkenv.git && \
    cd pkenv && \
    rm -rf .git

#FROM mcr.microsoft.com/azurelinux/base/python:3.12 as runner # in case we cannot use azure-cli as base image
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
