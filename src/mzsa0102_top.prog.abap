*&---------------------------------------------------------------------*
*& Include MZSA0102_TOP                             - Module Pool      SAPMZSA0102
*&---------------------------------------------------------------------*
PROGRAM sapmzsa0102.

"Local
*DATA: BEGIN OF gs_cond,
*        carrid TYPE sflight-carrid,
*        connid TYPE sflight-connid,
*      END OF gs_cond.


"Condition / Global
"Used in Screen
TABLES: zssa0160.
"Used in ABAP
DATA gs_cond TYPE zssa0160.
DATA ok_code TYPE sy-ucomm.
