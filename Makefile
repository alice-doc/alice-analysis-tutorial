.PHONY: all serve test clean publish

all: test .gitbook_install
	@echo Building page
	@gitbook build

serve: all
	@echo Running GitBook web server
	@while true; do gitbook serve; sleep 5; done

.gitbook_install:
	@echo Installing GitBook dependencies
	@gitbook install
	@touch .gitbook_install

test:
	@echo Running unit tests
	@python -m unittest tests

clean:
	@echo Cleaning up
	@rm -rf _book node_modules .gitbook_install

publish: all
	@echo Publishing generated pages
	@./publish.sh
