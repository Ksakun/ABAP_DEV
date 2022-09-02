*&---------------------------------------------------------------------*
*& Include          MZSA0101_V2_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_default .
  CLEAR zssa0130.
  SELECT SINGLE pernr
    FROM ztsa0001
    INTO zssa0130-pernr.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_domain
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_domain .
  DATA: lt_domain TYPE TABLE OF dd07v,
        ls_domain LIKE LINE OF lt_domain.
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = 'ZDGENDER_A00'
*     TEXT            = 'X'
*     FILL_DD07L_TAB  = ' '
    TABLES
      values_tab      = lt_domain
*     VALUES_DD07L    =
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
  ENDIF.

  READ TABLE lt_domain WITH KEY domvalue_l = zssa0130-gender
  INTO ls_domain.
  zssa0130-gender_t = ls_domain-ddtext.
ENDFORM.
