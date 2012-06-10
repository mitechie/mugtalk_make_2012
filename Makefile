RST2HTML := /usr/local/bin/rst2html.py
EASY_INSTALL := /usr/local/bin/easy_install
INPUT := mugtalk_make_2012/readme.rst
OUTPUT := mugtalk.html


mugtalk_make_2012: /usr/bin/git
	git clone https://github.com/mitechie/mugtalk_make_2012.git

/usr/bin/git:
	sudo apt-get install git

$(RST2HTML): $(easy_install)
	sudo easy_install docutils

$(EASY_INSTALL):
	sudo apt-get install python-setuptools

$(INPUT): $(RST2HTML) $(EASY_INSTALL) mugtalk_make_2012

$(OUTPUT): $(INPUT)
	$(RST2HTML) $(INPUT)  > $(OUTPUT)

.PHONY: open
open: $(OUTPUT)
	xdg-open $(OUTPUT)

.PHONY: clean
clean: clean-git clean-talk clean-html

.PHONY: clean-git
clean-git:
	sudo apt-get remove git

.PHONY: clean-html
clean-html:
	if [ -f $(OUTPUT) ]; then \
		rm $(OUTPUT); \
	fi

.PHONY: clean-talk
clean-talk:
	rm -rf mugtalk_make_2012
