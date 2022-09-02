*&---------------------------------------------------------------------*
*& Report ZBC100_SA01_COMPUTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC100_SA01_COMPUTE.

PARAMETERS: pa_int1 TYPE i,
            pa_op   TYPE c,
            pa_int2 TYPE i.


DATA gv_result TYPE p LENGTH 16 DECIMALS 2.


CASE pa_op.
  WHEN '+'.
    gv_result = pa_int1 + pa_int2.
    WRITE:'Result: '(res), gv_result.
    CLEAR gv_result.
  WHEN '-'.
    gv_result = pa_int1 - pa_int2.
    WRITE:'Result: '(res), gv_result.
    CLEAR gv_result.
  WHEN '*'.
    gv_result = pa_int1 * pa_int2.
    WRITE:'Result: '(res), gv_result.
    CLEAR gv_result.
  WHEN '/'.
    IF pa_int2 is INITIAL. "Or pa_in2 = 0.
       WRITE 'Infinity. You cant put 0 in Bunmo'(t01).
    ELSE.
      gv_result = pa_int1 / pa_int2.
      WRITE:'Result: '(res), gv_result.
      CLEAR gv_result.
    ENDIF.
  WHEN OTHERS.
    WRITE 'Wrong Operation symbol do it again.'(t02).
ENDCASE.
