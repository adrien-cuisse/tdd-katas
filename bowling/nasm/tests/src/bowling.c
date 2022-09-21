
#include <criterion/criterion.h>




extern void roll(int);
extern int score(void);




Test(bowling, initial_score_is_0)
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


Test(bowling, knocking_1_pin_gives_1_point)
{
	// given 1 pin knocked down
	roll(1);

	// when checking the score
	int currentScore = score();

	// then the total score should be 1
	cr_assert_eq(
		1,
		currentScore,
		"Knocked pin should give 1 point, got %d", currentScore
	);
}
