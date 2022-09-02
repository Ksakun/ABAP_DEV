*&---------------------------------------------------------------------*
*& Include          MZSA0150_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ZSSA0150_CARRID
*&      <-- ZSSA0150_CARRNAME
*&---------------------------------------------------------------------*
FORM get_airline_name  USING   VALUE(p_carrid)
                       CHANGING VALUE(p_carrname).
  CLEAR p_carrname.
  SELECT SINGLE carrname
    FROM scarr
    INTO p_carrname
    WHERE carrid = p_carrid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_meal_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_meal_info USING VALUE(p_carrid)
                         VALUE(p_mealnumber)
                   CHANGING ps_info TYPE zssa0151.
  CLEAR: ps_info.
*  SELECT SINGLE *
*    FROM scarr AS air INNER JOIN smeal AS mea
*      ON air~carrid = mea~carrid
*    INTO CORRESPONDING FIELDS OF ps_info
*    WHERE air~carrid = p_carrid
*    AND   mea~mealnumber = p_mealnumber.
  SELECT SINGLE *
  FROM smeal AS mea INNER JOIN scarr AS air
    ON mea~carrid = air~carrid
  INTO CORRESPONDING FIELDS OF ps_info
  WHERE mea~carrid = p_carrid
  AND   mea~mealnumber = p_mealnumber.

  IF sy-subrc <> 0.
    MESSAGE i016(pn) WITH 'Data Not Found!'.
    RETURN.
  ENDIF.

  SELECT SINGLE text
    FROM smealt
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE mealnumber = p_mealnumber
    AND   sprache = sy-langu.

  SELECT SINGLE price waers
    FROM ztsa01ven
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE mealno = p_mealnumber.

  "예외처리 나중에 생각



ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_vendor_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_vendor_info USING VALUE(p_carrid)
                           VALUE(p_mealnumber)
                     CHANGING ps_info TYPE zssa0152.
  SELECT SINGLE *
    FROM ztsa01ven
    INTO CORRESPONDING FIELDS OF ps_info
    WHERE carrid = p_carrid
      AND mealno = p_mealnumber.

  SELECT SINGLE landx
    FROM t005t
    INTO ps_info-landx
    WHERE land1 = ps_info-land1
     AND spras = sy-langu.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_default
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_default .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_domain
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_domain  USING    VALUE(p_dom)
                          VALUE(p_mealtype)
                 CHANGING p_domtext.

  DATA: lt_domain TYPE TABLE OF dd07v,
        ls_domain LIKE LINE OF lt_domain.
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname         = p_dom
*     TEXT            = 'X'
*     FILL_DD07L_TAB  = ' '
    TABLES
      values_tab      = lt_domain
*     values_dd07l    =
    EXCEPTIONS
      no_values_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  READ TABLE lt_domain WITH KEY domvalue_l = p_mealtype INTO ls_domain.
  p_domtext = ls_domain-ddtext.
  CLEAR: lt_domain, ls_domain.
ENDFORM.
