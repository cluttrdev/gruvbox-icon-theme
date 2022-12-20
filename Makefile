
SOURCE_DIR := src
BUILD_DIR := build

INSTALL_DIR := /usr/share/icons

MODE?=dark
ACCENT?=green

render:
	@echo "Rendering $(MODE) $(ACCENT) icons..."
	@$(SOURCE_DIR)/render_icons.sh -s $(SOURCE_DIR) -b $(BUILD_DIR) -m $(MODE) -c $(ACCENT) > /dev/null 2>&1 ; \

render-all:
	@mkdir -p $(BUILD_DIR)
	@for mode in dark light ; do \
		for accent in red green yellow blue purple aqua orange ; do \
			echo "Rendering $$mode $$accent icons..." ; \
			$(SOURCE_DIR)/render_icons.sh -s $(SOURCE_DIR) -b $(BUILD_DIR) -m $$mode -c $$accent > /dev/null 2>&1 ; \
		done ; \
	done

install:
	cp -r $(BUILD_DIR)/* $(INSTALL_DIR)

.PHONY: render-all install
