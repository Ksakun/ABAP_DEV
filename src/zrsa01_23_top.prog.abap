*&---------------------------------------------------------------------*
*& Include ZRSA01_23_TOP                            - Report ZRSA01_23
*&---------------------------------------------------------------------*
REPORT zrsa01_23.



"Schedule Date Info

DATA: gt_info TYPE TABLE OF zsinfo00,
      gs_info LIKE LINE OF gt_info.

PARAMETERS: pa_car TYPE sbook-carrid,
            pa_con TYPE  sbook-connid .
