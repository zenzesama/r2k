CC = gcc
CFLAGS = -Wall -Wextra -Wswitch -pedantic -std=c99
SRC = src/kaku.c
BIN = kaku

$(BIN): $(SRC)
	$(CC) $(CFLAGS) -o $(BIN) $(SRC)

clean:
	rm -f $(BIN)

.PHONY: clean
