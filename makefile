.PHONY = install
install:
	./manager.py --commands "mkdir -p {location}" "stow --stow {package} --target {location}"

.PHONY = reinstall
reinstall:
	./manager.py --commands "mkdir -p {location}" "stow --restow {package} --target {location}"

.PHONY = clean
clean:
	./manager.py --commands "stow --delete {package} --target {location}"

