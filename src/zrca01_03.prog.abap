*&---------------------------------------------------------------------*
*& Report ZRCA01_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca01_03.

*DATA gv_i TYPE i.
*
*WRITE gv_i.
*
**MESSAGE 'Message Test' TYPE 'I'.
**MESSAGE 'Message Test2' TYPE 'S'.
**MESSAGE 'Message Test3' TYPE 'E'.
**MESSAGE 'Message Test4' TYPE 'W'.
**MESSAGE 'Message Test5' TYPE 'A'.
*MESSAGE 'Message Test6' TYPE 'X'.

DATA: ls_data     TYPE zsc1010001,
      lt_data     LIKE TABLE OF ls_data,
      ls_data_tmp LIKE ls_data.

*DATA: BEGIN OF ls_data2,
*        loekz LIKE ekpo-loekz,
*        statu LIKE ekpo-statu,
*      END OF ls_data2,
*
*      BEGIN OF ls_data3,
*        bpumz LIKE ekpo-bpumz,
*        bpumn LIKE ekpo-bpumn,
*      END OF ls_data3.
