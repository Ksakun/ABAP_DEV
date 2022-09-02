*&---------------------------------------------------------------------*
*& Report ZRSA01_11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA01_11.

DATA: gv_a TYPE sy-datum,
      gv_b LIKE gv_a,
      gv_c LIKE gv_a,
      gv_d LIKE gv_a.


PERFORM cal_date USING sy-datum '7'
                 CHANGING gv_a.


PERFORM cal_date USING sy-datum '14'
                 CHANGING gv_b.

PERFORM cal_date_new USING sy-datum '21'
                 CHANGING gv_c.

PERFORM cal_date USING sy-datum '28'
                 CHANGING gv_d.



PERFORM display_info.
  WRITE:/ gv_a, / gv_b, / gv_c, / gv_d. "이줄을 subroutine 으로 만들고 싶다

FORM display_info.
  WRITE:/ gv_a, / gv_b, / gv_c, / gv_d.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form cal_date
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*


FORM cal_date USING    VALUE(p_date)
                       VALUE(p_days)
              CHANGING VALUE(p_new_date).
  p_new_date = p_date + p_days.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form cal_date_new
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_DATUM
*&      --> P_
*&      <-- GV_C
*&---------------------------------------------------------------------*
FORM cal_date_new  USING    p_datum
                      VALUE(p_days)
                   CHANGING p_new_date.

  p_new_date = p_datum + p_days.
ENDFORM.
