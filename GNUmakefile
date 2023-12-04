REMOTE_SCRIPT := "https://raw.githubusercontent.com/Azure/tfmod-scaffold/main/scripts"

fmt:
	@echo "==> Fixing source code with gofmt..."
	find . -name '*.go' | grep -v vendor | xargs gofmt -s -w

fumpt:
	@echo "==> Fixing source code with Gofumpt..."
	find . -name '*.go' | grep -v vendor | xargs gofumpt -w

gosec:
	@echo "==> Checking go code with gosec..."
	cd test && gosec -tests ./...

tffmt:
	@echo "==> Formatting terraform code..."
	terraform fmt -recursive

tffmtcheck:
	curl -sSL "$(REMOTE_SCRIPT)/terraform-fmt.sh" | sh -s

tfvalidatecheck:
	curl -sSL "$(REMOTE_SCRIPT)/terraform-validate.sh" | sh -s

terrafmtcheck:
	curl -sSL "$(REMOTE_SCRIPT)/terrafmt-check.sh" | sh -s

gofmtcheck:
	curl -sSL "$(REMOTE_SCRIPT)/gofmtcheck.sh" | sh -s
	curl -sSL "$(REMOTE_SCRIPT)/fumptcheck.sh" | sh -s

golint:
	curl -sSL "$(REMOTE_SCRIPT)/run-golangci-lint.sh" | sh -s

tflint:
	curl -sSL "$(REMOTE_SCRIPT)/run-tflint.sh" | sh -s

lint: golint tflint gosec

checkovcheck:
	curl -sSL "$(REMOTE_SCRIPT)/checkovcheck.sh" | sh -s

checkovplancheck:
	curl -sSL "$(REMOTE_SCRIPT)/checkovplancheck.sh" | sh -s

fmtcheck: gofmtcheck tfvalidatecheck tffmtcheck terrafmtcheck

pr-check: depscheck fmtcheck lint unit-test checkovcheck

unit-test:
	curl -sSL "$(REMOTE_SCRIPT)/run-unit-test.sh" | sh -s

e2e-test:
	curl -sSL "$(REMOTE_SCRIPT)/run-e2e-test.sh" | sh -s

version-upgrade-test:
	curl -sSL "$(REMOTE_SCRIPT)/version-upgrade-test.sh" | sh -s

terrafmt:
	curl -sSL "$(REMOTE_SCRIPT)/terrafmt.sh" | sh -s

pre-commit: tffmt terrafmt depsensure fmt fumpt generate

depsensure:
	curl -sSL "$(REMOTE_SCRIPT)/deps-ensure.sh" | sh -s

depscheck:
	curl -sSL "$(REMOTE_SCRIPT)/deps-check.sh" | sh -s

generate:
	curl -sSL "$(REMOTE_SCRIPT)/generate.sh" | sh -s

gencheck:
	curl -sSL "$(REMOTE_SCRIPT)/gencheck.sh" | sh -s

yor-tag:
	curl -sSL "$(REMOTE_SCRIPT)/yor-tag.sh" | sh -s

autofix:
	curl -sSL "$(REMOTE_SCRIPT)/autofix.sh" | sh -s

test: fmtcheck
	@TEST=$(TEST) ./scripts/run-gradually-deprecated.sh
	@TEST=$(TEST) ./scripts/run-test.sh

build-test:
	curl -sSL "$(REMOTE_SCRIPT)/build-test.sh" | sh -s

.PHONY: fmt fmtcheck pr-check