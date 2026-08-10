.PHONY: pokemon-debug-menu debug-menu crests multi-ability frantjc-crests
pokemon-debug-menu debug-menu crests multi-ability frantjc-crests: check-pokemon-desolation
	@cd "$(POKEMON_DESOLATION)/Scripts" && (git init && git add . && git commit --message init || true) && git apply $(CURDIR)/$@.patch && git add . && git commit --message $@ && cd -

.PHONY: check-pokemon-desolation
check-pokemon-desolation:
ifndef POKEMON_DESOLATION
	$(error POKEMON_DESOLATION must be set to path/to/pokemon/desolation)
endif
