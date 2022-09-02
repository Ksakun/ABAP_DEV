*&---------------------------------------------------------------------*
*& Include ZC1R010004_TOP                           - Report ZC1R010004
*&---------------------------------------------------------------------*
REPORT zc1r010004 MESSAGE-ID zmcsa01.

CLASS lcl_handler DEFINITION DEFERRED. "type ref to 쓰기 위해 / instance 화

TABLES: mast.

DATA: BEGIN OF gs_data,
        matnr TYPE mast-matnr,
        maktx TYPE makt-maktx,
        stlan TYPE mast-stlan,
        stlnr TYPE mast-stlnr,
        stlal TYPE mast-stlal,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
      END OF gs_data,

      gt_data   LIKE TABLE OF gs_data,
      gcl_maktx TYPE REF TO zclc101_0002.



"매크로
DEFINE _clear.

  CLEAR &1. REFRESH &1.

END-OF-DEFINITION.


DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gcl_handler   TYPE REF TO lcl_handler,
      gs_layout     TYPE lvc_s_layo,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_variant    TYPE disvariant.

DATA: ok_code    TYPE sy-ucomm.
