*&---------------------------------------------------------------------*
*& Include          YCL101_001_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: s_carr  FOR gs_scarr-carrid,
                  s_name  FOR scarr-carrname.

SELECTION-SCREEN END OF BLOCK b1.
