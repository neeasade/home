PREFIX  = /usr/local
BINPATH = $(PREFIX)/bin
BIN     = tsz

SRC     = tsz.c
OBJ     = tsz.o
CC      = clang

build:
	@$(CC) -c $(SRC) -o $(OBJ)
	@$(CC) $(OBJ) -o $(BIN)

clean:
	@rm -f *.o $(BIN)

install: build
	@cp tsz $(DESTDIR)/$(BINPATH)/$(BIN)
	@echo installed!

uninstall: install
	@rm $(DESTDIR)/$(BINPATH)/$(BIN)
	@echo uninstalled!

.PHONY: build install uninstall clean
