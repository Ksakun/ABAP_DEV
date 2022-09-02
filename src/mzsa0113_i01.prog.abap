*&---------------------------------------------------------------------*
*& Include          MZSA0110_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      PERFORM get_airline_name USING zssa0180-carrid
                               CHANGING zssa0180-carrname.
    WHEN 'SEARCH'.
*       PERFORM get_airline_info USING zssa0180-carrid
*                        CHANGING zssa0181.

       PERFORM get_conn_info USING zssa0180-carrid
                                  zssa0180-connid
                            CHANGING zssa0182
                                     gv_subrc.
       "에러 핸들링 쉬운 방법 #2
       IF gv_subrc <> 0.
         MESSAGE i016(pn) WITH 'Data Not Found #2'.
         RETURN.
       ENDIF.
    WHEN 'TAB1' OR 'TAB2'.
      ts_info-activetab = ok_code.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check INPUT.
  IF zssa0180-carrid = 'AF'.

    MESSAGE i016(pn) WITH 'Check, AF'.
  ENDIF.
ENDMODULE.
