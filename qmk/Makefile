# Builds firmware and draws images for all keyboards listed in qmk.json.
# See README.md.

QMK_VERSION := 0.34.6
QMK_IMAGE := ghcr.io/qmk/qmk_cli:1.2.0
KEYMAP_DRAWER_VERSION := 0.23.0

SHELL := bash

# A disposable cache, cloned by the setup target when needed.
QMK_FIRMWARE ?= $(HOME)/.cache/qmk_firmware
KEYMAP_DRAWER ?= uvx --from keymap-drawer==$(KEYMAP_DRAWER_VERSION) keymap

# name used in file names : QMK keyboard : directory with keymaps/
KEYBOARDS := \
	ergodox_ez:ergodox_ez/shine:ergodox_ez \
	moonlander:zsa/moonlander:zsa/moonlander \
	voyager:zsa/voyager:zsa/voyager
KEYMAP := juliusz

# Use a native QMK install if there is one (e.g. in CI), Docker otherwise.
ifeq ($(shell command -v qmk 2>/dev/null),)
QMK_RUN := docker run --rm \
	-v "$(QMK_FIRMWARE)":/qmk_firmware -v "$(CURDIR)":/qmk_userspace \
	-e QMK_HOME=/qmk_firmware -e QMK_USERSPACE=/qmk_userspace \
	-w /qmk_userspace $(QMK_IMAGE)
else
QMK_RUN := env QMK_HOME="$(QMK_FIRMWARE)" QMK_USERSPACE="$(CURDIR)"
endif

.PHONY: all setup build draw clean

all: build draw

# Clones qmk_firmware at QMK_VERSION into QMK_FIRMWARE, or moves an existing
# clone to that version. build and draw run it automatically.
setup:
	@if [ ! -d "$(QMK_FIRMWARE)" ]; then \
		git clone --depth 1 --branch $(QMK_VERSION) --recurse-submodules --shallow-submodules \
			https://github.com/qmk/qmk_firmware.git "$(QMK_FIRMWARE)"; \
	elif [ "$$(git -C "$(QMK_FIRMWARE)" describe --tags --exact-match 2>/dev/null)" != "$(QMK_VERSION)" ]; then \
		git -C "$(QMK_FIRMWARE)" fetch --depth 1 origin tag $(QMK_VERSION) && \
		git -C "$(QMK_FIRMWARE)" checkout $(QMK_VERSION) && \
		git -C "$(QMK_FIRMWARE)" submodule update --init --recursive --depth 1; \
	fi

build: setup
	$(QMK_RUN) qmk userspace-compile
	mkdir -p build/firmware
	mv -f *.hex *.bin build/firmware/

draw: setup
	mkdir -p build images
	@set -e; \
	layer_names=$$(sed -nE 's/^.define ([A-Z0-9_]+) [0-9]+$$/\1/p' users/$(KEYMAP)/layout.h); \
	for kb in $(KEYBOARDS); do \
		IFS=: read -r name qmk_kb keymaps_dir <<< "$$kb"; \
		echo "Drawing $$name"; \
		$(QMK_RUN) sh -ec "cpp -P -I users/$(KEYMAP) -DQMK_KEYBOARD_H='\"/dev/null\"' \
			keyboards/$$keymaps_dir/keymaps/$(KEYMAP)/keymap.c > build/$$name.c; \
			qmk c2json --no-cpp -q -kb $$qmk_kb -km $(KEYMAP) build/$$name.c -o build/$$name.json"; \
		$(KEYMAP_DRAWER) -c keymap-drawer.yaml parse -q build/$$name.json \
			--layer-names $$layer_names > build/$$name.yaml; \
		$(KEYMAP_DRAWER) -c keymap-drawer.yaml draw build/$$name.yaml > images/$$name.svg; \
	done

clean:
	rm -rf build .build
