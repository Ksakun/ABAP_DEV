*&---------------------------------------------------------------------*
*& Report ZBC400_A01_BASIC3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_a01_basic3.

"GT_DATA는 SKA1-KTOPL, SKA1-SAKNR, SKA1-KOKS
"SKA1 테이블의 데이터를 읽어서 GT_DATA에 적재
" SKAI 조회조건: KTOPL = 'WEG'
" 각 필드의 내역을 찾아서 모두 세팅할것.

DATA: BEGIN OF gs_data,
        ktopl TYPE ska1-ktopl,
        ktplt TYPE t004t-ktplt,
        saknr TYPE ska1-saknr,
        txt20 TYPE skat-txt20,
        txt50 TYPE skat-txt50,
        ktoks TYPE ska1-ktoks,
        txt30 TYPE t077z-txt30,
      END OF gs_data.

DATA: gt_data  LIKE TABLE OF gs_data,

      gs_t004t TYPE t004t,
      gt_t004t LIKE TABLE OF gs_t004t,

      gs_skat  TYPE skat,
      gt_skat  LIKE TABLE OF gs_skat,

      gs_t077z TYPE t077z,
      gt_t077z LIKE TABLE OF gs_t077z.

DATA: lv_tabix TYPE sy-tabix.

SELECT ktopl saknr ktoks
  FROM ska1
  INTO CORRESPONDING FIELDS OF TABLE gt_data
 WHERE ktopl = 'WEG'.

SELECT ktopl ktplt
  FROM t004t
  INTO CORRESPONDING FIELDS OF TABLE gt_t004t
 WHERE spras = sy-langu.

SELECT saknr txt20 txt50
  FROM skat
  INTO CORRESPONDING FIELDS OF TABLE gt_skat
 WHERE spras = sy-langu.

SELECT ktoks txt30
  FROM t077z
  INTO CORRESPONDING FIELDS OF TABLE gt_t077z
 WHERE spras = sy-langu.

LOOP AT gt_data INTO gs_data.

  lv_tabix = sy-tabix.


  READ TABLE gt_t004t INTO gs_t004t WITH KEY ktopl = gs_data-ktopl.
  IF sy-subrc = 0.
    gs_data-ktplt = gs_t004t-ktplt.
  ENDIF.

  READ TABLE gt_skat INTO gs_skat WITH KEY saknr = gs_data-saknr.
  IF sy-subrc = 0.
    gs_data-txt20 = gs_skat-txt20.
    gs_data-txt50 = gs_skat-txt50.
  ENDIF.

  READ TABLE gt_t077z INTO gs_t077z WITH KEY ktoks = gs_data-ktoks.
  IF sy-subrc = 0.
    gs_data-txt30 = gs_t077z-txt30.
  ENDIF.

  CLEAR: gs_t004t, gs_skat, gs_t077z.

  MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING ktplt txt20 txt50 txt30.
  CLEAR gs_data.
ENDLOOP.

cl_demo_output=>display_data( gt_data ).
