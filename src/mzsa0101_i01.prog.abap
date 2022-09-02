*&---------------------------------------------------------------------*
*& Include          MZSA0101_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'BACK' OR 'CANC'.
      "leave to SCREEN 0.
      SET SCREEN 0. LEAVE SCREEN.
    WHEN 'SEARCH'.
      CLEAR zssa0031.
      "Get Data
      PERFORM get_data USING gv_pernr
                       CHANGING zssa0031.
*      MESSAGE s000(zmcsa01) WITH sy-ucomm.
*      SELECT SINGLE *
*        FROM ztsa0001"emp table
*        INTO CORRESPONDING FIELDS OF zssa0031
*        WHERE pernr = gv_pernr.
      "Using Inner Join #1
*      SELECT SINGLE *
*        FROM ztsa0001 AS emp INNER JOIN ztsa0002 AS dep
*          ON emp~depid = dep~depid
*        INTO CORRESPONDING FIELDS OF zssa0031
*        WHERE emp~pernr = gv_pernr.
      "select single 하나더 사용하기#2
      "database view 사용하기 #3
  ENDCASE.
ENDMODULE.
