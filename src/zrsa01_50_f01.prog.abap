*&---------------------------------------------------------------------*
*& Include          ZRSA01_50_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_init .
  pa_car = 'AA'.
  pa_con = '0017'.

  "Header line이 있는 internal table?
  CLEAR:so_dat[], so_dat. "so_dat은 스트럭쳐 변수. clear다음에는 itab, str 둘다 가능 so_dat[] = 인터널테이블
  so_dat-sign = 'I'. " I는 Include
  so_dat-option = 'BT'.
  so_dat-low = sy-datum - 365.
  so_dat-high = sy-datum.
*  APPEND <Structure Type> TO <Internal Table>. => APPEND문 3줄이 다 같은 말이다. 같은 변수명이면 생략가능 BUT 2번째 쓰셈
*  APPEND so_dat TO so_dat[].
   APPEND so_dat.

ENDFORM.
