*&---------------------------------------------------------------------*
*& Include          YCL101_001_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100' WITH sy-repid sy-datum.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_alv_0100 OUTPUT.

*  IF gr_con IS INITIAL. "변수가 초기 상태인가?
*    초기상태 이므로 생성과정
*  ELSE.
*    이미 만들어진 상태 이므로 새로고침 로직
*  ENDIF.

  IF gr_con IS BOUND.
    "이미 만들어진 상태이므로 새로고침 로직
  ELSE.
    PERFORM create_object_0100. "Container, ALV 참조변수 객체생성.
    PERFORM set_fcat_layout.
    PERFORM set_alv_fcat_0100.
    PERFORM display_alv_0100.
  ENDIF.



ENDMODULE.
