*&---------------------------------------------------------------------*
*& Include          MZSA0104_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
*  `MESSAGE i016(pn) WITH ok_code.
  CASE ok_code.
    WHEN 'BACK'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.

    WHEN 'SEARCH'.
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.
      PERFORM get_emp_info USING zssa0073-pernr
                           CHANGING zssa0070.
      PERFORM get_dep_info USING zssa0070-depid
                           CHANGING zssa0071.
    WHEN 'TAB1' OR 'TAB2'.
      ts_info-activetab = ok_code.
  ENDCASE.
ENDMODULE.
