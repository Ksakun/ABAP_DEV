*&---------------------------------------------------------------------*
*& Include ZC1R010006_TOP                           - Report ZC1R010006
*&---------------------------------------------------------------------*
REPORT zc1r010006 MESSAGE-ID zmcsa01.

TABLES: scarr, sflight, sbook.


DATA: BEGIN OF gs_data,
        carrid    TYPE scarr-carrid,
        carrname  TYPE scarr-carrname,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        planetype TYPE sflight-planetype,
        price     TYPE sflight-price,
        currency  TYPE sflight-currency,
        url       TYPE scarr-url,
      END OF gs_data,

      gt_data LIKE TABLE OF gs_data,

      BEGIN OF gs_plane,
        planetype  TYPE saplane-planetype,
        seatsmax   TYPE saplane-seatsmax,
        seatsmax_b TYPE saplane-seatsmax_b,
        seatsmax_f TYPE saplane-seatsmax_f,
        producer   TYPE saplane-producer,
      END OF gs_plane,

      gt_plane LIKE TABLE OF gs_plane.




DATA: ok_code TYPE sy-ucomm.

"For ALB
DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_layout     TYPE lvc_s_layo,
      gs_variant    TYPE disvariant,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat.

"For Pop#1
DATA: gcl_container_pop1 TYPE REF TO cl_gui_custom_container,
      gcl_grid_pop1      TYPE REF TO cl_gui_alv_grid,
      gs_layout_pop1     TYPE lvc_s_layo,
      gs_fcat_pop1       TYPE lvc_s_fcat,
      gt_fcat_pop1       TYPE lvc_t_fcat.

DEFINE _clear.
  CLEAR &1.
  REFRESH &2.
END-OF-DEFINITION.
