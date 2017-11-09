.PHONY: all clean serve publish

all: node_modules
	gitbook build

serve: all
	while true; do gitbook serve; sleep 5; done

node_modules:
	gitbook install

clean:
	@rm -rf _book
	@rm -rf node_modules

publish: all
	@./publish.sh
