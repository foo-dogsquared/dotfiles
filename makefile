.PHONY = install
install:
	./vtsm --commands "mkdir -p {location}" "stow --stow {package} --target {location}"

.PHONY = reinstall
reinstall:
	./vtsm --commands "mkdir -p {location}" "stow --restow {package} --target {location}"

.PHONY = clean
clean:
	./vtsm --commands "stow --delete {package} --target {location}"

