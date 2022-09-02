*&---------------------------------------------------------------------*
*& Include ZRSA01_25_TOP                            - Report ZRSA01_25
*&---------------------------------------------------------------------*
REPORT zrsa01_25.

* Types 선언
*TYPES: BEGIN OF ts_info,
*         carrid   TYPE sflight-carrid,
*         connid   TYPE sflight-connid,
*         cityfrom TYPE spfli-cityfrom,
*         cityto   TYPE spfli-cityto,
*         fldate   TYPE sflight-fldate,
*       END OF ts_info,
*       tt_info TYPE TABLE OF ts_info. "Table Type

*Data Object

DATA: gt_info TYPE TABLE OF ZSSA0102,
      gs_info TYPE ZSSA0102.


* Selection Screen

PARAMETERS: pa_car  TYPE sflight-carrid,
            pa_con  TYPE sflight-connid,
            pa_con2 TYPE sflight-connid.

*SELECT-OPTION,
SELECT-OPTIONS so_con FOR gs_info-connid."variable
