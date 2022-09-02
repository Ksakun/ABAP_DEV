*&---------------------------------------------------------------------*
*& Report ZRSA01_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_08.

PARAMETERS pa_code TYPE c LENGTH 4 DEFAULT 'SYNC'.
PARAMETERS pa_date TYPE sy-datum.


DATA: gv_cond_d1 LIKE pa_date,
      gv_cond_d2 LIKE pa_date,
      gv_cond_d3 LIKE pa_date.


gv_cond_d1 = sy-datum + 7.
gv_cond_d2 = sy-datum - 7.
gv_cond_d3 = sy-datum + 365.


CASE pa_code.
  WHEN 'SYNC'.
    IF pa_date BETWEEN gv_cond_d3 and gv_cond_d1.
      WRITE TEXT-t02.
    ELSEIF pa_date < gv_cond_d2.
      WRITE TEXT-t03.
    ELSEIF pa_date >= gv_cond_d3.
      WRITE '취업'(t04).
    ELSEIF pa_date = '20220620'.
      WRITE '교육 준비중'(t05).
    ELSE.
      WRITE: TEXT-t01.
    ENDIF.
  WHEN OTHERS.
    WRITE '다음기회에'.
ENDCASE.
