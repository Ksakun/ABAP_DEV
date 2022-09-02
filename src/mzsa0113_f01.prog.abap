*&---------------------------------------------------------------------*
*& Include          MZSA0110_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA0180_CARRID
*&      <-- ZSSA0181
*&---------------------------------------------------------------------*
FORM get_airline_info  USING    VALUE(p_carrid)
                       CHANGING ps_info TYPE zssa0181.
  CLEAR ps_info.
  SELECT SINGLE *
    FROM scarr
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = p_carrid.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_name USING VALUE(p_carrid)
                      CHANGING VALUE(p_carrname).
  CLEAR p_carrname.
  SELECT SINGLE carrname
    FROM scarr
    INTO p_carrname
    WHERE carrid = p_carrid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_conn_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA0180_CARRID
*&      <-- ZSSA0182
*&---------------------------------------------------------------------*
FORM get_conn_info  USING   VALUE(p_carrid)
                            VALUE(p_connid)
                    CHANGING ps_info TYPE zssa0182
                             p_subrc.

  CLEAR: p_subrc, zssa0181, ps_info. "p_subrc를 clear 시키면 0으로 바뀌어서 성공한걸로 생각한다.
  SELECT SINGLE *
    FROM spfli
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = p_carrid AND connid = p_connid.

  "에러 핸들링 가장 쉬운방법 #1
*  IF sy-subrc <> 0.
*    MESSAGE i016(pn) WITH 'DATA NOT FOUND#1'.
*    RETURN.
*  ENDIF.

  "에러 핸들링 쉬운방법 #2 연결 중
   IF sy-subrc <> 0.
     p_subrc = 4. "sy-subrc
     RETURN.
   ENDIF.

  PERFORM get_airline_info USING zssa0180-carrid
                        CHANGING zssa0181.
ENDFORM.
