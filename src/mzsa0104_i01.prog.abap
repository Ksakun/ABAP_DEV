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
*      CLEAR zssa0073-ename.
*      SELECT SINGLE ename
*        FROM ztsa0001
*        INTO zssa0073-ename
*        WHERE pernr = zssa0073-pernr.
    WHEN 'SEARCH'.
      PERFORM get_emp_name USING zssa0073-pernr
                           CHANGING zssa0073-ename.
      PERFORM get_emp_info USING zssa0073-pernr
                           CHANGING zssa0070.
      PERFORM get_dep_info USING zssa0070-depid
                           CHANGING zssa0071.


    WHEN 'DEP'.
      CALL SCREEN 101 STARTING AT 10 10.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  CASE sy-ucomm.
    WHEN 'CLOSE'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
