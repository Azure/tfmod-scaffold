ARG GOLANG_IMAGE_TAG=1.20
FROM mcr.microsoft.com/oss/go/microsoft/golang:${GOLANG_IMAGE_TAG} as build
ARG TERRAFORM_DOCS_VERSION=v0.16.0
ARG TERRAGRUNT_VERSION=v0.43.0
ARG TFMOD_TEST_HELPER_VERSION=v0.0.22
ARG GOLANGCI_LINT_VERSION=v1.49.0
ARG HCLEDIT_VERSION=v0.2.6
ARG GOSEC_VERSION=v2.14.0
ARG YOR_VERSION=0.1.171
ARG YORBOX_VERSION=latest
ARG TFENV=v3.0.0
ARG GREPT_VERSION=1a4f08c2fdc41b6a3702fa1238354c40a3fcce3e
ARG NEWRES_VERSION=a535fe92925845dfa033a3db71adf7d65511cbf3
ARG AVMFIX_VERSION=9c158444b055e845c0cc9afc7cdc88d0ab19e5eb
ARG HCLMERGE_VERSION=8735bef83162f3ee952213b16e89f8d0ac0d08f7
ARG TARGETARCH
COPY GNUmakefile /src/GNUmakefile
COPY scripts /src/scripts
RUN cd /src && \
    apt-get update && \
    apt-get install -y zip  && \
    export CGO_ENABLED=0 && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install mvdan.cc/gofumpt@latest && \
    #    go install github.com/terraform-docs/terraform-docs@$TERRAFORM_DOCS_VERSION && \
    go install github.com/Azure/terraform-module-test-helper/bin/breaking_detect@$TFMOD_TEST_HELPER_VERSION && \
    go install github.com/securego/gosec/v2/cmd/gosec@$GOSEC_VERSION && \
    #    go install github.com/minamijoyo/hcledit@$HCLEDIT_VERSION && \
    git clone https://github.com/lonegunmanb/hcledit.git && \
    cd hcledit && git checkout $HCLEDIT_VERSION && go install && \
    cd /src && \
    go install github.com/lonegunmanb/previousTag@latest && \
    go install github.com/magodo/hclgrep@latest && \
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH || $GOPATH)/bin $GOLANGCI_LINT_VERSION && \
    go install github.com/lonegunmanb/avmfix@$AVMFIX_VERSION && \
    go install github.com/lonegunmanb/yorbox@$YORBOX_VERSION && \
    go install github.com/Azure/grept@$GREPT_VERSION && \
    go install github.com/lonegunmanb/newres/v3@$NEWRES_VERSION && \
    go install github.com/lonegunmanb/hclmerge@$HCLMERGE_VERSION && \
    #    curl '-#' -fL -o /tmp/yor.tar.gz https://github.com/bridgecrewio/yor/releases/download/${YOR_VERSION}/yor_${YOR_VERSION}_linux_${TARGETARCH}.tar.gz && \
    #    tar -xzf /tmp/yor.tar.gz -C /go/bin && chmod +x /go/bin/yor
    #    go install github.com/terraform-linters/tflint@$TFLINT_VERSION && \
    git clone https://github.com/lonegunmanb/tflint.git && \
    cd tflint && git checkout $TFLINT_VERSION && \
    go install && \
    cd /src && \
    git clone https://github.com/lonegunmanb/yor.git && \
    cd yor && git checkout main && \
    go install && \
    cd /src && \
    git clone https://github.com/gruntwork-io/terragrunt.git && \
    cd terragrunt && git checkout $TERRAGRUNT_VERSION && \
    go install && \
    cd /src && \
    git clone https://github.com/lonegunmanb/tflintenv.git && \
    cd tflintenv && cd tflintenv && go install && \
    cd ../tflint && go install && \
    cd /src && \
    git clone https://github.com/lonegunmanb/terrafmt.git && \
    cd terrafmt && \
    go install && \
    cd /src && \
    git clone https://github.com/lonegunmanb/terraform-docs.git && \
    cd terraform-docs && \
    git checkout $TERRAFORM_DOCS_VERSION && \
    go install && \
    cd /src && \
    git clone https://github.com/tfutils/tfenv.git && \
    cd /src/tfenv && \
    git checkout $TFENV && \
    rm -rf .git

#FROM mcr.microsoft.com/cbl-mariner/base/core:2.0 as runner
#ARG GOLANG_IMAGE_TAG=1.19
#ARG TERRAFORM_VERSION=1.3.3
#ARG TARGETARCH
#ARG PACKER_VERSION=1.9.4
#ARG TFSEC_VERSION=v1.28.4
#ARG TFLINT_VERSION=v0.41.0
#ENV TFLINT_PLUGIN_DIR /home/runtimeuser/tflint
#ENV GOROOT=/usr/local/go
#ENV GOPATH=/home/runtimeuser/go
#ENV PATH=$PATH:/home/runtimeuser/tfenv/bin:/pkenv/bin:$GOROOT/bin:$GOPATH/bin
#ENV TFLINTENV_DEFAULT_VERSION=$TFLINT_VERSION
#ENV TFENV_AUTO_INSTALL=true
#ENV TFENV_TERRAFORM_VERSION=$TERRAFORM_VERSION
#ENV TF_CLI_CONFIG_FILE=/home/runtimeuser/.terraformrc
#RUN yum update -y && \
#    yum install -y ca-certificates zip unzip jq python3-devel python3-pip make git less diffutils build-essential openssh-server wget && \
#    tdnf install moby-cli ca-certificates -y && \
#    pip3 install cryptography -U && \
#    pip install azure-cli && \
#    wget -q https://go.dev/dl/go${GOLANG_IMAGE_TAG}.linux-${TARGETARCH}.tar.gz && \
#    tar -C /usr/local -xzf go*.linux-${TARGETARCH}.tar.gz && \
#    rm go${GOLANG_IMAGE_TAG}.linux-${TARGETARCH}.tar.gz && \
#    git config --global user.email "tfmod442916@users.noreply.github.com" && \
#    git config --global user.name "github-actions[bot]" && \
#    git config --global --add safe.directory '*'
#RUN mkdir /home/runtimeuser && \
#    chmod -R 777 /home/runtimeuser
#COPY .terraformrc /home/runtimeuser/.terraformrc
#COPY --from=build /go/bin /usr/local/go/bin
#COPY --from=build /src/tfenv /home/runtimeuser/tfenv
#RUN chmod 777 /home/runtimeuser/tfenv && \
#    git clone https://github.com/iamhsa/pkenv.git /pkenv && \
#    cd /pkenv && rm -rf .git && \
#    rm -r /tmp/* && \
#    yum clean all
