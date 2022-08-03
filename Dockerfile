ARG GOLANG_IMAGE_TAG=1.18
FROM --platform=$BUILDPLATFORM golang:${GOLANG_IMAGE_TAG} as build
COPY GNUmakefile /src/GNUmakefile
COPY scripts /src/scripts
RUN cd /src && \
    apt update && \
    apt install -y zip npm  && \
    make tools

FROM --platform=$BUILDPLATFORM golang:${GOLANG_IMAGE_TAG} as runner
ARG TERRAFORM_VERSION=1.2.6
ARG TFLINT_AZURERM_VERSION=0.17.1
ARG BUILDARCH
ENV TFLINT_PLUGIN_DIR /tflint
COPY --from=build $GOPATH/bin $GOPATH/bin
COPY --from=build /usr/local/bin/tflint /bin/tflint
RUN apt update && apt install -y curl zip python3 pip coreutils jq nodejs npm && \
    npm install markdown-table-formatter -g && \
    pip install checkov && \
    curl '-#' -fL -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_$BUILDARCH.zip && \
	unzip -q -d /bin/ /tmp/terraform.zip && \
	curl '-#' -fL -o /tmp/tflint-ruleset-azurerm.zip https://github.com/terraform-linters/tflint-ruleset-azurerm/releases/download/v${TFLINT_AZURERM_VERSION}/tflint-ruleset-azurerm_linux_$BUILDARCH.zip && \
	mkdir -p $TFLINT_PLUGIN_DIR/github.com/terraform-linters/tflint-ruleset-azurerm/$TFLINT_AZURERM_VERSION && \
    unzip -q -d $TFLINT_PLUGIN_DIR/github.com/terraform-linters/tflint-ruleset-azurerm/$TFLINT_AZURERM_VERSION /tmp/tflint-ruleset-azurerm.zip && \
	rm -f /tmp/terraform.zip && \
    rm -f /tmp/tflint-ruleset-azurerm.zip