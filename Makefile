default: format docs-update lint

.PHONY: docs-check
docs-check:
	@./bin/docs --check

.PHONY: docs-install
docs-install:
	@./bin/docs --install --verbose

.PHONY: docs-update
docs-update:
	@./bin/docs --update

.PHONY: format
format:
	@terraform fmt -recursive ./

.PHONY: format-check
format-check:
	@terraform fmt -check -recursive ./

.PHONY: lint
lint:
	@tflint --init && \
	tflint --recursive --config "$$(pwd)/.tflint.hcl" --format compact
