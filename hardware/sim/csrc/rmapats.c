#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

scalar dummyScalar;
scalar fScalarIsForced=0;
scalar fScalarIsReleased=0;
scalar fScalarHasChanged=0;
void  hsG_0(struct dummyq_struct * I784, EBLK  * I785, U  I567);
void  hsG_0(struct dummyq_struct * I784, EBLK  * I785, U  I567)
{
    U  I975;
    U  I976;
    U  I977;
    struct futq * I978;
    I975 = ((U )vcs_clocks) + I567;
    I977 = I975 & 0xfff;
    I785->I503 = (EBLK  *)(-1);
    I785->I513 = I975;
    if (I975 < (U )vcs_clocks) {
        I976 = ((U  *)&vcs_clocks)[1];
        sched_millenium(I784, I785, I976 + 1, I975);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I567 == 1)) {
        I785->I514 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I503 = I785;
        peblkFutQ1Tail = I785;
    }
    else if ((I978 = I784->I753[I977].I520)) {
        I785->I514 = (struct eblk *)I978->I519;
        I978->I519->I503 = (RP )I785;
        I978->I519 = (RmaEblk  *)I785;
    }
    else {
        sched_hsopt(I784, I785, I975);
    }
}
U   hsG_1(U  I798);
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
