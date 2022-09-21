
#include <criterion/criterion.h>




extern void roll(int);
extern int score(void);
extern void init_game(void);




Test(bowling, initial_score_is_0, .init=init_game)
{
	// given no throws made so far

	// when checking the score
	int initialScore = score();

	// then it should be 0
	cr_assert_eq(
		0,
		initialScore,
		"Initial score should be 0, got %d", initialScore
	);
}


Test(bowling, knocking_1_pin_gives_1_point, .init=init_game)
{
	// given 1 pin knocked down
	roll(1);

	// when checking the score
	int currentScore = score();

	// then it should be 1
	cr_assert_eq(
		1,
		currentScore,
		"Knocked pin should give 1 point, got %d", currentScore
	);
}


Test(bowling, alley_contains_at_most_10_pins, .init=init_game)
{
	// given a try to knock more pins than how many are on the alley
	roll(11);

	// when checking how many pins were considered
	int maxPinsOnTheAlley = score();

	// then there should be only 10
	cr_assert_eq(
		10,
		maxPinsOnTheAlley,
		"There should be at most 10 pins on the alley, got %d", maxPinsOnTheAlley
	);
}


Test(bowling, minimum_knocked_pins_count_is_0, .init=init_game)
{
	// given an initial score
	int initialScore = score();

	// when trying to knock a negative amount of pins
	roll(-1);

	// then score should have been affected
	cr_assert_eq(
		initialScore,
		score(),
		"Negative knocked pins shouldn't affect the score"
	);
}


Test(bowling, maximum_knocked_pins_per_frame_is_10, .init=init_game)
{
	// given 2 throws in the same frame, trying to knock more pins than the limit
	roll(5);
	roll(6);

	// when checking how many pins were considered
	int knocksLimitPerFrame = score();

	// then there should be only 10
	cr_assert_eq(
		10,
		knocksLimitPerFrame,
		"There should be only 10 pins per frame, got %d", knocksLimitPerFrame
	);
}


Test(bowling, a_new_frame_starts_after_2_throws, .init=init_game)
{
	// given 2 throws so far
	roll(3);
	roll(4);

	// when checking how many pins are in the alley for throw 3
	int scoreAfterThrow2 = score();
	roll(10);
	int pinsAvailableForThrow3 = score() - scoreAfterThrow2;

	// then it should be the initial number of pins
	cr_assert_eq(
		pinsAvailableForThrow3,
		10,
		"The 10 pins should be back on the alley after 2 trows, found %d", pinsAvailableForThrow3
	);
}
