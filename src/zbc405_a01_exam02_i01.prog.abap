*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_EXAM01_I01
*&---------------------------------------------------------------------*
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
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'SAVE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Data Save'
*         DIAGNOSE_OBJECT       = ' '
          text_question         = 'Do you want to save?'
          text_button_1         = 'Yes'
*         ICON_BUTTON_1         = ' '
          text_button_2         = 'No'
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
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.


      IF p_ans = 1.
        PERFORM data_save.
      ENDIF.

  ENDCASE.
ENDMODULE.
