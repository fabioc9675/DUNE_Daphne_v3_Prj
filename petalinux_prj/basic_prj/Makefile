# Makefile
CC = gcc
CFLAGS = -Wall -fPIC
LDFLAGS = -shared
# EXEC = my_program

# List of source files
SRC = sum.c my_c_function.c
OBJ = $(SRC:.c=.o)
LIB = libmylibrary.so

# Targets
all: $(LIB)

$(LIB): $(OBJ)
	$(CC) $(LDFLAGS) -o $(LIB) $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(LIB)
