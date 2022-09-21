
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
