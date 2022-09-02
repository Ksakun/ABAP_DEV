*&---------------------------------------------------------------------*
*& Include          ZBC400_A01_BASIC6_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_carrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_carrid .

  DATA: BEGIN OF ls_carrid,
          carrid   TYPE scarr-carrid,
          carrname TYPE scarr-carrname,
          currcode TYPE scarr-currcode,
          url      TYPE scarr-url,
        END OF ls_carrid,

        lt_carrid LIKE TABLE OF ls_carrid.

  REFRESH lt_carrid.

  SELECT carrid carrname currcode url
    FROM scarr
    INTO TABLE lt_carrid.


  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'CARRID' "선택하면 화면으로 세팅할 itab 필드 id
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'P_CARR' "서치헬프 화면에서 선택한 데이터가 세팅될 화면의 필드값
      window_title = 'Air List'
      value_org    = 'S'
*      display      = 'X' "정말 display만 할거다. 더블클릭 등 전부 막음
    TABLES
      value_tab    = lt_carrid.
ENDFORM.
