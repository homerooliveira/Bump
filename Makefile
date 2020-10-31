prefix ?= /usr/local
bindir = $(prefix)/bin

.PHONY: build build_debug install install_debug uninstall clean

build_debug:
	swift build -c debug --disable-sandbox
	
build:
	swift build -c release --disable-sandbox

install_debug: build_debug
		install ".build/debug/bump" "$(bindir)"
		
install: build
	install ".build/release/bump" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/bump"

clean:
	rm -rf .build

bump_formula:
	@./.scripts/bump_formula.sh