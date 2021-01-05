INCLUDES	:= -I./ -I../ -I../inc/ 

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

%.o: %.S
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

.PHONY: clean

all: pmap.o 

clean:
	rm -rf *~ *.o


include ../include.mk
