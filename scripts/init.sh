#!/bin/bash
if [ -z "${SKIP_INSTALL_GH_ACTION_WORKFLOW}" ]; then
  mkdir -p .github/workflows
  cp tfmod-scaffold/workflows/acc-test.yaml .github/workflows/acc-test.yaml
  cp tfmod-scaffold/workflows/pr-check.yaml .github/workflows/pr-check.yaml
  cp tfmod-scaffold/workflows/main-branch-push.yaml .github/workflows/main-branch-push.yaml
else
	echo "Skip workflow installation"
fi

cp tfmod-scaffold/.tflint.hcl .tflint.hcl