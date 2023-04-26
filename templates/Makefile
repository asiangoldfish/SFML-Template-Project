# Compiler settings
CC = g++
CFLAGS = -Wall -Wextra -pedantic -std=c++11

# SFML settings
SFML_LIBS = -lsfml-graphics -lsfml-window -lsfml-system
SFML_INCLUDES = -I/usr/include/SFML

# Project files
SRCS = $(shell find . -type f -name "*.cpp")
OBJS = $(SRCS:.cpp=.o)
EXEC = game

# Default target
all: $(EXEC)

# Link object files into executable
$(EXEC): $(OBJS)
	$(CC) $(OBJS) -o $(EXEC) $(SFML_LIBS)

# Compile object files
%.o: %.cpp
	$(CC) -c $(CFLAGS) $< -o $@ $(SFML_INCLUDES)

# Clean up object files and executable
clean:
	rm -f $(OBJS) $(EXEC)
