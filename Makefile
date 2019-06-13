DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin etc
EXCLUSIONS := .git .gitignore .gitmodules
DOTFILES   := $(addprefix $(HOME)/, $(filter-out $(EXCLUSIONS), $(CANDIDATES)))

.DEFAULT_GOAL := help

.PHONY: update install init symlink sync .sync

update: sync symlink ## Sync the repository and update symlinks
install: sync symlink init ## Sync the repository, update symlinks, and initialize

init: ## Set up environment settings
	@DOTPATH=$(DOTPATH) bash $(DOTPATH)/etc/init/init.sh

symlink: $(DOTFILES) ## Create symlinks to dotfiles in home directory

$(DOTFILES):
	@ln -sfnv $(abspath $(notdir $@)) $@

TRAPSIGS := SIGINT SIGTERM SIGKILL ERR
sync: ## Sync the repository with one on GitHub
	@# trap signals to make sure to restore stashed changes
	@bash -c "trap 'trap - $(TRAPSIGS); [ `git stash list | wc -l` -gt 0 ] && git stash pop --quiet; exit 0;' $(TRAPSIGS); $(MAKE) .sync"

.sync:
	@(git diff-index --quiet HEAD || git stash --quiet) && bash -c "trap $(TRAPSIGS)"
	@git pull --ff-only --quiet
	@echo Update submodules
	@git submodule update
	@git submodule foreach git pull origin master
	@git add -u
	@git diff-index --quiet HEAD || (git commit -m 'Update submodules' && git push)
	@git diff-index --quiet origin/`git symbolic-ref --short HEAD` || (echo Push my local commits && git push)
	@[ `git stash list | wc -l` -gt 0 ] && git stash pop --quiet || exit 0

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

