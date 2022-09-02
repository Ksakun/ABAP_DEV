*&---------------------------------------------------------------------*
*& Include ZBC405_A01_EXAM01_TOP                    - Report ZBC405_A01_EXAM01
*&---------------------------------------------------------------------*
REPORT zbc405_a01_exam01.

TABLES ztspfli_a01.

TYPES: BEGIN OF ty_flight.
         INCLUDE TYPE ztspfli_a01.
TYPES:   light TYPE c LENGTH 1.
TYPES:   checkid   TYPE c LENGTH 1.
TYPES:   flight    TYPE icon-id.
TYPES:   it_color  TYPE lvc_t_scol.
TYPES:   row_color TYPE c LENGTH 4.
TYPES:   ftzone    TYPE sairport-time_zone.
TYPES:   ttzone    TYPE sairport-time_zone.
TYPES:   modified  TYPE c LENGTH 1.
TYPES: END OF ty_flight.

DATA: ok_code TYPE sy-ucomm,
      p_ans   TYPE c LENGTH 1.

DATA: go_container    TYPE REF TO cl_gui_custom_container,
      go_alv          TYPE REF TO cl_gui_alv_grid,
      gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.

DATA: gt_flight    TYPE TABLE OF ty_flight,
      gs_flight    TYPE          ty_flight,
      mem_is_spfli TYPE spfli,
      mem_it_spfli TYPE TABLE OF spfli.

DATA: gs_layout  TYPE lvc_s_layo,
      gs_variant TYPE disvariant,
      gs_color   TYPE lvc_s_scol,
      gt_sort    TYPE lvc_t_sort,
      gs_sort    TYPE lvc_s_sort,
      gt_fcat    TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat,
      gt_exct    TYPE ui_functions.

************************FOR SCREEN 200*************************
TYPES: BEGIN OF ty_carrid,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE s_carr_id,
         high   TYPE s_carr_id,
       END OF ty_carrid.

TYPES: BEGIN OF ty_connid,
         sign   TYPE ddsign,
         option TYPE ddoption,
         low    TYPE s_conn_id,
         high   TYPE s_conn_id,
       END OF ty_connid.

DATA: ws_carr TYPE ty_carrid,
      wt_carr TYPE TABLE OF ty_carrid,
      ws_conn TYPE ty_connid,
      wt_conn TYPE TABLE OF ty_connid.


"Selection Screen 선언
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car,
                  so_con FOR gs_flight-connid MEMORY ID con.

SELECTION-SCREEN END OF BLOCK b1.

"Variant, Edit CheckBox.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) TEXT-002.
    SELECTION-SCREEN POSITION POS_LOW.
    PARAMETERS: p_layout TYPE disvariant-variant.
    SELECTION-SCREEN COMMENT pos_high(10) TEXT-003.
    PARAMETERS: p_edit TYPE c AS CHECKBOX .
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2.

PARAMETERS p_screen AS CHECKBOX.
