*&---------------------------------------------------------------------*
*& Include YCL101_001_TOP                           - Report YCL101_001
*&---------------------------------------------------------------------*
REPORT ycl101_001 MESSAGE-ID zmcsa01.

TABLES: scarr.

DATA: gt_scarr TYPE TABLE OF scarr,
      gs_scarr LIKE LINE  OF gt_scarr. "gs_scarr TYPE scarr.

DATA: ok_code TYPE sy-ucomm, " ok_code LIKE sy-ucomm
      save_ok TYPE sy-ucomm. " ok_code를 저장하기 위한 변수


"ALV 종류
"1. LIST           : WRITE문을 사용하는 ALV
"2. Functional ALV : REUSE Function을 사용하여 ALV를 그리는 방법
"3. Class ALV      : A. SIMPLE ALV -> 단점: 데이터 편집불가
"                  : B. GRID ALV
"                  : C. ALV WITH IDA (최신 방법이자 가장 어려움)


"Container
"1. Custom Container
"2. Docking Container
"3. Splitter Container : 하나의 화면에서 2개의 alv를 그려주는 Contaienr


DATA: gr_con     TYPE REF TO cl_gui_docking_container,
      gr_split   TYPE REF TO cl_gui_splitter_container,
      gr_con_top TYPE REF TO cl_gui_container,
      gr_con_alv TYPE REF TO cl_gui_container,

      gr_alv     TYPE REF TO cl_gui_alv_grid.


DATA: gs_layout  TYPE lvc_s_layo,
      gt_fcat    TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat,
      gs_variant TYPE disvariant.
