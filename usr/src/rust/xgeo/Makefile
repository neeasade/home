PREFIX  = /usr/local
BINPATH = $(PREFIX)/bin
BIN     = xgeo

build:
	@rustc --crate-type bin --crate-name $(BIN) xgeo.rs

install:
	@cp $(BIN) $(DESTDIR)/$(BINPATH)/$(BIN)
	@echo done!

uninstall:
	@rm -f $(DESTDIR)/$(BINPATH)/$(BIN)

clean:
	@rm -f $(BIN)

.PHONY: install clean uninstall build
