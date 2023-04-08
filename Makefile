prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	mv ".build/release/ParseReport" ".build/release/parse"
	install ".build/release/parse" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/parse"

clean:
	rm -rf .build

.PHONY: build install uninstall clean