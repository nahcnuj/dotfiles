DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin etc
EXCLUSIONS := .git .gitignore .gitmodules
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

.PHONY: init deploy help

deploy: ## Create symlinks to dotfiles into home directory
	@echo $(DOTFILES) \
		| tr ' ' "\n" \
		| xargs -n 1 -i ln -sfnv $(DOTPATH)/{} $(HOME)/{}

init: ## 
	@#@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

