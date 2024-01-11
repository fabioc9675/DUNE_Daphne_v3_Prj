# Makefile
CC = gcc
CFLAGS = -Wall
EXEC = my_program

# List of source files
SRC = main.c sum.c
OBJ = $(SRC:.c=.o)

# Targets
all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) $(OBJ) -o $(EXEC)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(EXEC)
