*&---------------------------------------------------------------------*
*& Include          MZSA0150_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_TS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_ts_0100 OUTPUT.
  CASE ts_info-activetab.
    WHEN 'TAB1'.
      gv_dynnr = '0101'.
    WHEN 'TAB2'.
      gv_dynnr = '0102'.
    WHEN OTHERS.
      gv_dynnr = '0101'.
      ts_info-activetab = 'TAB1'.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_GV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE clear_gv OUTPUT.
  CLEAR: gv_subrc, ok_code.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_RADIO_BUTTON OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_radio_button OUTPUT.
  "Inflight Conditon Radio Button
  IF gv_r1 = 'X'.
    LOOP AT SCREEN.
      CASE screen-name.
        WHEN 'ZSSA0150-CARRID' OR 'ZSSA0150-MEALNUMBER'.
          screen-input = 1.
        WHEN 'ZSSA0150-LIFNR'.
          screen-input = 0.
      ENDCASE.
      MODIFY SCREEN.
      CLEAR screen.
    ENDLOOP.
  ELSEIF gv_r2 = 'X'. "Vendor Condition Radio Button

    LOOP AT SCREEN.
      CASE screen-name.
        WHEN 'ZSSA0150-CARRID' OR 'ZSSA0150-MEALNUMBER'.
          screen-input = 0.
        WHEN 'ZSSA0150-LIFNR'.
          screen-input = 1.
      ENDCASE.
      MODIFY SCREEN.
      CLEAR screen.
    ENDLOOP.
  ENDIF.
ENDMODULE.
