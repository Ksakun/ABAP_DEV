*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_EXAM02_O02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  IF p_edit = 'X'.
    SET PF-STATUS 'S200'.
  ELSE.
    SET PF-STATUS 'S200' EXCLUDING 'SAVE'.
  ENDIF.
  SET TITLEBAR 'T200' WITH sy-datum sy-uname.
ENDMODULE.
