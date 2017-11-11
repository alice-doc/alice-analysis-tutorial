.PHONY: all serve test clean publish

all: test node_modules
	gitbook build

serve: all
	while true; do gitbook serve; sleep 5; done

node_modules:
	gitbook install

test:
	@python -m unittest tests

clean:
	@rm -rf _book node_modules

publish: all
	@./publish.sh
