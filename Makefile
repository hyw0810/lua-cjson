CJSON_VERSION = 1.0
LUA_VERSION =   5.1

PREFIX ?=          /usr/local
LUA_INCLUDE_DIR ?= $(PREFIX)/include
LUA_LIB_DIR ?=     $(PREFIX)/lib/lua/$(LUA_VERSION)

#CFLAGS ?=          -g -Wall -pedantic -fno-inline
CFLAGS ?=          -g -O2 -Wall -pedantic
override CFLAGS += -fpic -I$(LUA_INCLUDE_DIR) -DVERSION=\"$(CJSON_VERSION)\"
LDFLAGS +=         -shared -lm

INSTALL ?= install

.PHONY: all clean install package

all: cjson.so

cjson.so: lua_cjson.o strbuf.o
	$(CC) $(LDFLAGS) -o $@ $^

install:
	$(INSTALL) -d $(DESTDIR)/$(LUA_LIB_DIR)
	$(INSTALL) cjson.so $(DESTDIR)/$(LUA_LIB_DIR) 

clean:
	rm -f *.o *.so

package:
	git archive --prefix="lua-cjson-$(CJSON_VERSION)/" master | \
		gzip -9 > "lua-cjson-$(CJSON_VERSION).tar.gz"