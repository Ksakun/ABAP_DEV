*&---------------------------------------------------------------------*
*& Include ZRSA01_90_TOP                            - Report ZRSA01_90
*&---------------------------------------------------------------------*
REPORT ZRSA01_90.

TABLES ztsa0199.
PARAMETERS pa_car TYPE scarr-carrid.
SELECT-OPTIONS so_meal FOR ztsa0199-mealnumber.
PARAMETERS pa_venca TYPE ztsa0199-venca as LISTBOX VISIBLE LENGTH 20.


DATA: ok_code TYPE sy-ucomm,
      gs_data LIKE zssa0192,
      gt_data LIKE TABLE OF gs_data.
