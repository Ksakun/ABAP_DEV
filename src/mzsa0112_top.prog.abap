*&---------------------------------------------------------------------*
*& Include MZSA0112_TOP                             - Module Pool      SAPMZSA0112
*&---------------------------------------------------------------------*
PROGRAM SAPMZSA0112.

DATA: ok_code TYPE sy-ucomm,
      gv_subrc TYPE sy-subrc,
      gv_dynnr TYPE sy-dynnr.

TABLES: zssa0180, "Condition
        zssa0181, "Get Airline info
        zssa0182. "Get Connetcion Info

CONTROLS ts_info TYPE TABSTRIP.
