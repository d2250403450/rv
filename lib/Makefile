INCLUDES := -I./ -I../ -I../inc/
%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

.PHONY: clean

all:  print.o printf.o kclock.o traps.o genex.o  syscall.o syscall_all.o getc.o string.o readline.o tool.o

clean:
	rm -rf *~ *.o


include ../include.mk
