PREFIX  = /usr/local
BINPATH = $(PREFIX)/bin
BIN     = xgeo

build:
	@rustc --crate-type bin --crate-name $(BIN) xgeo.rs

install: build
	@cp $(BIN) $(DESTDIR)/$(BINPATH)/$(BIN)
	@echo done!

uninstall: build
	@rm -f $(DESTDIR)/$(BINPATH)/$(BIN)

clean: build
	@rm -f $(BIN)

.PHONY: install clean uninstall build
