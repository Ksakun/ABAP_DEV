*&---------------------------------------------------------------------*
*& Include MZSA0150_TOP                             - Module Pool      SAPMZSA0150
*&---------------------------------------------------------------------*
PROGRAM SAPMZSA0150.

DATA: ok_code TYPE sy-ucomm,
      gv_subrc TYPE sy-subrc,
      gv_dynnr TYPE sy-dynnr.

"Radio Button
DATA: gv_r1 TYPE c,
      gv_r2 TYPE c.

TABLES: zssa0150, "Condition
        zssa0151, "Meal Info
        zssa0152. "Vendor Info

CONTROLS ts_info TYPE TABSTRIP.
