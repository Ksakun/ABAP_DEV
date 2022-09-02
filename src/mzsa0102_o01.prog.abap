*&---------------------------------------------------------------------*
*& Include          MZSA0102_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH sy-datum.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_DEFAULT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_default OUTPUT.
  IF zssa0160 IS INITIAL.
    zssa0160-carrid = 'AA'.
    zssa0160-connid ='0017'.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_SCREEN_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE modify_screen_0100 OUTPUT.
*  LOOP AT SCREEN.
*     CASE screen-name.
*       WHEN 'ZSSA0160-CARRID'.
*        IF sy-uname <> 'KD-A-01'.
*           screen-input = 0.
*           screen-active = 0.
*        ELSE.
*          screen-input = 1. "Display Mode(Input not Possible)
*          screen-active = 1.
*        ENDIF.
*       MODIFY SCREEN.
*      CLEAR screen.
*     ENDCASE.
*  ENDLOOP.
  "그룹화로 관리 가능
  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GR1'.
        screen-active = 1.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
