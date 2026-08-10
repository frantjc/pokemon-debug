WD = $(CURDIR)/tmp

7Z ?= 7z

.PHONY: clean
clean:
	@rm -rf $(WD)

ifeq ($(V1),)

FPK ?= Data/Data_0.fpk

else

FPK ?= Source/Main/A_0.fpk

.PHONY: pokemon-debug-menu
pokemon-debug-menu:
	@cd tmp/Data/Scripts && (git init && git add . && git commit --message init || true) && git apply ../../../$@.patch && git commit --message $@ && cd -

endif

.PHONY: decompile-scripts
decompile-scripts: check-pokemon-flux clean
	@$(7Z) -o$(WD) x "$(POKEMON_FLUX)/$(FPK)"
	@find "$(WD)" -name "desktop.ini" -type f -exec rm -f {} +

.PHONY: decompile
decompile: decompile-scripts

.PHONY: compile-scripts
compile-scripts: check-pokemon-flux
	@cd "$(WD)" && $(7Z) a "$(POKEMON_FLUX)/$(FPK)" && cd -

.PHONY: compile
compile: compile-scripts

.PHONY: check-pokemon-flux
check-pokemon-flux:
ifndef POKEMON_FLUX
	$(error POKEMON_FLUX must be set to path/to/pokemon/flux)
endif
