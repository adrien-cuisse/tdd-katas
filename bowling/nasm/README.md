
# What is it ?

NASM implementation of the Bowling Game kata, inspired by Uncle Bob
Tests are written in C, but production code in assembler, because why not ?

The requirements of the kata is available here:
https://kata-log.rocks/bowling-game-kata

# Requirements to build & run
- x64 Linux environment
- NASM
- Criterion C testing library

# Build & run

## Init directories
```
mkdir -p ./{,tests/}{obj,bin}
```

## Checking setup
```
make setup-check
```

## Running the tests
```
make
```
The default Makefile rule is to run unit-tests, dependencies trigger re-compilation if necessary

## Final notes
### How to TDD
- Write your tests first, so you place yourself as a user, and will write the most user-friendly code,
- If a test is hard to write, there's either a design problem, or you're trying to test too many things at once,
- Proceed step by step, don't try to solve the whole problem in a single algorithm.
### Production code coupling
If you write tests on how errors ARE handled (exceptions, values clamping), when for example:
- we try to knock down more pins than are available,
- we try to knock a negative amount of pins,
- we try to play more than 10 frames,
Those tests will be bound to implementation, and will break when implementation changes, while
behavior ones won't.
Those wouldn't be behavior specifications, but implementation details, and TDD
is about testing behavior.
### Refactoring
If production code grows too big, you may refactor it into smaller functions, but not split your tests to
target those new smaller components, that would lead to coupling your tests to your production code.
TDD is all about the opposite: production code and test code must evolve in opposite directions.

#### Unit testing has nothing to do with unit size, a unit could be a function, or a couple of classes working together.
