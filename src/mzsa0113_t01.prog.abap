*&---------------------------------------------------------------------*
*& Include MZSA0110_TOP                             - Module Pool      SAPMZSA0110
*&---------------------------------------------------------------------*
PROGRAM SAPMZSA0110.

"Common Variable
DATA ok_code TYPE sy-ucomm.
DATA: gv_subrc TYPE sy-subrc,
      gv_dynnr TYPE sy-dynnr.

"Condition
TABLES zssa0180. "주 목적 Use Screen: 사용자가 입력한 값을 변경하지 않겠다.
*DATA gs_cond TYPE zssa0180. "주 목적 Use ABAP: 내 맘대로 가지고 놀 수 있는 변수

"Airline Info
TABLES zssa0181.
*DATA gs_airline TYPE zssa0181.

"Flight Info
TABLES zssa0182.
*DATA gs_flight TYPE zssa0182.


"Tab Strip
CONTROLS ts_info TYPE TABSTRIP.
