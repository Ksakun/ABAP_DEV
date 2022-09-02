*&---------------------------------------------------------------------*
*& Include ZBC400_A01_BASIC6_TOP                    - Report ZBC400_A01_BASIC6
*&---------------------------------------------------------------------*
REPORT zbc400_a01_basic6.

TABLES: sflight, sbook.

DATA: BEGIN OF gs_data1,
        carrid    TYPE sflight-carrid,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        planetype TYPE sflight-planetype,
        currency  TYPE sflight-currency,
        bookid    TYPE sbook-bookid,
        customid  TYPE sbook-customid,
        custtype  TYPE sbook-custtype,
        class     TYPE sbook-class,
        agencynum TYPE sbook-agencynum,
      END OF gs_data1,

      BEGIN OF gs_data2,
        carrid    TYPE sflight-carrid,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        bookid    TYPE sbook-bookid,
        customid  TYPE sbook-customid,
        custtype  TYPE sbook-custtype,
        agencynum TYPE sbook-agencynum,
      END OF gs_data2,

      gt_data1 LIKE TABLE OF gs_data1,
      gt_data2 LIKE TABLE OF gS_data2,

      lv_tabix TYPE sy-tabix.

CLEAR: gs_data1, gs_data2. REFRESH: gt_data1, gt_data2.



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS    :  pa_carr TYPE sflight-carrid OBLIGATORY.
  SELECT-OPTIONS:  so_con   FOR sflight-connid OBLIGATORY.
  PARAMETERS    :  pa_pltp TYPE sflight-planetype AS LISTBOX VISIBLE LENGTH 15.
  SELECT-OPTIONS:  so_bid   FOR sbook-bookid.
  PARAMETERS    :  p_carr  TYPE sflight-carrid.
SELECTION-SCREEN END OF BLOCK b1.
