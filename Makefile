INPUT := mugtalk_make_2012/readme.rst
OUTPUT := mugtalk.html
JSFILES := $(wildcard ls mugtalk_make_2012/jsexample/*.js)
JSBUILD := mugtalk_make_2012/build
BUILD_JSFILES := $(patsubst mugtalk_make_2012/jsexample/%.js,mugtalk_make_2012/build/%.js,$(JSFILES))
MIN_JSFILES := $(patsubst $(JSBUILD)/%.js,$(JSBUILD)/%-min.js,$(JSFILES))

define dep_targets
  git
  python-setuptools
endef

.PHONY: deps
deps:
	sudo apt-get install $(strip $(dep_targets))

.PHONY: deps-python
deps-python: $(EASY_INSTALL)
	sudo easy_install docutils lpjsmin watchdog

.PHONY: talk
talk: $(INPUT)

$(INPUT): deps
	git clone https://github.com/mitechie/mugtalk_make_2012.git

$(OUTPUT): $(INPUT) deps-python
	rst2html.py $(INPUT)  > $(OUTPUT)

.PHONY: open
open: $(OUTPUT)
	xdg-open $(OUTPUT)

.PHONY: js
js:
	echo $(JSFILES)
	echo $(BUILD_JSFILES)


$(JSBUILD):
	mkdir $@

$(BUILD_JSFILES): $(JSBUILD)
	mkdir -p  $<
	cp $(JSFILES) $<

$(MIN_JSFILES): $(BUILD_JSFILES)

.PHONY: jsmin
jsmin: $(MIN_JSFILES)
	- rm $(JSBUILD)/*-min*
	lpjsmin --path $(JSBUILD)

jsauto: $(BUILD_JSFILES)
	watchmedo shell-command \
    --patterns="*.js" \
    --recursive \
    --command='make jsmin' \
    mugtalk_make_2012/jsexample

.PHONY: clean
clean: clean-deps clean-js clean-talk clean-html

.PHONY: clean-git
clean-deps:
	sudo apt-get remove $(strip $(dep_targets))

.PHONY: clean-html
clean-html:
	- rm $(OUTPUT)

.PHONY: clean-talk
clean-talk:
	rm -rf mugtalk_make_2012

.PHONY: clean-js
clean-js:
	- rm -rf $(JSBUILD)
