*&---------------------------------------------------------------------*
*& Report ZRSA01_20_V2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_20_v2.

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




*TABLE에서 읽어오는법?
SELECT SINGLE carrid connid countryfr countryto
  FROM spfli
  INTO CORRESPONDING FIELDS OF gs_info
  WHERE carrid = gs_info-carrid AND connid = gs_info-connid.
APPEND gs_info TO gt_info.
CLEAR gs_info.




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


cl_demo_output=>display_data( gt_info ).
