PREFIX  = $(HOME)/usr/local
BINPATH = $(PREFIX)/bin
BIN     = grad

build:
	@raco exe -o $(BIN) --vv -- grad.rkt

install:
	@cp $(BIN) $(DESTDIR)/$(BINPATH)/$(BIN)

uninstall: build
	@rm $(DESTDIR)/$(BINPATH)/$(BIN)

clean:
	@rm $(BIN)

test:
	@racket grad.rkt

.PHONY: install clean build
