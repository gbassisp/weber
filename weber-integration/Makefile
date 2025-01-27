# ensure target stops if there is an error; run on a single shell
# .ONESHELL:
# SHELL = /usr/bin/perl
# .SHELLFLAGS = -e

# check if fvm command exists, otherwise use empty string
FVM_CMD := $(shell command -v fvm 2> /dev/null)
DART := $(FVM_CMD) dart
DART_CMD := $(FVM_CMD) dart --enable-experiment=macros 

export PATH := $(HOME)/.pub-cache/bin:$(PATH)


.PHONY: all-short
all-short: version get analyze doc dry-run test

.PHONY: all
all: version get analyze doc dry-run test-all

.PHONY: kill
kill: 
	@echo "Killing service..."
	@kill -9 $(shell lsof -t -i:8181) || echo "Port 8181 is not in use"

.PHONY: publish
publish: all
	@echo "Publishing package..."
	$(DART) pub publish --force

.PHONY: dry-run
dry-run: kill
	@echo "Running dry-run..."
	$(DART) pub publish --dry-run

.PHONY: test
test:
	@echo "Running tests (exhaustive flag OFF)..."
	$(DART_CMD) test --test-randomize-ordering-seed=random

.PHONY: test-all
test-all:
	@echo "Running all tests (exhaustive flag ON)..."
	$(DART_CMD) --define=exhaustive=true test --test-randomize-ordering-seed=random --use-data-isolate-strategy

.PHONY: coverage
coverage:
	@echo "Running tests..."
	$(DART) pub global activate coverage
	$(DART_CMD) run coverage:test_with_coverage
	$(MAKE) format_lcov

.PHONY: get
get:
	@echo "Getting dependencies..."
	$(DART) pub get 

.PHONY: upgrade
upgrade:
	@echo "Upgrading dependencies..."
	$(DART) pub upgrade

.PHONY: downgrade
downgrade:
	@echo "Downgrading dependencies..."
	$(DART) pub downgrade


.PHONY: doc
doc:
	@echo "Generating documentation..."
	@$(DART) doc || echo "Failed to generate documentation - maybe it's dart 2.12?"

.PHONY: analyze
analyze:
	@echo "Analyzing..."
	$(DART) analyze --fatal-infos --fatal-warnings
	$(DART) format --set-exit-if-changed ./lib/weber.dart ./lib/src/stable ./test

.PHONY: fix 
fix:
	$(DART) analyze || echo "Found errors to fix"
	$(DART) fix --apply

.PHONY: version
version:
	@echo "Checking version..."
	$(DART) --version


### Coverage ###

# ensure all files listed in the coverage report are relative paths
CWD := $(shell pwd)
FILES := $(shell find coverage/*.info -type f ! -path "$(CWD)")

.PHONY: format_lcov
format_lcov:
	@mkdir -p coverage
	@echo "Formatting lcov.info..."
	@echo "CWD: $(CWD)"
	@echo "FILES: $(FILES)"
	@for file in $(FILES); do \
		sed -i'' -e 's|$(CWD)/||g' $$file ; \
	done
