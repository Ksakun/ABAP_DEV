*&---------------------------------------------------------------------*
*& Report ZRSA01_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_20.
*DATA:BEGIN OF로 선언하는 방법
*DATA: BEGIN OF gs_info,
*        carrid    LIKE spfli-carrid,
*        carrname  LIKE scarr-carrname,
*        connid    LIKE spfli-connid,
*        countryfr LIKE spfli-countryfr,
*        countryto LIKE spfli-countryto,
*        atype     TYPE c LENGTH 15,
*      END OF gs_info.

*DATA gt_info LIKE TABLE OF gs_info.
*TYPES로 선언하는법.
TYPES: BEGIN OF ts_info,
         carrid    LIKE spfli-carrid,
         carrname  LIKE scarr-carrname,
         connid    LIKE spfli-connid,
         countryfr LIKE spfli-countryfr,
         countryto LIKE spfli-countryto,
         atype     TYPE c LENGTH 15,
       END OF ts_info.


DATA: gs_info TYPE ts_info,
      gt_info LIKE TABLE OF gs_info.


*cl_demo_output=>display_data( gs_info ).
cl_demo_output=>display_data( gt_info ).


**APPEND문을 사용해서 Internal table에 데이터 채우기. TABLE SPFLI에서 읽어와도 됨.
*gs_info-carrid = 'AA'.
*gs_info-connid = '0017'.
*gs_info-countryfr = 'US'.
*gs_info-countryto = 'US'.
*APPEND gs_info TO gt_info.
*CLEAR gs_info.


*TABLE에서 읽어오는법?
SELECT SINGLE carrid connid countryfr countryto
  FROM spfli
  INTO CORRESPONDING FIELDS OF gs_info
  WHERE carrid = 'AA' AND connid ='0017'.
APPEND gs_info TO gt_info.
CLEAR gs_info.


gs_info-carrid = 'AA'.
gs_info-connid = '0064'.
gs_info-countryfr = 'US'.
gs_info-countryto = 'DE'.
APPEND gs_info TO gt_info.
CLEAR gs_info.

gs_info-carrid = 'AZ'.
gs_info-connid = '0555'.
gs_info-countryfr = 'IT'.
gs_info-countryto = 'DE'.
APPEND gs_info TO gt_info.
CLEAR gs_info.

**Loop문과 MODIFY문을 이용해서 아래 내용을 Internal Table의 데이터를 변경하기
**1) countryfr과 countryto의 값이 같으면 '국내선', 다르면 '국제선'
**2) carrname 값을 select single문을 이용해서 table scarr에서 읽어서 intenal tabel carrname에 저장하기.

*1) countryfr과 countryto의 값이 같으면 '국내선', 다르면 '국제선'
LOOP AT gt_info INTO gs_info.
  IF gs_info-countryfr = gs_info-countryto.
    gs_info-atype = 'National'(t01).
    MODIFY gt_info FROM gs_info.
    CLEAR gs_info.
  ELSE.
    gs_info-atype = 'International'(t02).
    MODIFY gt_info FROM gs_info.
    CLEAR gs_info.
  ENDIF.
ENDLOOP.

*2)carrname 값을 select single문을 이용해서 table scarr에서 읽어서 intenal tabel carrname에 저장하기.
LOOP AT gt_info INTO gs_info.
  SELECT SINGLE carrname
    FROM scarr
    INTO CORRESPONDING FIELDS OF gs_info
    WHERE carrid = gs_info-carrid.
  MODIFY gt_info FROM gs_info.
  CLEAR gs_info.
ENDLOOP.


"cl_demo_output=>display_data( gt_info ).
