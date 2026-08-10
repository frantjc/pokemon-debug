.PHONY: crests mini-debug
crests mini-debug: check-pokemon-rejuvenation
	@cd "$(POKEMON_REJUVENATION)/Scripts" && (git init && git add . && git commit --message init || true) && git apply $(CURDIR)/$@.patch && git add . && git commit --message $@ && cd -

.PHONY: check-pokemon-rejuvenation
check-pokemon-rejuvenation:
ifndef POKEMON_REJUVENATION
	$(error POKEMON_REJUVENATION must be set to path/to/pokemon/rejuvenation)
endif
