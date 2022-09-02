*&---------------------------------------------------------------------*
*& Include ZC1R010008_TOP                           - Report ZC1R010008
*&---------------------------------------------------------------------*
REPORT zc1r010008 MESSAGE-ID zmcsa01.

TABLES: ztsa0103.

DATA: BEGIN OF gs_data,
        mark,
        pernr    TYPE ztsa0103-pernr,
        ename    TYPE ztsa0103-ename,
        entdt    TYPE ztsa0103-entdt,
        gender   TYPE ztsa0103-gender,
        edept    TYPE ztsa0103-edept,
        carrid   TYPE ztsa0103-carrid,
        carrname TYPE scarr-carrname,
        style    TYPE lvc_t_styl,
      END OF gs_data,

      gt_data     LIKE TABLE OF gs_data,
      gt_data_del LIKE TABLE OF gs_data.


DATA: ok_code TYPE sy-ucomm.



"For alv

DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_layout     TYPE lvc_s_layo,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_variant    TYPE disvariant,
      gs_stable     TYPE lvc_s_stbl,
      gt_rows       TYPE lvc_t_row,
      gs_row        TYPE lvc_s_row.


DEFINE _clear.
 CLEAR &1. REFRESH &2.
END-OF-DEFINITION.
