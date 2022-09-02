*&---------------------------------------------------------------------*
*& Include          ZRSA01_23_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_info .

  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_info
    WHERE carrid = pa_car AND connid = pa_con.



  CLEAR gs_info.
  LOOP AT gt_info INTO gs_info.
*          여기도 subroutine으로 만들 수 있다.
    "Get Airline Name
    SELECT SINGLE carrname
      FROM scarr
      INTO gs_info-carrname
      WHERE carrid = gs_info-carrid.

*      여기도 subroutine으로 만들 수 있다.
    SELECT SINGLE cityfrom cityto
      FROM spfli
*      INTO CORRESPONDING FIELDS OF gs_info
      INTO (gs_info-cityfrom, gs_info-cityto )
      WHERE carrid = gs_info-carrid AND connid = gs_info-connid.
    MODIFY gt_info FROM gs_info.
    CLEAR gs_info.
  ENDLOOP.
ENDFORM.
