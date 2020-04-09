.PHONY: help    # print this message.
.PHONY: test    # run the test suite

BATS      := vendor/bats/bin/bats
BATS_REPO := https://github.com/bats-core/bats-core.git

help:
	@echo "Available targets :"
	@echo "-------------------"
	@cat Makefile | awk '/^.PHONY:.*#/ { print }' | cut -d' ' -f2-

test: | $(BATS)
	$(BATS) tests/*

$(BATS): | vendor
	git clone $(BATS_REPO) vendor/bats

vendor:
	mkdir -p $@
