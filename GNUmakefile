tools:
	@echo "==> installing required tooling..."
	go install github.com/katbyte/terrafmt@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install mvdan.cc/gofumpt@latest
	go install github.com/yngveh/sprig-cli@latest
	go install github.com/terraform-docs/terraform-docs@v0.16.0
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $$(go env GOPATH || $$GOPATH)/bin v1.49.0
	export TFLINT_VERSION=v0.40.1 && curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
	npm install markdown-table-formatter -g

fmt:
	@echo "==> Fixing source code with gofmt..."
	# This logic should match the search logic in scripts/gofmtcheck.sh
	find . -name '*.go' | grep -v vendor | xargs gofmt -s -w

fumpt:
	@echo "==> Fixing source code with Gofumpt..."
	# This logic should match the search logic in scripts/gofmtcheck.sh
	find . -name '*.go' | grep -v vendor | xargs gofumpt -w

tffmt:
	@echo "==> Formatting terraform code..."
	terraform fmt -recursive

tffmtcheck:
	@sh "$(CURDIR)/scripts/terraform-fmt.sh"

tfvalidatecheck:
	@sh "$(CURDIR)/scripts/terraform-validate.sh"

terrafmtcheck:
	@sh "$(CURDIR)/scripts/terrafmt-check.sh"

gofmtcheck:
	@sh "$(CURDIR)/scripts/gofmtcheck.sh"
	@sh "$(CURDIR)/scripts/fumptcheck.sh"

golint:
	@sh "$(CURDIR)/scripts/run-golangci-lint.sh"

tflint:
	@sh "$(CURDIR)/scripts/run-tflint.sh"

lint: golint tflint

checkovcheck:
	@sh "$(CURDIR)/scripts/checkovcheck.sh"

checkovplancheck:
	@sh "$(CURDIR)/scripts/checkovplancheck.sh"

fmtcheck: gofmtcheck tfvalidatecheck tffmtcheck terrafmtcheck

pr-check: gencheck depscheck fmtcheck lint checkovcheck

e2e-test:
	@sh "$(CURDIR)/scripts/run-e2e-test.sh"

version-upgrade-test:
	@sh "$(CURDIR)/scripts/version-upgrade-test.sh"

terrafmt:
	@echo "==> Fixing test and document terraform blocks code with terrafmt..."
	@find . -name '*.md' -o -name "*.go" | grep -v -e '.github' -e '.terraform' -e 'vendor' | while read f; do terrafmt fmt -f $$f; done

pre-commit: tffmt terrafmt depsensure fmt fumpt generate

depsensure:
	@sh "$(CURDIR)/scripts/deps-ensure.sh"

depscheck:
	@sh "$(CURDIR)/scripts/deps-check.sh"

generate:
	@echo "--> Generating doc"
	@rm -f .terraform.lock.hcl
	@terraform-docs markdown table --output-file README.md --output-mode inject ./
	@markdown-table-formatter README.md

gencheck:
	@echo "==> Generating..."
	@cp README.md README-generated.md
	@terraform-docs markdown table --output-file README-generated.md --output-mode inject ./
	@markdown-table-formatter README-generated.md
	@echo "==> Comparing generated code to committed code..."
	@diff -q README.md README-generated.md || \
    		(echo; echo "Unexpected difference in generated document. Run 'make generate' to update the generated document and commit."; exit 1)

test: fmtcheck
	@TEST=$(TEST) ./scripts/run-gradually-deprecated.sh
	@TEST=$(TEST) ./scripts/run-test.sh

.PHONY: fmt fmtcheck pr-check
