*&---------------------------------------------------------------------*
*& Include          MZSA0101_V2_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code."sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      "EMP
      SELECT SINGLE *
        FROM ztsa0001
        INTO CORRESPONDING FIELDS OF zssa0130
        WHERE pernr = zssa0130-pernr.
      "DEP
      SELECT SINGLE *
        FROM ztsa0002
        INTO CORRESPONDING FIELDS OF zssa0130
        WHERE depid = zssa0130-depid.
      "get Lang Text
      SELECT SINGLE dtext
        FROM ztsa0002_t
        INTO zssa0130-dtext
        WHERE depid = zssa0130-depid
        AND spras = sy-langu.

      "Get Gender Text
      PERFORM get_domain.
      "Exception Handling
      IF zssa0130-pernr IS INITIAL.
        MESSAGE s000(zmcsa01) WITH 'No Such DATA'.
      ELSE.
        SET SCREEN 200.
      ENDIF.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 100.
  ENDCASE.
ENDMODULE.
