*&---------------------------------------------------------------------*
*& Include          ZC1R010008_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CALL METHOD: gcl_grid->free( ), gcl_container->free( ).

  FREE: gcl_grid, gcl_container.

  LEAVE TO SCREEN 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'SAVE'.
      CLEAR ok_code.
      PERFORM save_data.
    WHEN 'CREATE'.
      CLEAR ok_code.
      PERFORM create_row.
    WHEN 'DELETE'.
      CLEAR ok_code.
      PERFORM delete_row.
    WHEN 'REFRESH'.
      CLEAR ok_code.
      PERFORM get_data.
      PERFORM refresh_grid.

  ENDCASE.

ENDMODULE.
