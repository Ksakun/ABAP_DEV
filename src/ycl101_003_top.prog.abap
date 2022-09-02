*&---------------------------------------------------------------------*
*& Include YCL101_002_TOP                           - Module Pool      YCL101_002
*&---------------------------------------------------------------------*
PROGRAM ycl101_002 MESSAGE-ID zmcsa01.

TABLES: scarr.

DATA: ok_code TYPE sy-ucomm,
      save_ok TYPE sy-ucomm.


DATA: gt_data TYPE TABLE OF scarr,
      gs_data TYPE scarr.

SELECTION-SCREEN BEGIN OF SCREEN 0101 AS SUBSCREEN.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(10) TEXT-l02 FOR FIELD so_carr.
      SELECT-OPTIONS: so_carr FOR scarr-carrid.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      SELECTION-SCREEN COMMENT 1(10) TEXT-l03 FOR FIELD so_name.
      SELECT-OPTIONS: so_name FOR scarr-carrname.
      SELECTION-SCREEN PUSHBUTTON 68(10) TEXT-l01 USER-COMMAND search.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN SKIP 2.


  SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN END OF SCREEN 0101.
