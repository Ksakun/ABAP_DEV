*&---------------------------------------------------------------------*
*& Report ZRCA01_BC100
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca01_02.
*구구단 출력하기

*DO 9 TIMES.
*  gv_lev = gv_lev + 1.
*  DO 9 TIMES.
*        gv_step = gv_step + 1.
*        gv_calc = gv_lev * gv_step.
*        WRITE: / gv_lev, ' * ' , gv_step,' = ', gv_calc.
*  ENDDO.
*  CLEAR: gv_calc, gv_step.
*  WRITE / '================================================'.
*  NEW-LINE.
*
*ENDDO.

* 단계를 입력하면 해당 단계까지 출력하기.

*DO p_req TIMES.
*  gv_lev = gv_lev + 1.
*  WRITE: gv_lev, '단'.
*  DO 9 TIMES.
*        gv_step = gv_step + 1.
*        gv_calc = gv_lev * gv_step.
*        WRITE: / gv_lev, ' * ' , gv_step,' = ', gv_calc.
*  ENDDO.
*  CLEAR: gv_calc, gv_step.
*  WRITE / '================================================'.
*  NEW-LINE.
*
*ENDDO.

*** 단계와 학년을 입력, 1학년은 최대 3단, 2학년은 최대 5단, 3학녀는 최대 7단, 4학년은 최대 9단, 5학년은 전체 출력.

PARAMETERS p_syear(1) TYPE c.
PARAMETERS p_req      TYPE i.
DATA: gv_step, gv_lev, gv_new_lev TYPE i.
DATA gv_calc TYPE int2.

CASE p_syear.
  WHEN '1' OR '2' OR '3' OR '4' OR '5' OR '6'.
    IF p_req >= 3.
      gv_new_lev = 3.
    ELSE.
      gv_new_lev = p_req.
    ENDIF.

  WHEN OTHERS.
    MESSAGE 'Message Test' TYPE 'I'.

ENDCASE.

WRITE 'Times Table'.
NEW-LINE.

DO gv_new_lev TIMES.
  gv_lev = gv_lev + 1.
  CLEAR gv_step.
  DO 9 TIMES.
    gv_step = gv_step + 1.
*    CLEAR gv_calc.
    gv_calc = gv_lev * gv_step.
    WRITE: gv_lev, ' * ', gv_step, ' = ', gv_calc.
    NEW-LINE.
  ENDDO.
  CLEAR: gv_step, gv_calc.
  WRITE '========================================'.
  NEW-LINE.
ENDDO.


*CASE p_syear.    "내 방법
*  WHEN '1'.
*   gv_new_lev = 3.
*   DO gv_new_lev TIMES.
*     gv_lev = gv_lev + 1.
*     WRITE: gv_lev, '단'.
*     DO 9 TIMES.
*        gv_step = gv_step + 1.
*        gv_calc = gv_lev * gv_step.
*        WRITE: / gv_lev, ' * ' , gv_step,' = ', gv_calc.
*     ENDDO.
*     CLEAR: gv_calc, gv_step.
*     WRITE / '================================================'.
*     NEW-LINE.
*    ENDDO.
*    CLEAR: gv_new_lev.
*  WHEN '2'.
*    gv_new_lev = 5.
*    DO gv_new_lev TIMES.
*     gv_lev = gv_lev + 1.
*     WRITE: gv_lev, '단'.
*     DO 9 TIMES.
*       gv_step = gv_step + 1.
*       gv_calc = gv_lev * gv_step.
*       WRITE: / gv_lev, ' * ' , gv_step,' = ', gv_calc.
*     ENDDO.
*     CLEAR: gv_calc, gv_step.
*     WRITE / '================================================'.
*     NEW-LINE.
*    ENDDO.
*    CLEAR: gv_new_lev,gv_calc, gv_step.
*  WHEN '3'.
*    gv_new_lev = 7.
*    DO gv_new_lev TIMES.
*     gv_lev = gv_lev + 1.
*     WRITE: gv_lev, '단'.
*     DO 9 TIMES.
*       gv_step = gv_step + 1.
*       gv_calc = gv_lev * gv_step.
*       WRITE: / gv_lev, ' * ' , gv_step,' = ', gv_calc.
*     ENDDO.
*     CLEAR: gv_calc, gv_step.
*     WRITE / '================================================'.
*     NEW-LINE.
*    ENDDO.
*    CLEAR: gv_new_lev,gv_calc, gv_step.
*  WHEN OTHERS.
*    IF p_syear >= 4.
*      gv_new_lev = 9.
*      DO gv_new_lev TIMES.
*         gv_lev = gv_lev + 1.
*          WRITE: gv_lev, '단'.
*          DO 9 TIMES.
*            gv_step = gv_step + 1.
*            gv_calc = gv_lev * gv_step.
*            WRITE: / gv_lev, ' * ' , gv_step,' = ', gv_calc.
*          ENDDO.
*          CLEAR: gv_calc, gv_step.
*      WRITE / '================================================'.
*      NEW-LINE.
*      ENDDO.
*      CLEAR: gv_new_lev,gv_calc, gv_step.
*    ELSEIF p_syear > 6.
*      WRITE 'Wrong grade number. Do it again!'.
*    ENDIF.
*ENDCASE.
