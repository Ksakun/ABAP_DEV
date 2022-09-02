*&---------------------------------------------------------------------*
*& Report ZBC400_A01_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_a01_basic7.

****************구문법

DATA: BEGIN OF ls_scarr,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF ls_scarr,
      gt_scarr LIKE TABLE OF ls_scarr.


SELECT carrid carrname url
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE gt_scarr.

READ TABLE gt_scarr INTO ls_scarr WITH KEY carrid = 'AA'.

****************신문법

SELECT carrid, carrname
  FROM scarr
  INTO TABLE @DATA(lt_scarr).

* lt_scarr는 글로벌로 사용할 수 는 없다. 대부분 서브루틴안에서 사용하면 편리하고
* lt_scarr는 헤더가 없는 itab이다.
* s/4 hana 나 최근것에서만 쓴다.
* @이가 붙는 이유는? open sql에서만 붙고 sql문이 아니면 @없이 data만 쓴다.

*  READ TABLE lt_scarr INTO DATA(ls_scarr) WITH KEY carrid = 'AA'.

*LOOP AT lt_scarr INTO DATA(ls_scarr2).
*
*ENDLOOP.

***********************************************************************
* ******** 구문법
DATA: lv_carrid   TYPE scarr-carrid,
      lv_carrname TYPE scarr-carrname.

PARAMETERS pa_carr TYPE scarr-carrid.

SELECT SINGLE carrid carrname
  FROM scarr
  INTO (lv_carrid, lv_carrname)
 WHERE carrid = pa_carr.

*신문법

SELECT SINGLE carrid, carrname
  FROM scarr
  INTO (@DATA(lv_carrid2), @DATA(lv_carrname2))
 WHERE carrid = @pa_carr.

******************************************************
**********구문법
DATA: BEGIN OF ls_scarr3,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF ls_scarr3.

ls_scarr3-carrid = 'AA'.
ls_scarr3-carrname = 'American Airline'.
ls_scarr3-url      = 'www.ao.com'.

***********신문법
"#은 gs_scarr3에 해당하는 동일한 필드에 값을 넣겠다.
"조심할 점: Value에서 기술 되지 않은 필드들은 모두 clear 된다.
ls_scarr3 = VALUE #( carrid  = 'AA'
                     carrname = 'American Airline'
                     url      = 'www.ao.com' ).

ls_scarr3 = VALUE #( carrid = 'KA' ). "carrid만 바뀌고 나머지는 clear

"기술되지 않은 필드를 모두 유지 시키려면?
ls_scarr3 = VALUE #( BASE ls_scarr3
                         carrid = 'KA' ).

**********************************************************************
*********구문법
DATA: BEGIN OF ls_scarr4,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF ls_scarr4,
      lt_scarr4 LIKE TABLE OF ls_scarr4.

ls_scarr4-carrid = 'AA'.
ls_scarr4-carrname = 'American Airline'.
ls_scarr4-url      = 'www.ao.com'.

APPEND ls_scarr4 TO lt_scarr4.

ls_scarr4-carrid = 'KA'.
ls_scarr4-carrname = 'Korean Aireline'.
ls_scarr4-url      = 'www.ka.com'.

APPEND ls_scarr4 TO lt_scarr4.

*********신문법
REFRESH lt_scarr4.

lt_scarr4 = VALUE #( " --> Work Area 필요 없이 데이터 append 가능
                     ( carrid = 'AA'
                       carrname = 'American Airline'
                       url      = 'www.ao.com'
                       )
                     ( carrid = 'KA'
                       carrname = 'Korean Airline'
                       url      = 'www.ko.com'
                       )
                       ).
"문제 발생
lt_scarr4 = VALUE #( " --> 기존 itab의 row 모두 refresh 되고 지금 추가한것만 남음
                      ( carrid = 'LH'
                        carrname = 'Lufthansa'
                        url      = 'www.lh.com'
                        )
                        ).
"문제 해결
lt_scarr4 = VALUE #( BASE lt_scarr4 "기존의 itab의 row 유지시킴
                      ( carrid = 'LH'
                        carrname = 'Lufthansa'
                        url      = 'www.lh.com'
                        )
                        ).

"loop에도 추가가능
*LOOP AT itab INTO wa.
*
*  lt_scarr4 = VALUE #( BASE lt_scarr4
*                        ( carrid = wa-carrid
*                          carrname = wa-carrname
*                          url      = wa-url
*                          )
*                       ).
*
*ENDLOOP.

