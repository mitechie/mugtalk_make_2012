rst2html := /usr/local/bin/rst2html.py
easy_install := /usr/local/bin/easy_install
INPUT := mugtalk_make_2012/readme.rst
OUTPUT := mugtalk.html


mugtalk_make_2012: /usr/bin/git
	git clone https://github.com/mitechie/mugtalk_make_2012.git

/usr/bin/git:
	sudo apt-get install git

$(rst2html):
	sudo easy_install rst2html

$(easy_install):
	sudo apt-get install python-setuptools

$(INPUT): $(rst2html) $(easy_install) mugtalk_make_2012

$(OUTPUT): $(INPUT)
	$(rst2html) $(INPUT)  > $(OUTPUT)

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
	rm mugtalk.html

.PHONY: clean-talk
clean-talk:
	rm -rf $(OUTPUT)
