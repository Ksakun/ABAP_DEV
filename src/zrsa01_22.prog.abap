*&---------------------------------------------------------------------*
*& Report ZRSA01_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_22.
*ZSINFO structure 타입이용

PARAMETERS: pa_code1 LIKE scarr-carrid,
            pa_code2 LIKE scarr-carrid.


*DATA: BEGIN OF gs_info,
*        carrid   LIKE spfli-carrid,
*        carrname LIKE scarr-carrname,
*        connid   LIKE spfli-connid,
*        cityfrom LIKE spfli-cityfrom,
*        cityto   LIKE spfli-cityto,
*      END OF gs_info.


DATA:gs_info TYPE zsinfo,
     gt_info LIKE TABLE OF gs_info.


*cl_demo_output=>display_data( gs_info ).

* PARAMETERS를 이용해서 Airline Code 2개 받음(시작과 끝)
*1) SPFLI table에서 where 절을 통해 검색 조건에 따른 항공사 코드를 이용해서 레코드 검색
*인터널 테이블 사용

SELECT *
  FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE carrid BETWEEN pa_code1 AND pa_code2 .


cl_demo_output=>display_data( gt_info ).
