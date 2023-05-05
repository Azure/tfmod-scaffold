fmt:
	@echo "==> Fixing source code with gofmt..."
	# This logic should match the search logic in scripts/gofmtcheck.sh
	find . -name '*.go' | grep -v vendor | xargs gofmt -s -w

fumpt:
	@echo "==> Fixing source code with Gofumpt..."
	# This logic should match the search logic in scripts/gofmtcheck.sh
	find . -name '*.go' | grep -v vendor | xargs gofumpt -w

gosec:
	@echo "==> Checking go code with gosec..."
	cd test && gosec -tests ./...

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

lint: golint tflint gosec

checkovcheck:
	@sh "$(CURDIR)/scripts/checkovcheck.sh"

checkovplancheck:
	@sh "$(CURDIR)/scripts/checkovplancheck.sh"

fmtcheck: gofmtcheck tfvalidatecheck tffmtcheck terrafmtcheck

pr-check: gencheck depscheck fmtcheck lint unit-test checkovcheck

unit-test:
	@sh "$(CURDIR)/scripts/run-unit-test.sh"

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
	@sh "$(CURDIR)/scripts/generate.sh"

gencheck:
	@sh "$(CURDIR)/scripts/gencheck.sh"

yor-tag:
	@sh "$(CURDIR)/scripts/yor-tag.sh"

autofix:
	@sh "$(CURDIR)/scripts/autofix.sh"

test: fmtcheck
	@TEST=$(TEST) ./scripts/run-gradually-deprecated.sh
	@TEST=$(TEST) ./scripts/run-test.sh

build-test:
	@sh "$(CURDIR)/scripts/build-test.sh"

.PHONY: fmt fmtcheck pr-check
