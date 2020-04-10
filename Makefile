.PHONY: help    # print this message.
.PHONY: test    # run the test suite
.PHONY: lint    # run linter

BATS      := vendor/bats/bin/bats
BATS_REPO := https://github.com/bats-core/bats-core.git

help:
	@echo "Available targets :"
	@echo "-------------------"
	@cat Makefile | awk '/^.PHONY:.*#/ { print }' | cut -d' ' -f2-


SRC_FILES = $(shell find . -name '*.sh' -type f -not -path './vendor/*')
STATE_DIR = .make-state

$(STATE_DIR) vendor:
	mkdir -p $@


test: | $(BATS)
	$(BATS) tests/*

$(BATS): | vendor
	git clone $(BATS_REPO) vendor/bats


lint: $(STATE_DIR)/lint

$(STATE_DIR)/lint: $(SRC_FILES) | $(STATE_DIR)
	shellcheck $(SRC_FILES)
	@touch $@
