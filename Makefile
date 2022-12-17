VERSION := 0.0.1
.DEFAULT_GOAL = help
.PHONY = help start stop
SHELL := /usr/bin/env bash

# Functions
check-version = (echo "Current project version: ${VERSION}")

# Colours
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'targets'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (24 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

help:
	@perl -e '$(HELP)' $(MAKEFILE_LIST)

version: ## Check and display current project version
	@$(call check-version)

start: ## Deploy docker containers and start the project
	docker compose up --remove-orphans -d

stop: ## Stop docker containers
	docker compose down
