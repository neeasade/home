PREFIX  = /usr/local
BINPATH = $(PREFIX)/bin
BIN     = lf

build:
	@rustc --crate-type bin --crate-name $(BIN) lf.rs

install: build
	@cp $(BIN) $(DESTDIR)/$(BINPATH)/$(BIN)
	@echo done!

uninstall: install
	@rm -f $(DESTDIR)/$(BINPATH)/$(BIN)

clean: build
	@rm -f $(BIN)

.PHONY: install clean build uninstall
