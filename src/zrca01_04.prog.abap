*&---------------------------------------------------------------------*
*& Report ZRCA01_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRCA01_04.

PARAMETERS pa_car TYPE scarr-carrid.

DATA gs_info TYPE scarr. "gs: global structure

CLEAR gs_info.
SELECT SINGLE carrid carrname
  FROM scarr "INTO CORRESPONDING FIELDS OF gs_info
  INTO gs_info
 WHERE carrid = pa_car.

IF sy-subrc = 0.
  WRITE: gs_info-mandt, gs_info-carrid, gs_info-carrname.
ELSE.
  MESSAGE 'No such ID in table, Do it again!' TYPE 'I'.
ENDIF.
