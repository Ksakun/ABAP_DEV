*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_ALV_V3_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'SAVE'. "저장 버튼을 누를 때 DB에 저장되게 하기 위함
*      MESSAGE i000(zmcsa01) WITH 'Changed Data will Be saved in ZTSBOOK_A01'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Data Save'
*         DIAGNOSE_OBJECT       = ' '
          text_question         = 'Do you Want to Save?'
          text_button_1         = 'Yes'(001)
*         ICON_BUTTON_1         = ' '
          text_button_2         = 'No'(002)
*         ICON_BUTTON_2         = ' '
          default_button        = '1'
          display_cancel_button = 'X'
*         USERDEFINED_F1_HELP   = ' '
*         START_COLUMN          = 25
*         START_ROW             = 6
*         POPUP_TYPE            =
*         IV_QUICKINFO_BUTTON_1 = ' '
*         IV_QUICKINFO_BUTTON_2 = ' '
        IMPORTING
          answer                = p_ans
*       TABLES
*         PARAMETER             =
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      IF p_ans = '1'.
*        MESSAGE i000(zmcsa01) WITH 'TEST'.
        PERFORM data_save.
      ENDIF.

  ENDCASE.
ENDMODULE.
