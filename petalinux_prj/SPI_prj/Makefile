# Makefile
CC = gcc
CFLAGS = -Wall -fPIC
LDFLAGS = -shared
# EXEC = my_program

# List of source files
SRC = hal_spi.c
OBJ = $(SRC:.c=.o)
LIB = afe5808_lib.so

# Targets
all: $(LIB)

$(LIB): $(OBJ)
	$(CC) $(LDFLAGS) -o $(LIB) $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(LIB)
