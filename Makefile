SERVICES := $(notdir $(wildcard systemd/.config/systemd/user/*.service))

all: stow enable-services

stow:
	stow --verbose --target=$$HOME --restow */

delete:
	stow --verbose --target=$$HOME --delete */

enable-services:
	@if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then \
		for svc in $(SERVICES); do \
			systemctl --user enable --now "$$svc"; \
		done; \
	else \
		echo "systemd not running, skipping service enable"; \
	fi

disable-services:
	@if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then \
		for svc in $(SERVICES); do \
			systemctl --user disable --now "$$svc"; \
		done; \
	else \
		echo "systemd not running, skipping service disable"; \
	fi
