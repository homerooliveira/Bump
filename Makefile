install:
	swift build -c release --disable-sandbox
	install .build/release/bump /usr/local/bin/bump
uninstall:
	rm -rf /usr/local/bin/bump
