*&---------------------------------------------------------------------*
*& Report ZBC100_SA01_COMPUTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA01_14.

PARAMETERS: pa_int1 TYPE i,
            pa_op   TYPE c,
            pa_int2 TYPE i.


DATA gv_result TYPE p LENGTH 16 DECIMALS 2.


PERFORM calc USING pa_int1 pa_op pa_int2
             CHANGING gv_result.



*&---------------------------------------------------------------------*
*& Form calc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM calc USING    VALUE(p_input1)
                   VALUE(p_opin)
                   VALUE(p_input2)
          CHANGING VALUE(p_result).

  CASE p_opin.
    WHEN '+'.
      p_result = p_input1 + p_input2.
      WRITE:'Result: '(res), p_result.

    WHEN '-'.
      p_result = p_input1 - p_input2.
      WRITE:'Result: '(res), p_result.

    WHEN '*'.
      p_result = p_input1 * p_input2.
      WRITE:'Result: '(res), p_result.

    WHEN '/'.
      IF pa_int2 is INITIAL. "Or pa_in2 = 0.
        WRITE 'Infinity. You cant put 0 in Bunmo'(t01).
        ELSE.
          p_result = p_input1 / p_input2.
          WRITE:'Result: '(res), p_result.

      ENDIF.
      WHEN OTHERS.
        WRITE 'Wrong Operation symbol do it again.'(t02).
  ENDCASE.

ENDFORM.
