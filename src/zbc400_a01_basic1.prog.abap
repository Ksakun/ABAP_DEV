*&---------------------------------------------------------------------*
*& Report ZBC400_A01_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_a01_basic1.

****문제#1
* Variables
"1. character 타입의 길이가 20
"2. 소수점 2자리를 갖는 5자리 변수.
"3. 출력결과가 00000678이 나올 수 있는 변수
"4. 변수에 값이 아래와 같이 저장될 수 있는 변수를 선언. (ABCDEFGHIJ/00000000365_
*DATA: gv_a TYPE c LENGTH 20,
*      gv_p TYPE p LENGTH 7 DECIMALS 2,
*      gv_s TYPE n LENGTH 8,
*      gv_x TYPE string.
*
*gv_p = '222.22'.
*gv_s = 678.
*gv_x = 'ABCEDFGHIJ'.
*gv_x = 365.
*
*WRITE: / gv_a,
*       / gv_p,
*       / gv_s,
*       / gv_x.

****문제#2
**Internal Tables
*"1. ztscarr01을 참조하는 structrue선언,
*"   internal선언
*DATA gs_scarr TYPE ztscarr_a01.
*DATA gt_scarr LIKE TABLE OF ztscarr_a01.
*
*"2. 필드를 참조하는 structure 선언
*" mara-matnr,werks, mtart,matkl,ekgrp,pstat\
*
*DATA: BEGIN OF gs_mara.
*        INCLUDE STRUCTURE ztsa0101.
*DATA:   matnr TYPE mara-matnr,
*        werks TYPE marc-werks,
*        mtart TYPE mara-mtart,
*        matkl TYPE mara-matkl,
*        ekgrp TYPE marc-ekgrp,
*        pstat TYPE marc-pstat,
*      END OF gs_mara.
*
*DATA: gt_mara LIKE TABLE OF gs_mara.

****문제#3
* SBOOK의 구조를 갖는 로컬 스트럭쳐, 인터널 테이블 선언
* CARRID, CONNID, FLDATE, BOOKID, CUSTOMID, CUSTTYPE, INVOICE, CLASS 를 필드를 선택
* 선택 조건 CARRID 가 DL이고 CUSTTYPE이 'P'이고 OERDERDATE가 '2020.12.
* 조회된 데이터 중 "SMOKER가 X고 INVOICE가 'X'인 데이터의 CLASS의 필드의 값을 'F'로 변경할 것.

*DATA: gs_book  TYPE sbook,
*      gt_book  LIKE TABLE OF gs_book,
*      lv_tabix TYPE sy-tabix.
*
*CLEAR gs_book. REFRESH gt_book.
*
*SELECT carrid connid fldate bookid customid custtype invoice class smoker order_date
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_book
* WHERE carrid     = 'DL'
*   AND custtype   = 'P'
*   AND order_date = '20201227'.
*
*IF sy-subrc = 0.
*  LOOP AT gt_book INTO gs_book.
*    lv_tabix = sy-tabix.
*
**    IF gs_book-smoker = 'X' AND gs_book-invoice = 'X'.
**      gs_book-class = 'F'.
**
**      "mycode
***     MODIFY gt_book FROM gs_book.
**      "TA'S code
**      MODIFY gt_book FROM gs_book INDEX lv_tabix TRANSPORTING class.
**    ENDIF.
*    CASE gs_book-smoker.
*      WHEN 'X'.
*        CASE gs_book-invoice.
*          WHEN 'X'.
*            gs_book-class = 'F'.
*            MODIFY gt_book FROM gs_book INDEX lv_tabix TRANSPORTING class.
*        ENDCASE.
*    ENDCASE.
*  ENDLOOP.
*
*ELSE.
*  MESSAGE s001(zmcsa01).
*  LEAVE LIST-PROCESSING. "여기서 멈추고 CALL을 하지마라. "혹은 STOP.
*ENDIF.
*
*cl_demo_output=>display_data( gt_book ).

****문제#4
*로컬스트럭쳐 / itab 선언 ( sflight-carrid, connid fldate currency planetype seatsocc_b
*sflight에서 carrid connid fldate currency planetype seats SELECT
*조회 조건 : CURRENCY가 'KRW'이고 PLANE TYPE이 747-400
*조회된 데이터에서 CARRID가 'UA'인 데이터의 필드 SEATSOCC_B의 값에 5를 더하고 반영.

DATA: BEGIN OF gs_flight,
        carrid      TYPE sflight-carrid,
        connid      TYPE sflight-connid,
        fldate      TYPE sflight-fldate,
        currency    TYPE sflight-currency,
        planetype   TYPE sflight-planetype,
        seatsocc_b  TYPE sflight-seatsocc_b,
        after_seats TYPE i,
      END OF gs_flight.

DATA: gt_flight LIKE TABLE OF gs_flight,
      lv_tabix  TYPE sy-tabix.

SELECT carrid connid fldate currency planetype seatsocc_b
  FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE gt_flight
 WHERE currency  = 'USD'
   AND planetype = '747-400'.

IF sy-subrc NE 0.
  MESSAGE s001(zmcsa01).
  LEAVE LIST-PROCESSING.
ENDIF.

LOOP AT gt_flight INTO gs_flight.

  lv_tabix = sy-tabix.

  CASE gs_flight-carrid.

    WHEN 'UA'.
      gs_flight-after_seats = gs_flight-seatsocc_b + 5.
      MODIFY gt_flight FROM gs_flight INDEX lv_tabix TRANSPORTING after_seats.
*    WHEN OTHERS.
*      MESSAGE i001(zmcsa01).
*      LEAVE LIST-PROCESSING.
  ENDCASE.
ENDLOOP.

cl_demo_output=>display_data( gt_flight ).
