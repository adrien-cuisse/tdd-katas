
#include <criterion/criterion.h>

extern int answer_to_life(void);




Test(setup, criterion_loaded)
{
	cr_expect_eq(0xc0ff33, 0xc0ff33);
}


Test(setup, calling_assembly)
{
	int actual = answer_to_life();

	cr_assert_eq(
		actual,
		42,
		"Wrong value return from assembly"
	);
}
