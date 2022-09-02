*&---------------------------------------------------------------------*
*& Report ZC1R010003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r010003.

TABLES: mara, marc.

DATA: gv_change.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS: pa_werks TYPE mkal-werks DEFAULT '1010',
              pa_berid TYPE pbid-berid DEFAULT '1010',
              pa_pbdnr TYPE pbid-pbdnr, "DISPLAY
              pa_versb TYPE pbid-versb DEFAULT '00'. "DISPLAY

SELECTION-SCREEN END OF BLOCK b1.


SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t02.

  PARAMETERS: ra_crt  RADIOBUTTON GROUP rb1 DEFAULT 'X' USER-COMMAND mod, "강사님 추가 코드 user-command
              ra_disp RADIOBUTTON GROUP rb1.

SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-t03.

  SELECT-OPTIONS: so_matnr FOR mara-matnr MODIF ID mar,
                  so_mtart FOR mara-mtart MODIF ID mar,
                  so_matkl FOR mara-matkl MODIF ID mar.

  SELECT-OPTIONS: so_ekgrp FOR marc-ekgrp  MODIF ID mac.
  PARAMETERS    : pa_dispo TYPE marc-dispo MODIF ID mac,
                  pa_dismm TYPE marc-dismm MODIF ID mac.

SELECTION-SCREEN END OF BLOCK b3.


AT SELECTION-SCREEN OUTPUT.
  "My code
*  IF sy-dynnr = '1000'.
*    "DISPLAY PARAMETER
*    PERFORM modify_param.
*    "RADIO BUTTON이 CRT, DISP일 때 각각 MARC, MARA 필드 안보이게.
*    PERFORM check_con.
*  ENDIF.

  "강사님 코드

  PERFORM modify_screen.





**********************************************************************
**********************************************************************
**********************************************************************






*&---------------------------------------------------------------------*
*& Form set_param
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_param .
  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'PA_PBDNR' OR 'PA_VERSB'.
        screen-input = '0'.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_screen  USING p_screen.
  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN p_screen.
        screen-active = '0'.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_con
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_con .
  CASE 'X'.
    WHEN ra_crt.
      PERFORM set_screen USING 'MAC'.
    WHEN ra_disp.
      PERFORM set_screen USING 'MAR'.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*

**********************************************************************
**********************************************************************
**********************************************************************

*& Form modify_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_screen .

  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'PA_PBDNR' OR 'PA_VERSB'.
        screen-input = '0'.
        MODIFY SCREEN.
    ENDCASE.

    CASE 'X'.
      WHEN ra_crt.
        CASE screen-group1.
          WHEN 'MAC'.
            screen-active = '0'.
            MODIFY SCREEN.
        ENDCASE.

      WHEN ra_disp.
        CASE screen-group1.
          WHEN 'MAR'.
            screen-active = '0'.
            MODIFY SCREEN.
        ENDCASE.
    ENDCASE.



  ENDLOOP.

ENDFORM.
