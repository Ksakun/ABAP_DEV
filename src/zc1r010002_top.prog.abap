*&---------------------------------------------------------------------*
*& Include ZC1R010002_TOP                           - Report ZC1R010002
*&---------------------------------------------------------------------*
REPORT zc1r010002.

TABLES: mara, marc.

"Local data

DATA: BEGIN OF gs_data,
        matnr TYPE mara-matnr,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
        meins TYPE mara-meins,
        tragr TYPE mara-tragr,
        pstat TYPE marc-pstat,
        dismm TYPE marc-dismm,
        ekgrp TYPE marc-ekgrp,
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data.

CLEAR gs_data. REFRESH gt_data.

"For ALV

DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant,
      gs_sort       TYPE lvc_s_sort,
      gt_sort       TYPE lvc_t_sort.


DATA: ok_code TYPE sy-ucomm.
