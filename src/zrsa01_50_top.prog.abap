*&---------------------------------------------------------------------*
*& Include ZRSA01_50_TOP                            - Report ZRSA01_50
*&---------------------------------------------------------------------*
REPORT zrsa01_50.
TABLES: sflight. "nest/deep 구조를 갖지 않는 structure 변수

PARAMETERS: pa_car TYPE scarr-carrid,
            pa_con TYPE spfli-connid.


SELECT-OPTIONS so_dat FOR sflight-fldate. "For 다음에는 변수만 됩니다.
