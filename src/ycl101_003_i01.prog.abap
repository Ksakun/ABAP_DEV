*&---------------------------------------------------------------------*
*& Include          YCL101_002_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.
  save_ok = ok_code. ClEAR ok_code.

  CASE save_ok.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
      ok_code = save_ok.
  ENDCASE.

  CLEAR: save_ok.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  save_ok = ok_code. CLEAR ok_code.

  CASE save_ok.
    WHEN 'SEARCH'.
      PERFORM select_data.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
