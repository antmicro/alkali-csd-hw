CC ?= gcc

all:  reg_rw_hc 

reg_rw_hc: reg_rw_hc.o
	$(CC) -o $@ $<

	$(CC) -shared -g -o reg_rw_hc.so -fPIC reg_rw_hc.c 
	$(CC) -shared -g -o libScyllaTest.so -fPIC ScyllaTest.c

%.o: %.c
	$(CC) -g -c -std=c99 -o $@ $< -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -D_LARGE_FILE_SOURCE

clean:
	rm -rf  *.o *.so *.bin reg_rw_hc  