**********************************************************************
******구문법
MOVE-CORRESPONDING ls_scarr3 TO ls_scarr4.

******신문법
ls_scarr4 = CORRESPONDING #( ls_scarr3 ).

**********************************************************************
*ITAB의 데이터 이동 문법 5가지
**********************************************************************
"헤더없는 itab
*gt_color = lt_color.
*"헤더가 있을 때
*gt_color[] = lt_color[].
*APPEND LINES OF lt_color TO gt_color. "같은 구조의 itab이면서 기존 데이터 밑으로 append
*
*"같은 필드ID에 대해서만 데이터 이동: 기존 데이터 사라짐
*MOVE-CORRESPONDING lt_color TO gt_color.
*
*"같은 필드ID에 대해서만 데이터 이동: 기존 데이터(gt_color) 밑으로 APPEND 됨
*MOVE-CORRESPONDING lt_color TO gt_color KEEPING TARGET LINES.

**********************************************************************
*DB Table과 ITAB의 Join 방법 (FOR ALL ENTRIES = INNER JOIN과 같은 느낌 )
*DB TABLE & DB TABEL => INNER JOIN
*DB TABLE & ITAB     => FOR ALL ENTRIES /// BUT 신문법은 INNER JOIN도 사용

**FOR ALL ENTRIES 사용 선제 조건
** 1. 반드시 정렬 먼저 할 것: sort
** 2. 정렬 후 중복제거 할 것: DELETE ADJACENT DUPLICATE FROM ,,,
** 3. ITAB이 비어있는지 체크하고 수행할 것: 비어있으면 안된다.
**********************************************************************

*********구문법
DATA : BEGIN OF ls_key,
         carrid TYPE sflight-carrid,
         connid TYPE sflight-connid,
         fldate TYPE sflight-fldate,
       END OF ls_key,

       lt_key LIKE TABLE OF ls_key,
       lt_sbook TYPE TABLE OF sbook.

SELECT carrid connid fldate
  INTO CORRESPONDING FIELDS OF TABLE lt_key
  FROM sflight
 WHERE carrid = 'AA'.

SORT lt_key BY carrid connid fldate.
DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.

IF lt_key IS NOT INITIAL.
  SELECT carrid connid fldate bookid customid custtype
    INTO CORRESPONDING FIELDS OF TABLE lt_sbook
    FROM sbook
     FOR ALL ENTRIES IN lt_key
   WHERE carrid   = lt_key-carrid
     AND connid   = lt_key-connid
     AND fldate   = lt_key-fldate
     AND customid = '00000279'.
ENDIF.

********신문법
SORT lt_key BY carrid connid fldate.
DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.

SELECT a~carrid, a~connid, a~fldate, a~bookid, a~customid
  FROM sbook AS a
 INNER JOIN @lt_key AS b
    ON a~carrid = b~carrid
   AND a~connid = b~connid
   AND a~fldate = b~fldate
 WHERE a~customid = '00000279'
  INTO TABLE @DATA(lt_sbook2).
**********************************************************************
* lt_sbook2 에서 connid 의 MAX 값을 알고자 할때
**********************************************************************
****구문법
SORT lt_sbook2 BY connid DESCENDING.
READ TABLE lt_sbook2 INTO DATA(ls_sbook2) INDEX 1.
****신문법
SELECT MAX( connid ) AS connid
  FROM @lt_sbook2 AS a
  INTO @DATA(lv_max).


**********************************************************************
*CASE문에서도 사용 가능
**********************************************************************
TABLES sflight.
DATA: gt_data TYPE TABLE OF sflight,
      gs_data LIKE LINE OF gt_data.
******구문법

SELECT carrid connid price currency fldate
  INTO CORRESPONDING FIELDS OF TABLE gt_data
  FROM sflight.

LOOP AT gt_data INTO gs_data.

  CASE gs_data-carrid.
    WHEN 'AA'.
      gs_data-carrid = 'BB'.

      MODIFY gt_data FROM gs_data INDEX sy-index TRANSPORTING carrid.
  ENDCASE.

ENDLOOP.

******신문법
"case문을 select 안에서 써버릴 수 있다.
SELECT CASE carrid
        WHEN 'AA' THEN 'BB'
        ELSE carrid
       END AS carrid, connid, price, currency, fldate
  INTO TABLE @DATA(lt_sflight)
  FROM sflight.
