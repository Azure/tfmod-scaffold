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
    go install github.com/katbyte/terrafmt@latest && \
    go install golang.org/x/tools/cmd/goimports@latest && \
    go install mvdan.cc/gofumpt@latest && \
    go install github.com/yngveh/sprig-cli@latest && \
    go install github.com/terraform-docs/terraform-docs@$TERRAFORM_DOCS_VERSION && \
    go install github.com/Azure/terraform-module-test-helper/bin/breaking_detect@$TFMOD_TEST_HELPER_VERSION && \
    go install github.com/terraform-linters/tflint@$TFLINT_VERSION && \
    go install github.com/securego/gosec/v2/cmd/gosec@$GOSEC_VERSION && \
    go install github.com/minamijoyo/hcledit@$HCLEDIT_VERSION && \
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
    git clone https://github.com/lonegunmanb/yor.git && \
    cd yor && git checkout special && \
    go install && \
    cd /src && \
    git clone https://github.com/tfutils/tfenv.git && \
    cd /src/tfenv && \
    git checkout $TFENV && \
    rm -rf .git

FROM mcr.microsoft.com/cbl-mariner/base/core:1.0 as runner
ARG GOLANG_IMAGE_TAG=1.19
ARG TERRAFORM_VERSION=1.3.3
ARG TERRAGRUNT_VERSION=v0.43.0
ARG CHECKOV_VERSION=2.1.282
ARG TFLINT_AZURERM_VERSION=0.18.0
ARG TFLINT_BASIC_EXT_VERSION=0.1.2
ARG TFLINT_AZURERM_EXT_VERSION=0.1.1
ARG TARGETARCH
ARG PACKER_VERSION=1.9.4
ARG TFSEC_VERSION=v1.28.4
ENV TFLINT_PLUGIN_DIR /tflint
ENV GOROOT=/root/go
ENV GOPATH=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin:/tfenv/bin
COPY --from=build /go/bin /usr/local/go/bin
COPY --from=build /src/tfenv /tfenv
COPY .terraformrc /root/.terraformrc
RUN yum update -y && \
    yum install -y yum ca-certificates zip unzip jq python3-pip make git less diffutils build-essential openssh-server && \
    tdnf install moby-cli ca-certificates azure-cli -y && \
    wget -q https://go.dev/dl/go${GOLANG_IMAGE_TAG}.linux-${TARGETARCH}.tar.gz && \
    tar -C /root -xzf go*.linux-${TARGETARCH}.tar.gz && \
    rm go${GOLANG_IMAGE_TAG}.linux-${TARGETARCH}.tar.gz && \
    git config --global user.email "tfmod442916@users.noreply.github.com" && \
    git config --global user.name "github-actions[bot]"
RUN pip3 install --upgrade setuptools && \
    pip3 install --no-cache-dir checkov==$CHECKOV_VERSION && \
    tfenv install $TERRAFORM_VERSION && \
    tfenv use $TERRAFORM_VERSION && \
    curl '-#' -fL -o /tmp/packer.zip https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${TARGETARCH}.zip && \
    unzip -q -d /bin/ /tmp/packer.zip && \
    curl '-#' -fL -o /bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_${TARGETARCH} && \
    chmod +x /bin/terragrunt && \
	curl '-#' -fL -o /tmp/tflint-ruleset-azurerm.zip https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v${TFLINT_AZURERM_VERSION}/tflint-ruleset-azurerm_linux_${TARGETARCH}.zip && \
    curl '-#' -fL -o /tmp/tflint-ruleset-azurerm-ext.zip https://github.com/DrikoldLun/tflint-ruleset-azurerm-ext/releases/download/v${TFLINT_AZURERM_EXT_VERSION}/tflint-ruleset-azurerm-ext_linux_${TARGETARCH}.zip && \
    curl '-#' -fL -o /tmp/tflint-ruleset-basic-ext.zip https://github.com/DrikoldLun/tflint-ruleset-basic-ext/releases/download/v${TFLINT_BASIC_EXT_VERSION}/tflint-ruleset-basic-ext_linux_${TARGETARCH}.zip && \
	mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/terraform-linters/tflint-ruleset-azurerm/${TFLINT_AZURERM_VERSION} && \
    mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-azurerm-ext/${TFLINT_AZURERM_EXT_VERSION} && \
    mkdir -p ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-basic-ext/${TFLINT_BASIC_EXT_VERSION} && \
    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/terraform-linters/tflint-ruleset-azurerm/${TFLINT_AZURERM_VERSION} /tmp/tflint-ruleset-azurerm.zip && \
    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-azurerm-ext/${TFLINT_AZURERM_EXT_VERSION} /tmp/tflint-ruleset-azurerm-ext.zip && \
    unzip -q -d ${TFLINT_PLUGIN_DIR}/github.com/Azure/tflint-ruleset-basic-ext/${TFLINT_BASIC_EXT_VERSION} /tmp/tflint-ruleset-basic-ext.zip && \
    curl '-#' -fL -o /bin/tfsec https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-${TARGETARCH} && \
    chmod +x /bin/tfsec && \
	rm -f /tmp/packer.zip && \
    rm -f /tmp/tflint-ruleset-azurerm.zip && \
    rm -f /tmp/tflint-ruleset-azurerm-ext.zip && \
    rm -f /tmp/tflint-ruleset-basic-ext.zip && \
    yum clean all
