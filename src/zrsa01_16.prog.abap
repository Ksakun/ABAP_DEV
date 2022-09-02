*&---------------------------------------------------------------------*
*& Report ZRSA01_16
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_16.

DATA: BEGIN OF gs_std,
        stdno    TYPE n LENGTH 8,
        sname    TYPE c LENGTH 40,
        gender   TYPE c,
        gender_t TYPE c LENGTH 10,
      END OF gs_std.

DATA gt_std LIKE TABLE OF gs_std.

gs_std-stdno = '20220001'.
gs_std-sname = 'KangJG'.
gs_std-gender = 'M'.
APPEND gs_std TO gt_std.
CLEAR gs_std.

gs_std-stdno = '20220002'.
gs_std-sname = 'HAN'.
gs_std-gender = 'F'.
APPEND gs_std TO gt_std.
CLEAR gs_std.


LOOP AT gt_std INTO gs_std.
*  CASE... IF...(성별 확인)
  gs_std-gender_t = 'Male'(t01).
  MODIFY gt_std FROM gs_std.
  CLEAR gs_std.
ENDLOOP.
*Modify gt_std FROM gs_std Index2.
*cl_demo_output=>display_data( gt_std ).

CLEAR gs_std.
*READ TABLE gt_std INDEX 1 INTO gs_std.
READ TABLE gt_std WITH KEY stdno = '20220001' INTO gs_std.

cl_demo_output=>display_data( gs_std ).


*인터널 테이블에 있는 값들을 gs_std에 담아라.
*LOOP AT gt_std INTO gs_std.
*  WRITE: sy-tabix, gs_std-stdno, gs_std-sname, gs_std-gender.
*  NEW-LINE.
*  CLEAR gs_std.
*ENDLOOP.
*WRITE:/ sy-tabix, gs_std-stdno, gs_std-sname, gs_std-gender.
*cl_demo_output=>display_data( gt_std ).

*1.
*DATA: gs_xxxx TYPE <STRUCTURE_TYPE>,
*      gt_xxxx Like TABLE OF gs_xxx.
*
*2.
*DATA: gt_xxxx TYPE <TABLE_TYPE>,
*      gs_xxxx LIKE LINE OF gt_xxxx.
*
*3.
*DATA: gt_xxx TYPE TABLE OF <STRUCTURE_TYPE>,
*      gs_xxx LIKE LINE OF gt_xxxx.
*
*4.
*DATA: gs_xxx TYPE LINE OF <table_type>,
*      gt_xxx LIKE TABLE OF gs_xxxx.

*etc.
*DATA: gs_xxx TYPE LINE OF <table_type>,
*      gt_sss TYPE <table_type>.
