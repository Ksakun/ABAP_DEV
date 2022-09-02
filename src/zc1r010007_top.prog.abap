*&---------------------------------------------------------------------*
*& Include ZC1R010007_TOP                           - Report ZC1R010007
*&---------------------------------------------------------------------*
REPORT zc1r010007 MESSAGE-ID zmcsa01.

CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES: bkpf.



DATA: BEGIN OF gs_data,
        belnr TYPE bseg-belnr, "전표번호
        buzei TYPE bseg-buzei, "전표순번
        blart TYPE bkpf-blart, "전표유형
        budat TYPE bkpf-budat, "전기일지
        shkzg TYPE bseg-shkzg, "차대지시지
        dmbtr TYPE bseg-dmbtr, "전표금액
        waers TYPE bkpf-waers, "전표통화
        hkont TYPE bseg-hkont, "G/L 계정

      END OF gs_data,

      gt_data LIKE TABLE OF gs_data.

"For alV
DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gcl_handler   TYPE REF TO lcl_event_handler,
      gs_layout     TYPE lvc_s_layo,
      gs_fcat       TYPE lvc_s_fcat,
      gt_fcat       TYPE lvc_t_fcat,
      gs_variant    TYPE disvariant.

DATA: ok_code TYPE sy-ucomm.

DEFINE _clear.
  CLEAR &1.
  REFRESH &2.

END-OF-DEFINITION.
