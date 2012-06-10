INPUT := mugtalk_make_2012/readme.rst
OUTPUT := mugtalk.html

define dep_targets
  git
  python-setuptools
endef

deps:
	sudo apt-get install $(strip $(dep_targets))

deps-python: $(EASY_INSTALL)
	sudo easy_install docutils lpjsmin

mugtalk_make_2012: deps
	git clone https://github.com/mitechie/mugtalk_make_2012.git

$(INPUT): mugtalk_make_2012

$(OUTPUT): $(INPUT) deps-python
	rst2html $(INPUT)  > $(OUTPUT)

.PHONY: open
open: $(OUTPUT)
	xdg-open $(OUTPUT)

.PHONY: clean
clean: clean-deps clean-talk clean-html

.PHONY: clean-git
clean-deps:
	sudo apt-get remove $(strip $(dep_targets))

.PHONY: clean-html
clean-html:
	if [ -f $(OUTPUT) ]; then \
		rm $(OUTPUT); \
	fi

.PHONY: clean-talk
clean-talk:
	rm -rf mugtalk_make_2012
