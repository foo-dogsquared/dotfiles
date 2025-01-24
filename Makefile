MANIFEST := nixos-zilch
FLAGS :=

.PHONY: install
install:
	./vtsm --manifest ".vtsm/${MANIFEST}.json" --commands "mkdir -p {location} && stow --stow {package} --target {location}" $(FLAGS)

.PHONY: reinstall
reinstall:
	./vtsm --manifest ".vtsm/${MANIFEST}.json" --commands "mkdir -p {location} && stow --restow {package} --target {location}" $(FLAGS)

.PHONY: clean
clean:
	./vtsm --manifest ".vtsm/${MANIFEST}.json" --commands "stow --delete {package} --target {location}" $(FLAGS)

.PHONY: update
update:
	nix flake update --commit-lock-file --commit-lockfile-summary "flake.lock: update inputs"

.PHONY: dry-run
dry-run:
	./vtsm --manifest ".vtsm/${MANIFEST}.json" --commands "stow --stow {package} --target {location} --simulate"
