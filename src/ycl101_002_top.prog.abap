*&---------------------------------------------------------------------*
*& Include YCL101_002_TOP                           - Module Pool      YCL101_002
*&---------------------------------------------------------------------*
PROGRAM YCL101_002 MESSAGE-ID zmcsa01.

TABLES: scarr.

DATA: ok_code TYPE sy-ucomm,
      save_ok TYPE sy-ucomm.


DATA: gt_data TYPE TABLE OF scarr,
      gs_data TYPE scarr.
