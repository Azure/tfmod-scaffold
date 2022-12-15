#!/bin/bash
if [ -z "${SKIP_INSTALL_GH_ACTION_WORKFLOW}" ]; then
  mkdir -p .github/workflows
  cp tfmod-scaffold/workflows/acc-test.yaml .github/workflows/acc-test.yaml
  cp tfmod-scaffold/workflows/pr-check.yaml .github/workflows/pr-check.yaml
  cp tfmod-scaffold/workflows/breaking-change-detect.yaml .github/workflows/breaking-change-detect.yaml
  cp tfmod-scaffold/workflows/update-changelog.yaml .github/workflows/update-changelog.yaml
  mkdir -p .github/ISSUE_TEMPLATE
  cp tfmod-scaffold/workflows/ISSUE_TEMPLATE/Bug_Report.yml .github/ISSUE_TEMPLATE/Bug_Report.yml
  cp tfmod-scaffold/workflows/ISSUE_TEMPLATE/Feature_Request.yml .github/ISSUE_TEMPLATE/Feature_Request.yml
  cp tfmod-scaffold/workflows/ISSUE_TEMPLATE/config.yml .github/ISSUE_TEMPLATE/config.yml

  cp tfmod-scaffold/workflows/pull_request_template.md .github/pull_request_template.md
  cp tfmod-scaffold/workflows/dependabot.yml .github/dependabot.yml
else
	echo "Skip workflow installation"
fi