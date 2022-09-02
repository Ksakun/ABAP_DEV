*&---------------------------------------------------------------------*
*& Include ZBC405_A01_ALV_04_TOP                    - Report ZBC405_A01_ALV_04
*&---------------------------------------------------------------------*
REPORT ZBC405_A01_ALV_04.


TYPES: BEGIN OF gty_flight.
     INCLUDE TYPE ztsflight_a01.
TYPES: light TYPE c LENGTH 1.
TYPES: END OF gty_flight.


DATA: ok_code TYPE sy-ucomm,
      gt_flight TYPE TABLE OF gty_flight,
      gs_flight TYPE gty_flight.
"Data for alv
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid.

"Data for alv setting
DATA: gs_layout   TYPE lvc_s_layo.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: so_car FOR gs_flight-carrid,
                  so_con FOR gs_flight-connid,
                  so_fld FOR gs_flight-fldate.

SELECTION-SCREEN END OF BLOCK B1.
