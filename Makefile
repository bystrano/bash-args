.PHONY: help    # print this message
.PHONY: test    # run the test suite
.PHONY: lint    # run linter
.PHONY: run     # run an interactive session in docker (see Dockerfile)
.PHONY: profile # profile a run and display the result nicely

BASH-VERSION := 3.2

BATS      := vendor/bats/bin/bats
BATS_REPO := https://github.com/bats-core/bats-core.git

help:
	@echo "Available targets :"
	@echo "-------------------"
	@cat Makefile | awk '/^.PHONY:.*#/ { print }' | cut -d' ' -f2-


BASH_SRC = $(shell find . -name '*.sh' -type f -not -path './vendor/*')
AWK_SRC = $(shell find lib -name '*.awk' -type f)
STATE_DIR = .make-state

$(STATE_DIR) vendor:
	mkdir -p $@

test: test-unit test-func

.PHONY: test-unit
test-unit: | $(BATS)
	$(BATS) $(BATS_OPTS) tests/unit/*

.PHONY: test-func
test-func: | $(BATS)
	$(BATS) $(BATS_OPTS) tests/func/*

$(BATS): | vendor
	git clone $(BATS_REPO) vendor/bats


lint: $(STATE_DIR)/lint

$(STATE_DIR)/lint: $(BASH_SRC) | $(STATE_DIR)
	@shellcheck $(SHELLCHECK_OPTS) $(BASH_SRC)
	@echo | awk --lint=invalid $(addprefix -f , $(AWK_SRC))
	@touch $@


run:
	docker build --build-arg BASH_VERSION=$(BASH-VERSION) -t bash-args .
	docker run -it --rm --mount src=`pwd`,target=/bash-args,type=bind bash-args $(RUN-CMD)


profile:
	@ _PROFILE=1 tests/fixtures/subcommands.sh > /dev/null
	@find tmp/ -type f -printf '%T@ %h/%f\n' | sort -r | head -n2 | cut -d' ' -f2 | xargs tests/show_profile.sh
