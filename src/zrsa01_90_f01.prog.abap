*&---------------------------------------------------------------------*
*& Include          ZRSA01_90_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_domain_text
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_domain_text .
  DATA: lt_dom_value TYPE TABLE OF dd07v,
        ls_dom_value LIKE LINE OF lt_dom_value.

  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = 'ZEVENCA_A01'
*     TEXT            = 'X'
*     FILL_DD07L_TAB  = ' '
    TABLES
      values_tab      = lt_dom_value
*     VALUES_DD07L    =
    exceptions
      no_values_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  CLEAR ls_dom_value.
  READ TABLE lt_dom_value WITH KEY domvalue_l = gs_data-venca
    INTO ls_dom_value.

  IF sy-subrc = 0.
    gs_data-venca_t = ls_dom_value-ddtext.
  ENDIF.

ENDFORM.
