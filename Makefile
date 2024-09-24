prefix ?= /usr/local
bindir = $(prefix)/bin

.PHONY: build build_debug install install_debug uninstall clean format

build_debug:
	swift build --product bump -c debug --disable-sandbox
	
build:
	swift build --product bump -c release --disable-sandbox

test:
	swift test --enable-swift-testing

install_debug: build_debug
	install ".build/debug/bump" "$(bindir)"
		
install: build
	install ".build/release/bump" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/bump"

format:
	swiftlint . --autocorrect

lint:
	swiftlint . --strict

lint_ci:
	swiftlint . --strict --reporter github-actions-logging

lint_unused_code:
	periphery scan --relative-results --strict

clean:
	rm -rf .build

setup:
	brew install swiftlint
	brew install periphery
	brew install xcbeautify