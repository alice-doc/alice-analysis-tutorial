.PHONY: all serve test clean

all: test .gitbook_install
	@echo Building page
	@gitbook build
	@echo Checking for spurious .md files
	@if find _book -name '*.md' | grep -E '.*'; then echo I have found spurious .md files, please remove/rename them or add them to SUMMARY.md in case you forgot; exit 1; else echo All good, none found; exit 0; fi

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
