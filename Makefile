prefix ?= /usr/local
bindir = $(prefix)/bin

.PHONY: build build_debug install install_debug uninstall clean format

build_debug:
	swift build --product bump -c debug --disable-sandbox
	
build:
	swift build --product bump -c release --disable-sandbox

install_debug: build_debug
	install ".build/debug/bump" "$(bindir)"
		
install: build
	install ".build/release/bump" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/bump"

format:
	swiftlint autocorrect

lint:
	swiftlint lint --quiet

clean:
	rm -rf .build
