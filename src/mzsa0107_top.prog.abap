*&---------------------------------------------------------------------*
*& Include MZSA0107_TOP                             - Module Pool      SAPMZSA0107
*&---------------------------------------------------------------------*
PROGRAM SAPMZSA0107.

DATA ok_code lIKE sy-ucomm.
DATA: gv_carrid TYPE sflight-carrid,
      gv_connid TYPE sflight-connid.
TABLES: zssa0174.
