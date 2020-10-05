MANIFEST := nixos-zilch

.PHONY = install
install:
	./vtsm --manifest ".vtsm/${MANIFEST}.json" --commands "mkdir -p {location} && stow --stow {package} --target {location}"

.PHONY = reinstall
reinstall:
	./vtsm --manifest ".vtsm/${MANIFEST}.json" --commands "mkdir -p {location} && stow --restow {package} --target {location}"

.PHONY = clean
clean:
	./vtsm --manifest ".vtsm/${MANIFEST}.json" --commands "stow --delete {package} --target {location}"
