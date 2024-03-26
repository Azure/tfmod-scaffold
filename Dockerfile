ARG GOLANG_IMAGE_TAG=1.20
FROM mcr.microsoft.com/oss/go/microsoft/golang:${GOLANG_IMAGE_TAG} as build
ARG TERRAFORM_DOCS_VERSION=v0.16.0
ARG TFMOD_TEST_HELPER_VERSION=v0.0.22
ARG TFLINT_VERSION=v0.41.0
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

FROM mcr.microsoft.com/cbl-mariner/base/core:2.0 as runner
ARG GOLANG_IMAGE_TAG=1.19
ARG TERRAFORM_VERSION=1.3.3
ARG TERRAGRUNT_VERSION=v0.43.0
ARG CHECKOV_VERSION=2.1.282
ARG TFLINT_AZURERM_VERSION=0.18.0
ARG TFLINT_BASIC_EXT_VERSION=0.1.2
ARG TFLINT_AZURERM_EXT_VERSION=0.1.1
ARG TFLINT_AVM_VERSION=0.2.0
ARG TFLINT_TERRAFORM_VERSION=0.5.0
ARG TARGETARCH
ARG PACKER_VERSION=1.9.4
ARG TFSEC_VERSION=v1.28.4
ENV TFLINT_PLUGIN_DIR /tflint
ENV GOROOT=/root/go
ENV GOPATH=/usr/local/go
ENV PATH=$PATH:/tfenv/bin:/pkenv/bin:$GOROOT/bin:$GOPATH/bin
ENV TFENV_AUTO_INSTALL=true
ENV TFENV_TERRAFORM_VERSION=$TERRAFORM_VERSION
COPY --from=build /go/bin /usr/local/go/bin
COPY --from=build /src/tfenv /tfenv
COPY .terraformrc /root/.terraformrc
RUN yum update -y && \
    yum install -y ca-certificates zip unzip jq python3-devel python3-pip make git less diffutils build-essential openssh-server wget && \
    tdnf install moby-cli ca-certificates -y && \
    pip3 install cryptography -U && \
    pip install azure-cli && \
    wget -q https://go.dev/dl/go${GOLANG_IMAGE_TAG}.linux-${TARGETARCH}.tar.gz && \
    tar -C /root -xzf go*.linux-${TARGETARCH}.tar.gz && \
    rm go${GOLANG_IMAGE_TAG}.linux-${TARGETARCH}.tar.gz && \
    git config --global user.email "tfmod442916@users.noreply.github.com" && \
    git config --global user.name "github-actions[bot]" && \
    git config --global --add safe.directory '*'
#RUN pip3 install --upgrade setuptools && \
#    pip3 install --no-cache-dir checkov==$CHECKOV_VERSION && \
RUN curl '-#' -fL -o /bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_${TARGETARCH} && \
    chmod +x /bin/terragrunt && \
#	curl '-#' -fL -o /tmp/tflint-ruleset-azurerm.zip https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v${TFLINT_AZURERM_VERSION}/tflint-ruleset-azurerm_linux_${TARGETARCH}.zip && \
#    curl '-#' -fL -o /tmp/tflint-ruleset-azurerm-ext.zip https://github.com/Azure/tflint-ruleset-azurerm-ext/releases/download/v${TFLINT_AZURERM_EXT_VERSION}/tflint-ruleset-azurerm-ext_linux_${TARGETARCH}.zip && \
#    curl '-#' -fL -o /tmp/tflint-ruleset-basic-ext.zip https://github.com/Azure/tflint-ruleset-basic-ext/releases/download/v${TFLINT_BASIC_EXT_VERSION}/tflint-ruleset-basic-ext_linux_${TARGETARCH}.zip && \
#    curl '-#' -fL -o /tmp/tflint-ruleset-avm.zip https://github.com/Azure/tflint-ruleset-avm/releases/download/v${TFLINT_AVM_VERSION}/tflint-ruleset-avm_linux_${TARGETARCH}.zip && \
#    curl '-#' -fL -o /tmp/tflint-ruleset-terraform.zip https://github.com/terraform-linters/tflint-ruleset-terraform/releases/download/v${TFLINT_TERRAFORM_VERSION}/tflint-ruleset-terraform_linux_${TARGETARCH}.zip && \
#	mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/terraform-linters/tflint-ruleset-azurerm/${TFLINT_AZURERM_VERSION} && \
#    mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-azurerm-ext/${TFLINT_AZURERM_EXT_VERSION} && \
#    mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-basic-ext/${TFLINT_BASIC_EXT_VERSION} && \
#    mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-avm/${TFLINT_AVM_VERSION} && \
#    mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/terraform-linters/tflint-ruleset-terraform/${TFLINT_TERRAFORM_VERSION} && \
#    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/terraform-linters/tflint-ruleset-azurerm/${TFLINT_AZURERM_VERSION} /tmp/tflint-ruleset-azurerm.zip && \
#    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-azurerm-ext/${TFLINT_AZURERM_EXT_VERSION} /tmp/tflint-ruleset-azurerm-ext.zip && \
#    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-basic-ext/${TFLINT_BASIC_EXT_VERSION} /tmp/tflint-ruleset-basic-ext.zip && \
#    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-avm/${TFLINT_AVM_VERSION} /tmp/tflint-ruleset-avm.zip && \
#    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/terraform-linters/tflint-ruleset-terraform/${TFLINT_TERRAFORM_VERSION} /tmp/tflint-ruleset-terraform.zip && \
#    curl '-#' -fL -o /bin/tfsec https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-${TARGETARCH} && \
#    chmod +x /bin/tfsec && \
    git clone https://github.com/iamhsa/pkenv.git /pkenv && \
    cd /pkenv && rm -rf .git && \
	rm -r /tmp/* && \
    yum clean all
