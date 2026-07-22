SERVICES := $(notdir $(wildcard systemd/.config/systemd/user/*.service))

all: stow enable-services

stow:
	stow --verbose --target=$$HOME --restow */

delete:
	stow --verbose --target=$$HOME --delete */

enable-services:
	@for svc in $(SERVICES); do \
		systemctl --user enable --now "$$svc"; \
	done

disable-services:
	@for svc in $(SERVICES); do \
		systemctl --user disable --now "$$svc"; \
	done
