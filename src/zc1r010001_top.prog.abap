*&---------------------------------------------------------------------*
*& Include ZC1R010001_TOP                           - Report ZC1R010001
*&---------------------------------------------------------------------*
REPORT zc1r010001 MESSAGE-ID zmcsa01.

TABLES sflight.

DATA: BEGIN OF gs_data,
        carrid    TYPE sflight-carrid,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        price     TYPE sflight-price,
        currency  TYPE sflight-currency,
        planetype TYPE sflight-planetype,
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data.

* ALV 관련

DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant.

DATA: ok_code       TYPE sy-ucomm.
