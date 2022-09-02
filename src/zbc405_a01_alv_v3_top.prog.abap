*&---------------------------------------------------------------------*
*& Include ZBC405_A01_ALV_V3_TOP                    - Report ZBC405_A01_ALV_V3
*&---------------------------------------------------------------------*
REPORT zbc405_a01_alv_v3.

TABLES : ztsbook_a01.

"DATA Type 선언
TYPES: BEGIN OF gty_sbook.
         INCLUDE TYPE ztsbook_a01.
TYPES:   light TYPE c LENGTH 1. "Exception handling = 신호등 빨노초 - >layout에서 구현 -> get_data에서 로직 구현
TYPES: row_color TYPE c LENGTH 4. "한줄의 length 설정을 위한 타입
TYPES: it_color  TYPE lvc_t_scol. "Cell Color Change를 위한 type 선언
TYPES: telephone TYPE ztscustom_a01-telephone. "Catalog 추가부분
TYPES: email     TYPE ztscustom_a01-email.    "Catalog 추가부분
TYPES: bt        TYPE lvc_t_styl.
TYPES: modified  TYPE c LENGTH 1. "Data가 변경되면 'X'로 표시됨. 변경유무를 알 수 있는 칸.
TYPES: END OF gty_sbook.

"FOR data Refresh
DATA: gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.

DATA: gs_book   TYPE gty_sbook,
      gt_book   LIKE TABLE OF gs_book,
      gt_custom TYPE TABLE OF ztscustom_a01,
      gs_custom TYPE          ztscustom_a01,
      gt_temp   TYPE TABLE OF  gty_sbook.
DATA: dl_book   TYPE TABLE OF ztsbook_a01, "For Delete Data
      dw_book   TYPE ztsbook_A01.

DATA: ok_code TYPE sy-ucomm,
      p_ans   TYPE c LENGTH 1. "POPUP 버튼 클릭 유무 확인하는 DATA

"ALV Container AlV Grid 선언 부분
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid.

"ALV 특성 관련된 data 선언들
DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gt_sort    TYPE lvc_t_sort,
       gs_sort    TYPE lvc_s_sort,
       gs_color   TYPE lvc_s_scol,
       gt_exct    TYPE ui_functions, "직접 사용하기 때문에 WA가 필요없다.
       gt_fcat    TYPE lvc_t_fcat,   "Field Catalog 선언
       gs_fcat    TYPE lvc_s_fcat.


*--------------------------------------------------------------------*
*-- SET Selection Screen.
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: so_car FOR ztsbook_a01-carrid OBLIGATORY MEMORY ID car,
                  so_con FOR ztsbook_a01-connid OBLIGATORY MEMORY ID con,
                  so_fld FOR ztsbook_a01-fldate  MEMORY ID fld,
                  so_cus FOR ztsbook_a01-customid  MEMORY ID cus.

  SELECTION-SCREEN SKIP 2.
  PARAMETERS p_edit AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP 2.

PARAMETERS: p_layout TYPE disvariant-variant. "저장된 vairant를 파라미터에 보이게 한다.
