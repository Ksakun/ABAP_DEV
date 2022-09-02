*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_ALV_04_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT *
    FROM ztsflight_a01
    INTO CORRESPONDING FIELDS OF TABLE gt_flight
   WHERE carrid IN so_car
     AND connid IN so_con
     AND fldate IN so_fld.

  LOOP AT gt_flight INTO gs_flight.
    "Exception Handling
    IF gs_flight-price < 400.
      gs_flight-light = '1'.
    ELSEIF gs_flight-price < 600.
      gs_flight-light = '2'.
    ELSE.
      gs_flight-light = '3'.
    ENDIF.



    MODIFY gt_flight FROM gs_flight.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .

  "Selection Mode
  gs_layout-sel_mode = 'D'.
  "Exception Handling
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led = 'X'.
ENDFORM.
