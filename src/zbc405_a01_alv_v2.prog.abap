*&---------------------------------------------------------------------*
*& Report ZBC405_A01_ALV_V2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a01_alv_v2.


TABLES : ztsbook_a01.

"DATA Type 선언
TYPES: BEGIN OF gty_sbook.
         INCLUDE TYPE ztsbook_a01.
TYPES: END OF gty_sbook.


DATA: gs_book TYPE gty_sbook,
      gt_book LIKE TABLE OF gs_book.

DATA: ok_code TYPE sy-ucomm.


SELECT-OPTIONS: so_car FOR ztsbook_a01-carrid OBLIGATORY MEMORY ID car,
                so_con FOR ztsbook_a01-connid OBLIGATORY MEMORY ID con,
                so_fld FOR ztsbook_a01-fldate OBLIGATORY MEMORY ID fld,
                so_cus FOR ztsbook_a01-customid OBLIGATORY MEMORY ID cus.



START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.




*----------------------------SUBROUTINE-----------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT *
    FROM ztsbook_a01
    INTO CORRESPONDING FIELDS OF TABLE gt_book
    WHERE carrid   IN so_car
      AND connid   IN so_con
      AND fldate   IN so_fld
      AND customid IN so_cus.
ENDFORM.
