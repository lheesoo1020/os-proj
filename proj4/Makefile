CC=gcc
CFLAGS=-o
TARGETS=reader_prefer_cond writer_prefer_mutex writer_prefer_cond fair_reader_writer_mutex
all: $(TARGETS)

.PHONY: all
%:
	$(CC) -o $@ $@.c 
       
clean:
	rm $(TARGETS)
 