*&---------------------------------------------------------------------*
*& Include MZSA0104_TOP                             - Module Pool      SAPMZSA0104
*&---------------------------------------------------------------------*
PROGRAM SAPMZSA0104.

DATA: ok_code TYPE sy-ucomm,
      gv_subrc TYPE sy-subrc,
      gv_dynnr TYPE sy-dynnr.


TABLES: zssa0073,"Condition
        zssa0070,"Emp Info
        zssa0071."Dep Info

CONTROLS ts_info TYPE TABSTRIP.
