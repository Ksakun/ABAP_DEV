*&---------------------------------------------------------------------*
*& Report ZRSA01_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA01_09.

DATA gv_d TYPE sy-datum.

gv_d = sy-datum - 365.
clear gv_d.
IF gv_d is INITIAL.
  WRITE 'No Date'.
ELSE.
  WRITE 'Exist Date'.
ENDIF.

*DO 10 TIMES.
*  gv_cnt = gv_cnt + 1.
*  WRITE sy-index.
*  DO 5 TIMES.
*    WRITE sy-index.
*  ENDDO.
*  NEW-LINE.
*ENDDO.
