CC = gcc
CFLAGS = -Wall -Wextra -std=gnu99 -Ivendor/lua
LUA_SRC = $(filter-out vendor/lua/lua.c vendor/lua/luac.c, $(wildcard vendor/lua/*.c))
LUA_OBJ = $(LUA_SRC:.c=.o)

kaku: src/kaku.c $(LUA_OBJ)
	$(CC) $(CFLAGS) src/kaku.c $(LUA_OBJ) -o kaku -lm -ldl

vendor/lua/%.o: vendor/lua/%.c
	$(CC) -O2 -std=gnu99 -DLUA_USE_LINUX -c $< -o $@

clean:
	rm -f kaku $(LUA_OBJ)
