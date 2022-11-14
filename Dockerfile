ARG GOLANG_IMAGE_TAG=1.19
FROM mcr.microsoft.com/oss/go/microsoft/golang:${GOLANG_IMAGE_TAG} as build
ARG TERRAFORM_DOCS_VERSION=v0.16.0
ARG TFMOD_TEST_HELPER_VERSION=v0.0.22
ARG TFLINT_VERSION=v0.41.0
ARG GOLANGCI_LINT_VERSION=v1.49.0
ARG HCLEDIT_VERSION=v0.2.6
ARG GOSEC_VERSION=v2.14.0
COPY GNUmakefile /src/GNUmakefile
COPY scripts /src/scripts
RUN cd /src && \
    apt-get update && \
    apt-get install -y zip npm  && \
    go install github.com/katbyte/terrafmt@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install mvdan.cc/gofumpt@latest && \
    go install github.com/yngveh/sprig-cli@latest && \
    go install github.com/terraform-docs/terraform-docs@$TERRAFORM_DOCS_VERSION && \
    go install github.com/Azure/terraform-module-test-helper/bin/breaking_detect@$TFMOD_TEST_HELPER_VERSION && \
    go install github.com/terraform-linters/tflint@$TFLINT_VERSION && \
    go install github.com/securego/gosec/v2/cmd/gosec@$GOSEC_VERSION && \
    go install github.com/minamijoyo/hcledit@$HCLEDIT_VERSION && \
    curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH || $GOPATH)/bin $GOLANGCI_LINT_VERSION

FROM mcr.microsoft.com/cbl-mariner/base/core:1.0 as runner
ARG GOLANG_IMAGE_TAG=1.19
ARG TERRAFORM_VERSION=1.3.3
ARG CHECKOV_VERSION=2.1.282
ARG TFLINT_AZURERM_VERSION=0.18.0
ARG TFLINT_BASIC_EXT_VERSION=0.1.2
ARG TFLINT_AZURERM_EXT_VERSION=0.1.1
ARG BUILDARCH
ENV TFLINT_PLUGIN_DIR /tflint
ENV PATH=$PATH:/usr/local/go/bin
COPY --from=build /go/bin /usr/local/go/bin
COPY .terraformrc /root/.terraformrc
RUN yum update && yum install -y yum ca-certificates zip unzip jq nodejs python3-pip make git diffutils build-essential && \
    wget https://go.dev/dl/go${GOLANG_IMAGE_TAG}.linux-${BUILDARCH}.tar.gz && \
    tar -C /usr/local -xzf go*.linux-${BUILDARCH}.tar.gz && \
    rm go${GOLANG_IMAGE_TAG}.linux-${BUILDARCH}.tar.gz && \
    npm install markdown-table-formatter -g && \
    mkdir -p $HOME/.terraform.d/plugin-cache
RUN pip3 install --upgrade setuptools && \
    pip3 install --no-cache-dir checkov==$CHECKOV_VERSION && \
    curl '-#' -fL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${BUILDARCH}.zip && \
	unzip -q -d /bin/ /tmp/terraform.zip && \
	curl '-#' -fL -o /tmp/tflint-ruleset-azurerm.zip https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v${TFLINT_AZURERM_VERSION}/tflint-ruleset-azurerm_linux_${BUILDARCH}.zip && \
    curl '-#' -fL -o /tmp/tflint-ruleset-azurerm-ext.zip https://github.com/DrikoldLun/tflint-ruleset-azurerm-ext/releases/download/v${TFLINT_AZURERM_EXT_VERSION}/tflint-ruleset-azurerm-ext_linux_${BUILDARCH}.zip && \
    curl '-#' -fL -o /tmp/tflint-ruleset-basic-ext.zip https://github.com/DrikoldLun/tflint-ruleset-basic-ext/releases/download/v${TFLINT_BASIC_EXT_VERSION}/tflint-ruleset-basic-ext_linux_${BUILDARCH}.zip && \
	mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/terraform-linters/tflint-ruleset-azurerm/${TFLINT_AZURERM_VERSION} && \
    mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-azurerm-ext/${TFLINT_AZURERM_EXT_VERSION} && \
    mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-basic-ext/${TFLINT_BASIC_EXT_VERSION} && \
    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/terraform-linters/tflint-ruleset-azurerm/${TFLINT_AZURERM_VERSION} /tmp/tflint-ruleset-azurerm.zip && \
    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-azurerm-ext/${TFLINT_AZURERM_EXT_VERSION} /tmp/tflint-ruleset-azurerm-ext.zip && \
    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-basic-ext/${TFLINT_BASIC_EXT_VERSION} /tmp/tflint-ruleset-basic-ext.zip && \
	rm -f /tmp/terraform.zip && \
    rm -f /tmp/tflint-ruleset-azurerm.zip
