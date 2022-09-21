
## >>>>>>>>>> STRUCTURE >>>>>>>>>>
SOURCES_DIRECTORY=src
OBJECTS_DIRECTORY=obj
BINARIES_DIRECTORY=bin
TESTS_DIRECTORY=tests
## <<<<<<<<<< STRUCTURE <<<<<<<<<<




## >>>>>>>>>> COMPILERS / LINKER >>>>>>>>>>
C_COMPILER=gcc
C_COMMON_FLAGS=-pedantic -Wall -Wextra -Werror
C_TESTS_FLAGS=$(C_COMMON_FLAGS)

ASSEMBLER=nasm
ASSEMBLER_FLAGS=-f elf64

LINKER_FLAGS=-lcriterion
## <<<<<<<<<< COMPILERS / LINKER <<<<<<<<<<




default: run-tests




## >>>>>>>>>> SOURCES >>>>>>>>>>
ASM_SOURCES=$(shell find $(SOURCES_DIRECTORY) -type f -name '*.nasm')
ASM_OBJECTS=$(subst $(SOURCES_DIRECTORY),$(OBJECTS_DIRECTORY),$(ASM_SOURCES:.nasm=.o))
## <<<<<<<<<< SOURCES <<<<<<<<<<

## >>>>>>>>>> SOURCE RULES >>>>>>>>>>
.PHONY: asm-objects
asm-objects: $(ASM_OBJECTS)
$(OBJECTS_DIRECTORY)/%.o: $(SOURCES_DIRECTORY)/%.nasm
	$(ASSEMBLER) $(ASSEMBLER_FLAGS) $^ -o $@ && strip --discard-all $@

.PHONY: clean-asm-objects
clean-asm-objects:
	find $(OBJECTS_DIRECTORY)/ -type f -name '*.o' | xargs rm -f
## <<<<<<<<<< SOURCE RULES <<<<<<<<<<




## >>>>>>>>>> TESTS >>>>>>>>>>
TESTS_SOURCES=$(shell find $(TESTS_DIRECTORY)/ -type f -name "*.c")
TESTS_OBJECTS=$(subst $(SOURCES_DIRECTORY),$(OBJECTS_DIRECTORY),$(TESTS_SOURCES:.c=.o))
TESTS_BINARIES=$(subst $(SOURCES_DIRECTORY),$(BINARIES_DIRECTORY),$(TESTS_SOURCES:.c=))
## <<<<<<<<<< TESTS <<<<<<<<<<

## >>>>>>>>>> TESTS RULES >>>>>>>>>>
.PHONY: tests-objects
tests-objects: asm-objects $(TESTS_OBJECTS)
$(TESTS_DIRECTORY)/$(OBJECTS_DIRECTORY)/%.o: $(TESTS_DIRECTORY)/$(SOURCES_DIRECTORY)/%.c
	$(C_COMPILER) $(C_TESTS_FLAGS) -c $^ -o $@

.PHONY: clean-tests-objects
clean-tests-objects:
	find $(TESTS_DIRECTORY)/ -type f -name '*.o' | xargs rm -f

.PHONY: tests-binaries
tests-binaries: tests-objects $(TESTS_BINARIES)
$(TESTS_DIRECTORY)/$(BINARIES_DIRECTORY)/%: $(OBJECTS_DIRECTORY)/%.o $(TESTS_DIRECTORY)/$(OBJECTS_DIRECTORY)/%.o
	$(C_COMPILER) $(LINKER_FLAGS) $^ -o $@

.PHONY: clean-tests-binaries
clean-tests-binaries:
	find $(TESTS_DIRECTORY)/ -type f -executable | xargs rm -f

.PHONY: run-tests
run-tests: tests-binaries
	@for TESTS_BINARY in $(TESTS_BINARIES); do ./$$TESTS_BINARY; done



#
# To remove when you're ready to start
#
## >>>>>>>>>> CHECK SETUP >>>>>>>>>>
.PHONY: setup-check
setup-check: $(TESTS_DIRECTORY)/$(BINARIES_DIRECTORY)/setup-check
	./$^ && echo "Setup works fine"
## <<<<<<<<<< CHECK SETUP <<<<<<<<<<


.PHONY: clean-all
clean-all: clean-asm-objects clean-tests-objects clean-tests-binaries
