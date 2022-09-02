*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_EXAM02_I02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  GET_DATA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_data INPUT.
  CLEAR: wt_carr, wt_conn.

  "GET carrid
  IF ztspfli_a01-carrid IS NOT INITIAL.
    ws_carr-sign = 'I'.
    ws_carr-option = 'EQ'.
    ws_carr-low   = ztspfli_a01-carrid.
    APPEND ws_carr TO wt_carr.
    CLEAR ws_carr.
*  ELSE.
*    MESSAGE i000(zmcsa01) WITH 'Enter Airline Code'.
  ENDIF.

  "GET connid
  IF ztspfli_a01-connid IS NOT INITIAL.
    ws_conn-sign = 'I'.
    ws_conn-option = 'EQ'.
    ws_conn-low    = ztspfli_a01-connid.
    APPEND ws_conn TO wt_conn.
    CLEAR ws_conn.
  ENDIF.

  SELECT *
    FROM ztspfli_a01
    INTO CORRESPONDING FIELDS OF TABLE gt_flight
   WHERE carrid IN wt_carr
     AND connid IN wt_conn.

  PERFORM get_grid_data.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CREATE_DROPDOWN_BOX  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE create_dropdown_box INPUT.

  TYPES: BEGIN OF conn_line,
           conn TYPE spfli-connid,
         END OF conn_line.

  DATA: conn_list TYPE STANDARD TABLE OF conn_line.

  SELECT connid
    FROM spfli
    INTO TABLE conn_list
   WHERE carrid = ztspfli_a01-carrid.


  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CONNID'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZTSPFLI_A01-CONNID'
      value_org       = 'S'
    TABLES
      value_tab       = conn_list
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.


ENDMODULE.
