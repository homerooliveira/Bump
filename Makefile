prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox
	
install: build
	install ".build/release/bump" "$(bindir)"
	
uninstall:
	rm -rf "$(bindir)/bump"
	
clean:
	rm -rf .build

.PHONY: build install uninstall clean
