*&---------------------------------------------------------------------*
*& Report ZRSA01_12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_12.

DATA gv_carrname TYPE scarr-carrname.
PARAMETERS pa_carr TYPE scarr-carrid.

"Get Airline Name
*SELECT SINGLE carrname
*  FROM scarr
*  INTO gv_carrname
* WHERE carrid = pa_carr.

PERFORM carr_info USING pa_carr
                  CHANGING gv_carrname.

*Dispaly Airline Info
*&---------------------------------------------------------------------*
*& Form carr_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM carr_info USING p_input
               CHANGING  p_result.
  p_input = 'UA'.
  SELECT SINGLE carrname
    FROM scarr
    INTO p_result
   WHERE carrid = p_input.

   WRITE 'test gv_carrname'.
   WRITE gv_carrname.

  IF sy-subrc = 0.
    "WRITE: p_result.
  ELSE.
    "WRITE: 'Wrong Airline Code'.
  ENDIF.

ENDFORM.
