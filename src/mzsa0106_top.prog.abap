*&---------------------------------------------------------------------*
*& Include MZSA0104_TOP                             - Module Pool      SAPMZSA0104
*&---------------------------------------------------------------------*
PROGRAM SAPMZSA0104.

DATA ok_code TYPE sy-ucomm.

"Condition
TABLES ZSSA0073.
DATA gs_cond TYPE zssa0073.

"Emp Info
TABLES zssa0070.
DATA gs_emp TYPE ZSSA0070.

"Dep Info
TABLES zssa0071.
DATA gs_dep TYPE zssa0071.

DATA: gv_r1 TYPE c,
      gv_r2(1),
      gv_r3.
