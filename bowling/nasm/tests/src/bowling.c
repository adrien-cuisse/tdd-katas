
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


Test(bowling, strike_ends_the_frame, .init=init_game)
{
	// given a strike
	roll(10);
	int scoreAfterStrike = score();

	// when making another throw
	roll(1);

	// then pins should have been available for throw 2, and new points be counted
	cr_assert_gt(
		score(),
		scoreAfterStrike,
		"The 10 pins should be back on the alley after a strike"
	);
}

Test(bowling, spare_gives_next_roll_as_bonus_points, .init=init_game)
{
	// given a spare
	roll(4);
	roll(6);

	// when making a 3rd roll
	int scoreAfterSpare = score();
	roll(7);
	int pointsFromRoll3 = score() - scoreAfterSpare;

	// then the 3rd roll should give twice as many points as usual
	cr_assert_eq(
		7 * 2,
		pointsFromRoll3,
		"Roll right after a spare should give twice as many points, got %d instead of 14",  pointsFromRoll3
	);
}

Test(bowling, strike_gives_next_2_next_roll_as_bonus_points, .init=init_game)
{
	// given a strike
	roll(10);

	// when making 2 extra rolls
	roll(3);
	roll(4);
	int scoreAfterBonusRolls = score();
	// then the 2 next rolls should give twice as many points as usual
	cr_assert_eq(
		24,
		scoreAfterBonusRolls,
		"Rolls right after strike should give twice as many points, got %d instead of 24", scoreAfterBonusRolls
	);
}

Test(bowling, game_lasts_10_frames, .init=init_game)
{
	// given 21 throws
	for (int throws = 0; throws < 21; throws++)
		roll(1);

	// when checking the total score
	int totalScore = score();

	// then only 10 frames should be included
	cr_assert_eq(
		20,
		totalScore,
		"Game must last 10 frames only, was able to score %d", totalScore
	);
}
